  import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:hey_weather/repository/soruce/local/weather_dao.dart';
import 'package:hey_weather/repository/soruce/mapper/weather_mapper.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';
import 'package:hey_weather/repository/soruce/remote/result.dart';
import 'package:hey_weather/repository/soruce/remote/weather_api.dart';

class WeatherRepository {

  final WeatherApi _api;
  final WeatherDao _dao;

  WeatherRepository(this._api, this._dao);

  Future<Position> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  // 현재 좌표 주소 조회
  Future<Result<Address>> getAddressWithCoordinate() async {
    final localList = await _dao.getAllAddressList();
    Position position = await _getLocation();

    // 로컬에 있고 좌표값 변경이 없는 경우 로컬 리턴
    if (localList.isNotEmpty) {
      print('getAddressWithCoordinate() -> local return');
      return Result.success(localList.first.toAddress());
    }

    // 카카오 주소 검색
    try {
      final response = await _api.getAddressWithCoordinate(
          position.longitude, position.latitude);
      final jsonResult = jsonDecode(response.body);
      AddressList result = AddressList.fromJson(jsonResult);
      Address address = Address();
      if (result.documents != null) {
        address = result.documents![0];
        _dao.clearAddress();
        _dao.insertAddress(address.toAddressEntity());
      }
      print('getAddressWithCoordinate() -> api return');
      return Result.success(address);
    } catch (e) {
      return Result.error(
          Exception('getAddressWithCoordinate failed: ${e.toString()}'));
    }
  }
}
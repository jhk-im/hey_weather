  import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:hey_weather/repository/soruce/local/weather_dao.dart';
import 'package:hey_weather/repository/soruce/mapper/weather_mapper.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';
import 'package:hey_weather/repository/soruce/remote/result.dart';
import 'package:hey_weather/repository/soruce/remote/weather_api.dart';
import 'package:logger/logger.dart';

class WeatherRepository {

  final WeatherApi _api;
  final WeatherDao _dao;

  WeatherRepository(this._api, this._dao);

  var logger = Logger();

  Future<Position> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치권한 허용 안한경우 서울 시청 좌표를 기본으로 함
    Position defaultPosition = Position(
        longitude: 126.97723484374212,
        latitude: 37.56770871576262,
        timestamp: DateTime.timestamp(),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0
    );

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //return Future.error('Location services are disabled.');
      return defaultPosition;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // return Future.error('Location permissions are denied');
        return defaultPosition;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return defaultPosition;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  // 현재 좌표 주소 업데이트
  Future<Result<Address>> getUpdateAddressWithCoordinate() async {
    Position position = await _getLocation();

    // 좌표값 변경이 없는 경우 로컬 리턴
    final localList = await _dao.getAllAddressList();
    if (localList.isNotEmpty) {
      final entity = localList.first;
      logger.i('getAddressWithCoordinate() -> local ${entity.toAddress()}');
      if (entity.x == position.longitude && entity.y == position.latitude) {
        logger.i('getAddressWithCoordinate() -> local return');
        return Result.success(entity.toAddress());
      }
    }

    // 카카오 주소 검색
    try {
      final response = await _api.getAddressWithCoordinate(
          position.longitude, position.latitude);
      final jsonResult = jsonDecode(response.body);
      AddressList result = AddressList.fromJson(jsonResult);
      Address address = Address();

      logger.i('getAddressWithCoordinate() -> api ${result.documents}');
      if (result.documents != null) {
        address = result.documents![0];
        address.x = position.longitude;
        address.y = position.latitude;

        if (localList.isEmpty){
          logger.i('getAddressWithCoordinate() -> api insert');
          _dao.insertAddress(address.toAddressEntity());
        } else {
          logger.i('getAddressWithCoordinate() -> api update');
          _dao.updateAddressWithIndex(0, address.toAddressEntity());
        }
      }
      return Result.success(address);
    } catch (e) {
      return Result.error(Exception('getAddressWithCoordinate failed: ${e.toString()}'));
    }
  }

  //
}
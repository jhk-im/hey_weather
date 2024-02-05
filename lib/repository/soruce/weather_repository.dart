  import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/utils.dart';
import 'package:hey_weather/repository/soruce/local/weather_dao.dart';
import 'package:hey_weather/repository/soruce/mapper/weather_mapper.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';
import 'package:hey_weather/repository/soruce/remote/model/search_address.dart';
import 'package:hey_weather/repository/soruce/remote/result/result.dart';
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

  // 현재 좌표 주소
  Future<Result<Address>> getUpdateAddressWithCoordinate() async {
    Position position = await _getLocation();
    logger.i('getUpdateAddressWithCoordinate() -> position -> $position');

    // 좌표값 변경이 없는 경우 로컬 리턴
    final current = await _dao.getUserAddressWithId(kCurrentLocationId);
    if (current != null) {
      final currentX = current.x!.toStringAsFixed(3);
      final positionX = position.longitude.toStringAsFixed(3);
      final currentY = current.y!.toStringAsFixed(3);
      final positionY = position.latitude.toStringAsFixed(3);
      if (currentX == positionX && currentY == positionY) {
        logger.i('getAddressWithCoordinate() -> local return ${current.toAddress()}');
        return Result.success(current.toAddress());
      }
    }

    // 통신 오류용 기본 주소 정보
    Address defaultAddress = Address();
    defaultAddress.addressName = '태평로1가';
    defaultAddress.region1depthName = '서울특별시';
    defaultAddress.region2depthName = '중구';
    defaultAddress.region3depthName = '태평로1가';
    defaultAddress.x = 126.97723484374212;
    defaultAddress.y = 37.56770871576262;
    defaultAddress.id = kCurrentLocationId;

    // 인터넷 연결 끊김
    var connect =  await Utils.checkInternetConnection();
    if (!connect) {
      if (current != null) {
        logger.i('getAddressWithCoordinate() -> network not connected local return ${current.toAddress()}');
        return Result.success(current.toAddress());
      } else {
        logger.i('getAddressWithCoordinate() -> network not connected return $defaultAddress');
        _dao.updateUserAddressWithId(kCurrentLocationId, defaultAddress.toAddressEntity());
        return Result.success(defaultAddress);
      }
    } else {
      // 좌표로 주소 검색
      try {
        final response = await _api.getAddressWithCoordinate(position.longitude, position.latitude);
        final jsonResult = jsonDecode(response.body);
        AddressList result = AddressList.fromJson(jsonResult);
        Address address = Address();
        if (result.documents != null) {
          address = result.documents![0];
          address.addressName = '${address.region3depthName}';
          address.x = position.longitude;
          address.y = position.latitude;
          address.id = kCurrentLocationId;

          logger.i('getAddressWithCoordinate() -> kakao api return $address');
          _dao.updateUserAddressWithId(kCurrentLocationId, address.toAddressEntity());
          return Result.success(address);
        } else {
          logger.i('getAddressWithCoordinate() -> kakao api failed return $defaultAddress');
          _dao.updateUserAddressWithId(kCurrentLocationId, defaultAddress.toAddressEntity());
          return Result.success(defaultAddress);
        }
      } catch (e) {
        logger.i('getAddressWithCoordinate() -> kakao api failed return $defaultAddress');
        _dao.updateUserAddressWithId(kCurrentLocationId, defaultAddress.toAddressEntity());
        return Result.success(defaultAddress);
      }
    }
  }

  // 로컬 주소 리스트
  Future<Result<List<Address>>> getUserAddressList() async {
    final list = await _dao.getAllUserAddressList();
    if (list.isNotEmpty) {
      return Result.success(list.map((e) => e.toAddress()).toList());
    } else {
      return Result.error(Exception('getAddressList empty'));
    }
  }

  // 주소 검색
  Future<Result<List<SearchAddress>>> getSearchAddress(String query) async {
    // 카카오 주소 검색
    try {
      final response = await _api.getSearchAddress(query);
      final jsonResult = jsonDecode(response.body);
      SearchAddressList result = SearchAddressList.fromJson(jsonResult);
      if (result.documents != null) {
        return Result.success(result.documents!);
      } else {
        return Result.error(Exception('getSearchAddress empty'));
      }
    } catch (e) {
      return Result.error(Exception('getSearchAddress failed: ${e.toString()}'));
    }
  }

  // id로 주소 추가
  Future updateUserAddressWithId(Address address) async {
    logger.i('updateUserAddressWithId() -> $address');
    await _dao.updateUserAddressWithId(address.id!, address.toAddressEntity());
  }

  // 편집한 주소 순서 id 리스트
  Future<Result<List<String>>> getUserAddressEditIdList() async {
    final list = await _dao.getUserAddressEditIdList();
    if (list != null) {
      return Result.success(list);
    } else {
      return Result.error(Exception('getUserAddressEditIdList empty'));
    }
  }

  // 편집 주소 추가
  Future insertUserAddressEditIdList(String id) async {
    logger.i('insertUserAddressEditIdList(id: $id)');
    final idList = await _dao.getUserAddressEditIdList();
    if (idList == null) {
      await _dao.updateUserAddressEdit([id]);
    } else {
      idList.insert(0, id);
      await _dao.updateUserAddressEdit(idList);
    }
  }

  // 편집 주소 업데이트
  Future updateUserAddressEditIdList(List<String> idList) async {
    logger.i('updateUserAddressEditIdList(idList: $idList)');
    await _dao.updateUserAddressEdit(idList);
  }

  // 최근 선택한 주소 순서 id 리스트
  Future<Result<List<String>>> getUserAddressRecentIdList() async {
    final list = await _dao.getUserAddressRecentIdList();
    if (list != null) {
      return Result.success(list);
    } else {
      return Result.error(Exception('getUserAddressRecentIdList empty'));
    }
  }

  // 최근 선택한 순서 업데이트
  Future insertUserAddressRecentIdList(String id, {bool isSelect = false}) async {
    logger.i('insertUserAddressRecentIdList(id: $id)');
    final idList = await _dao.getUserAddressRecentIdList();
    if (idList == null) {
      await _dao.updateUserAddressRecent([id]);
    } else {
      if (isSelect) {
        if (idList.contains(id)) {
          idList.remove(id);
          idList.insert(0, id);
        } else {
          idList.insert(0, id);
        }
      } else {
        idList.add(id);
      }
      await _dao.updateUserAddressRecent(idList);
    }
  }

  // 최근 선택 주소 업데이트
  Future updateUserAddressRecentIdList(List<String> idList) async {
    logger.i('updateUserAddressRecentIdList(idList: $idList)');
    await _dao.updateUserAddressEdit(idList);
  }

  // 주소 삭제
  Future deleteUserAddressWithId(String addressId) async {
    await _dao.deleteUserAddressWithId(addressId);
    final recentIdList = await _dao.getUserAddressRecentIdList();
    if (recentIdList != null) {
      recentIdList.remove(addressId);
      updateUserAddressRecentIdList(recentIdList);
    }
  }
}
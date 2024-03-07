import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/convert_gps.dart';
import 'package:hey_weather/common/shared_preferences_util.dart';
import 'package:hey_weather/common/utils.dart';
import 'package:hey_weather/repository/soruce/local/csv/mid_code_parser.dart';
import 'package:hey_weather/repository/soruce/local/csv/observatory_parser.dart';
import 'package:hey_weather/repository/soruce/local/weather_dao.dart';
import 'package:hey_weather/repository/soruce/mapper/weather_mapper.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';
import 'package:hey_weather/repository/soruce/local/model/search_address.dart';
import 'package:hey_weather/repository/soruce/local/model/user_notification.dart';
import 'package:hey_weather/repository/soruce/remote/model/fine_dust.dart';
import 'package:hey_weather/repository/soruce/remote/model/mid_code.dart';
import 'package:hey_weather/repository/soruce/remote/model/mid_term_land.dart';
import 'package:hey_weather/repository/soruce/remote/model/mid_term_temperature.dart';
import 'package:hey_weather/repository/soruce/remote/model/observatory.dart';
import 'package:hey_weather/repository/soruce/remote/model/short_term.dart';
import 'package:hey_weather/repository/soruce/remote/model/sun_rise_set.dart';
import 'package:hey_weather/repository/soruce/remote/model/ultra_short_term.dart';
import 'package:hey_weather/repository/soruce/remote/model/ultraviolet.dart';
import 'package:hey_weather/repository/soruce/remote/model/weather_category.dart';
import 'package:hey_weather/repository/soruce/remote/result/result.dart';
import 'package:hey_weather/repository/soruce/remote/weather_api.dart';
import 'package:logger/logger.dart';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';

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

  /// KAKAO 좌표로 주소 검색
  Future<Result<Address>> getUpdateAddressWithCoordinate(String currentAddressId, {String? addressName}) async {
    Position? position;

    // 좌표값 변경이 없는 경우 로컬 리턴
    final current = await _dao.getUserAddressWithId(currentAddressId);

    if (currentAddressId == kCurrentLocationId) {
      position = await _getLocation();
      logger.i('getUpdateAddressWithCoordinate() -> position -> $position');
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
        double longitude = 0;
        double latitude = 0;
        if (position != null) {
          longitude = position.longitude;
          latitude = position.latitude;
        } else {
          longitude = current?.x ?? 0;
          latitude = current?.y ?? 0;
        }
        logger.i('getUpdateAddressWithCoordinate() longitude -> $longitude, latitude -> $latitude');

        final response = await _api.getAddressWithCoordinate(longitude, latitude);
        final jsonResult = jsonDecode(response.body);
        AddressList result = AddressList.fromJson(jsonResult);
        Address address = Address();
        if (result.documents != null) {
          address = result.documents![0];
          if (currentAddressId == kCurrentLocationId) {
            address.addressName = '${addressName ?? address.region3depthName}';
          } else {
            if (current != null) {
              address.addressName = current.addressName ?? '';
              address.createDateTime = current.createDateTime ?? '';
            }
          }
          address.x = longitude;
          address.y = latitude;
          address.id = currentAddressId;


          logger.i('getAddressWithCoordinate() -> kakao api return $address');
          _dao.updateUserAddressWithId(currentAddressId, address.toAddressEntity());
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

  Future<Result<Address>> createAddressWithCoordinate(String currentAddressId, {String? addressName}) async {
    Position? position;

    // 좌표값 변경이 없는 경우 로컬 리턴
    final current = await _dao.getUserAddressWithId(currentAddressId);

    if (currentAddressId == kCurrentLocationId) {
      position = await _getLocation();
      logger.i('getUpdateAddressWithCoordinate() -> position -> $position');
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
        double longitude = 0;
        double latitude = 0;
        if (position != null) {
          longitude = position.longitude;
          latitude = position.latitude;
        } else {
          longitude = current?.x ?? 0;
          latitude = current?.y ?? 0;
        }
        logger.i('getUpdateAddressWithCoordinate() longitude -> $longitude, latitude -> $latitude');

        final response = await _api.getAddressWithCoordinate(longitude, latitude);
        final jsonResult = jsonDecode(response.body);
        AddressList result = AddressList.fromJson(jsonResult);
        Address address = Address();
        if (result.documents != null) {
          address = result.documents![0];
          if (currentAddressId == kCurrentLocationId) {
            address.addressName = '${addressName ?? address.region3depthName}';
          } else {
            if (current != null) {
              address.addressName = current.addressName ?? '';
              address.createDateTime = current.createDateTime ?? '';
            }
          }
          address.x = longitude;
          address.y = latitude;
          address.id = currentAddressId;


          logger.i('getAddressWithCoordinate() -> kakao api return $address');
          _dao.updateUserAddressWithId(currentAddressId, address.toAddressEntity());
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

  /// 주소 정보
  Future<Result<List<Address>>> getUserAddressList() async {
    final list = await _dao.getAllUserAddressList();
    if (list.isNotEmpty) {
      return Result.success(list.map((e) => e.toAddress()).toList());
    } else {
      return Result.error(Exception('getAddressList empty'));
    }
  }

  // id로 주소 추가
  Future updateUserAddressWithId(Address address) async {
    logger.i('updateUserAddressWithId() -> $address');
    await _dao.updateUserAddressWithId(address.id!, address.toAddressEntity());
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

  /// 편집 주소 리스트 정보
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
    await _dao.updateUserAddressEdit(idList.toSet().toList());
  }

  /// 최근 선택한 주소 리스트 정보
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
    await _dao.updateUserAddressEdit(idList.toSet().toList());
  }

  /// 알림 리스트
  Future<Result<List<UserNotification>>> getUserNotificationList() async {
    final list = await _dao.getUserNotificationList();
    if (list != null) {
      return Result.success(list.map((e) => e.toUserNotification()).toList());
    } else {
      return Result.error(Exception('getUserNotificationList empty'));
    }
  }

  // 알림 업데이트
  Future updateUserNotification(UserNotification notification) async {
    logger.i('updateUserNotification(notification: $notification)');
    await _dao.updateUserNotification(notification.id ?? '', notification.toUserNotificationEntity());
  }

  // 알림 삭제
  Future deleteUserNotification(String id) async {
    await _dao.deleteUserNotification(id);
  }

  /// My Weather
  Future<Result<List<String>?>> getUserMyWeather() async {
    final list = await _dao.getUserMyWeatherIdList();
    if (list != null) {
      return Result.success(list);
    } else {
      return Result.error(Exception('getUserMyWeather empty'));
    }
  }
  Future updateUserMyWeather(List<String> idList) async {
    logger.i('updateUserMyWeather(idList: $idList)');
    return _dao.updateUserMyWeather(idList.toSet().toList());
  }

  /// Weather API
  // 날씨 category 에 따른 정보 (초단기, 단기)
  Future<WeatherCategory> getWeatherCode(String category) async {
    final jsonString = await rootBundle.loadString('assets/data/code.json');
    final jsonObject = jsonDecode(jsonString);
    return WeatherCategory.fromJson(jsonObject[category]);
  }

  // 초단기 실황
  Future<Result<List<UltraShortTerm>>> getUltraShortTermList(String id, double longitude, double latitude) async {
    final ultraShortTemperature = await _dao.getWeatherUltraShortTemperature(id);
    final ultraShortHumidity = await _dao.getWeatherUltraShortHumidity(id);
    final ultraShortRain = await _dao.getWeatherUltraShortRain(id);
    final ultraShortRainStatus = await _dao.getWeatherUltraShortRainStatus(id);
    final ultraShortWindSpeed = await _dao.getWeatherUltraShortWindSpeed(id);
    final ultraShortWindDirection = await _dao.getWeatherUltraShortWindDirection(id);
    List<UltraShortTerm> result = [];

    // 시간 기준 업데이트
    DateTime dateTime = DateTime.now();
    String dt = DateTime(dateTime.year, dateTime.month, dateTime.day,
        dateTime.hour, dateTime.minute - 30)
        .toString()
        .replaceAll(RegExp("[^0-9\\s]"), "")
        .replaceAll(" ", "");
    String date = dt.substring(0, 8);
    String time = dt.substring(8, 12);
    String checkTime = dt.substring(8, 10);

    // local
    if (ultraShortTemperature != null && ultraShortTemperature.baseTime != null) {
      String localTime = ultraShortTemperature.baseTime!.substring(0, 2);
      String localDate = ultraShortTemperature.baseDate ?? '';
      if (date == localDate) {
        if (checkTime == localTime) {
          result.add(ultraShortTemperature.toUltraShortTerm());
          if (ultraShortHumidity != null) result.add(ultraShortHumidity.toUltraShortTerm());
          if (ultraShortRain != null) result.add(ultraShortRain.toUltraShortTerm());
          if (ultraShortRainStatus != null) result.add(ultraShortRainStatus.toUltraShortTerm());
          if (ultraShortWindSpeed != null) result.add(ultraShortWindSpeed.toUltraShortTerm());
          if (ultraShortWindDirection != null) result.add(ultraShortWindDirection.toUltraShortTerm());
          logger.i('getUltraShortTerm() -> local return');
          return Result.success(result);
        }
      }
    }

    // get location
    var gpsToData = ConvertGps.gpsToGRID(latitude, longitude);
    int x = gpsToData['x'];
    int y = gpsToData['y'];

    // remote
    try {
      final response = await _api.getUltraShortTerm(date, time, x, y);
      final jsonResult = jsonDecode(response.body);
      UltraShortTermList list = UltraShortTermList.fromJson(jsonResult['response']['body']);
      if (list.items?.item != null) {
        for (var item in list.items!.item!) {

          String category = item.category ?? '';
          item.weatherCategory = await getWeatherCode(category);
          result.add(item);

          // local update
          if (id != kCreateWidgetId) {
            switch (category) {
              case kWeatherCategoryTemperature:
                await _dao.updateWeatherUltraShortTemperature(id, item.toWeatherUltraShortTermEntity());
              case kWeatherCategoryHumidity:
                await _dao.updateWeatherUltraShortHumidity(id, item.toWeatherUltraShortTermEntity());
              case kWeatherCategoryRain:
                await _dao.updateWeatherUltraShortRain(id, item.toWeatherUltraShortTermEntity());
              case kWeatherCategoryRainStatus:
                await _dao.updateWeatherUltraShortRainStatus(id, item.toWeatherUltraShortTermEntity());
              case kWeatherCategoryWindSpeed:
                await _dao.updateWeatherUltraShortWindSpeed(id, item.toWeatherUltraShortTermEntity());
              case kWeatherCategoryWindDirection:
                await _dao.updateWeatherUltraShortWindDirection(id, item.toWeatherUltraShortTermEntity());
            }
          }
        }
      }
      logger.i('getUltraShortTerm() api return');
      return Result.success(result);
    } catch (e) {
      return Result.error(Exception('getUltraShortTerm failed: ${e.toString()}'));
    }
  }


  // 초단기 예보 (현재 시각 - 6시간)
  Future<Result<List<ShortTerm>>> getUltraShortTermSixTime(String id, double longitude, double latitude) async {
    final shortTermSixTime = await _dao.getWeatherShortListSixTime(id);

    // 시간 기준 업데이트
    DateTime dateTime = DateTime.now();
    String dt = DateTime(dateTime.year, dateTime.month, dateTime.day,
        dateTime.hour, dateTime.minute - 30)
        .toString()
        .replaceAll(RegExp("[^0-9\\s]"), "")
        .replaceAll(" ", "");
    String date = dt.substring(0, 8);
    String checkTime = dt.substring(8, 10);

    // local
    if (shortTermSixTime != null && shortTermSixTime.items?.isNotEmpty == true) {
      String localTime = shortTermSixTime.items![0].baseTime!.substring(0, 2);
      String localDate = shortTermSixTime.items![0].baseDate ?? '';
      if (date == localDate) {
        if (checkTime == localTime) {
          logger.i('getShortTermSixTime() -> local return');
          var result = shortTermSixTime.items!.map((e) => e.toShortTerm()).toList();
          return Result.success(result);
        }
      }
    }

    // get location
    var gpsToData = ConvertGps.gpsToGRID(latitude, longitude);
    int x = gpsToData['x'];
    int y = gpsToData['y'];

    // remote
    try {
      logger.i('getUltraShortTermSixTime(x: $x, y: $y)');
      final response = await _api.getUltraShortTermSixTime(x, y);
      final jsonResult = jsonDecode(response.body);
      ShortTermList list = ShortTermList.fromJson(jsonResult['response']['body']);
      List<ShortTerm> result = [];
      if (list.items?.item != null) {
        for (var item in list.items!.item!) {
          item.weatherCategory = await getWeatherCode(item.category ?? '');
          result.add(item);
        }
      }

      // local update
      if (result.isNotEmpty && id != kCreateWidgetId) {
        _dao.updateWeatherShortListSixTime(id, result);
      }

      logger.i('getShortTermSixTime() -> api return');
      return Result.success(result);
    } catch (e) {
      return Result.error(Exception('getUltraShortTermSixTime failed: ${e.toString()}'));
    }
  }

  // 단기 예보 (오늘, 내일)
  Future<Result<List<ShortTerm>>> getShortTermList(String id, double longitude, double latitude) async {
    final shortTermList = await _dao.getWeatherShortListTemperature(id);

    DateTime dateTime = DateTime.now();
    String dt = DateTime(dateTime.year, dateTime.month, dateTime.day - 1)
        .toString()
        .replaceAll(RegExp("[^0-9\\s]"), "")
        .replaceAll(" ", "");
    String date = dt.substring(0, 8);

    // filter
    DateTime currentDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour - 1);
    var twelveHoursLater = currentDateTime.add(const Duration(hours: 13));

    // local
    if (shortTermList != null
        && shortTermList.items != null
        && shortTermList.items!.isNotEmpty
        && shortTermList.items![0].baseTime != null) {
      String localDate = shortTermList.items![0].baseDate ?? '';
      if (date == localDate) {
        if (/*callTime == localTime*/true) {
          logger.i('getShortTermList() -> local return');

          var result = shortTermList.items!.map((e) => e.toShortTerm()).toList();

          _updateOthers(result);

          var filterList = result.where((item) {
            var forecastDateTime = DateTime.parse("${item.fcstDate} ${item.fcstTime.toString().padLeft(4, '0')}");
            return forecastDateTime.isAfter(currentDateTime) && forecastDateTime.isBefore(twelveHoursLater);
          }).toList();

          return Result.success(filterList);
        }
      }
    }

    // get location
    var gpsToData = ConvertGps.gpsToGRID(latitude, longitude);
    int x = gpsToData['x'];
    int y = gpsToData['y'];

    // remote
    try {
      logger.i('getShortTermList(date: $date, time: 2300, x: $x, y: $y)');
      final response = await _api.getShortTerm(date, '2300', x, y);
      final jsonResult = jsonDecode(response.body);
      ShortTermList list = ShortTermList.fromJson(jsonResult['response']['body']);
      List<ShortTerm> result = [];
      if (list.items?.item != null) {
        for (var item in list.items!.item!) {
          item.weatherCategory = await getWeatherCode(item.category ?? '');
          result.add(item);
        }
      }

      // local update
      if (result.isNotEmpty && id != kCreateWidgetId) {
        _dao.updateWeatherShortListTemperature(id, result);
      }

      _updateOthers(result);

      logger.i('getShortTermList() -> api return');
      var filterList = result.where((item) {
        var forecastDateTime = DateTime.parse("${item.fcstDate} ${item.fcstTime.toString().padLeft(4, '0')}");
        return forecastDateTime.isAfter(currentDateTime) && forecastDateTime.isBefore(twelveHoursLater);
      }).toList();

      return Result.success(filterList);
    } catch (e) {
      return Result.error(Exception('getShortTermList failed: ${e.toString()}'));
    }
  }

  Future<Result<List<ShortTerm>>> getYesterdayShortTermList(String id, double longitude, double latitude) async {
    final shortTermList = await _dao.getWeatherYesterdayShortListTemperature(id);

    DateTime dateTime = DateTime.now();
    String dt = DateTime(dateTime.year, dateTime.month, dateTime.day - 1)
        .toString()
        .replaceAll(RegExp("[^0-9\\s]"), "")
        .replaceAll(" ", "");
    String date = dt.substring(0, 8);

    // filter
    // DateTime currentDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour - 1);
    // var twelveHoursLater = currentDateTime.add(const Duration(hours: 13));

    // local
    if (shortTermList != null
        && shortTermList.items != null
        && shortTermList.items!.isNotEmpty
        && shortTermList.items![0].baseTime != null) {
      String localDate = shortTermList.items![0].baseDate ?? '';
      if (date == localDate) {
        logger.i('getYesterdayShortTermList() -> local return');
        var result = shortTermList.items!.map((e) => e.toShortTerm()).toList();
        _updateOthers(result, isYesterday: true);
        var filterList = result.sublist(0, 288);
        return Result.success(filterList);
      }
    }

    // get location
    var gpsToData = ConvertGps.gpsToGRID(latitude, longitude);
    int x = gpsToData['x'];
    int y = gpsToData['y'];

    // remote
    try {
      logger.i('getYesterdayShortTermList(date: $date, time: 0200, x: $x, y: $y, numberOfRows: 300)');
      final response = await _api.getShortTerm(date, '0200', x, y, numberOfRows: '300');
      final jsonResult = jsonDecode(response.body);
      ShortTermList list = ShortTermList.fromJson(jsonResult['response']['body']);

      List<ShortTerm> result = [];
      if (list.items?.item != null) {
        for (var item in list.items!.item!) {
          item.weatherCategory = await getWeatherCode(item.category ?? '');
          result.add(item);
        }
      }

      // local update
      if (result.isNotEmpty && id != kCreateWidgetId) {
        _dao.updateWeatherYesterdayShortListTemperature(id, result);
      }

      _updateOthers(result, isYesterday: true);

      logger.i('getYesterdayShortTermList() -> api return');
      var filterList = result.sublist(0, 288);

      return Result.success(filterList);
    } catch (e) {
      return Result.error(Exception('getYesterdayShortTermList failed: ${e.toString()}'));
    }
  }

  _updateOthers(List<ShortTerm> result, {bool isYesterday = false}) {
    if (isYesterday) {
      DateTime dateTime = DateTime.now();
      DateTime yesterdayDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day - 2, 23);
      var yesterdayTwentyFourHoursLater = yesterdayDateTime.add(const Duration(hours: 25));

      // 어제 평균 습도
      var humidityList = result.where((element) => element.category == kWeatherCategoryHumidity).toList();
      var yesterdayFilterList = humidityList.where((item) {
        var forecastDateTime = DateTime.parse("${item.fcstDate} ${item.fcstTime.toString().padLeft(4, '0')}");
        return forecastDateTime.isAfter(yesterdayDateTime) && forecastDateTime.isBefore(yesterdayTwentyFourHoursLater);
      }).toList();
      // print('yesterdayFilterList -> ${yesterdayFilterList.length}');
      // yesterdayFilterList.forEach((element) {print(element);});
      int humidity = yesterdayFilterList.map((e) => int.parse(e.fcstValue ?? '0')).reduce((value, element) => value + element);
      double humidityAverage = humidity / yesterdayFilterList.length;
      SharedPreferencesUtil().setInt(kYesterdayHumidity, humidityAverage.toInt());
    } else {
      DateTime dateTime = DateTime.now();
      DateTime todayDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day - 1, 23);
      var twentyFourHoursLater = todayDateTime.add(const Duration(hours: 25));

      // 오늘 바람
      var windList = result.where((element) => element.category == kWeatherCategoryWindSpeed).toList();
      var todayWindList = windList.where((item) {
        var forecastDateTime = DateTime.parse("${item.fcstDate} ${item.fcstTime.toString().padLeft(4, '0')}");
        return forecastDateTime.isAfter(todayDateTime) && forecastDateTime.isBefore(twentyFourHoursLater);
      }).toList();

      // 오늘 최고-최저 기온
      var temperatureList = result.where((element) => element.category == kWeatherCategoryTemperatureShort).toList();
      var todayTemperatureList = temperatureList.where((item) {
        var forecastDateTime = DateTime.parse("${item.fcstDate} ${item.fcstTime.toString().padLeft(4, '0')}");
        return forecastDateTime.isAfter(todayDateTime) && forecastDateTime.isBefore(twentyFourHoursLater);
      }).toList();
      var tempList = todayTemperatureList.map((e) => int.parse(e.fcstValue ?? '0')).toList();
      int maxValue = tempList.reduce((value, element) => value > element ? value : element);
      int minValue = tempList.reduce((value, element) => value < element ? value : element);
      SharedPreferencesUtil().setInt(kTodayMaxTemperature, maxValue);
      SharedPreferencesUtil().setInt(kTodayMinTemperature, minValue);
      // print('todayTemperatureList -> ${todayTemperatureList.length}');
      // todayTemperatureList.forEach((element) {print(element);});

      // 오늘 체감 온도 업데이트
      int feelMax = 100;
      int feelMin = -100;
      for (int i = 0; i < todayWindList.length; i++) {
        double temp = double.parse(temperatureList[i].fcstValue ?? '0');
        double wind = double.parse(windList[i].fcstValue ?? '0');
        int feel = Utils.calculateWindChill(temp, wind).toInt();
        if (feelMax == 100 || feel > feelMax) {
          feelMax = feel;
        }

        if (feelMin == -100 || feel < feelMin) {
          feelMin = feel;
        }
      }
      SharedPreferencesUtil().setInt(kTodayMaxFeel, feelMax);
      SharedPreferencesUtil().setInt(kTodayMinFeel, feelMin);


      // 오늘 오전-오후 강수 확률
      var rainPercentageList = result.where((element) => element.category == kWeatherCategoryRainPercent).toList();
      var todayRainPercentageList = rainPercentageList.where((item) {
        var forecastDateTime = DateTime.parse("${item.fcstDate} ${item.fcstTime.toString().padLeft(4, '0')}");
        return forecastDateTime.isAfter(todayDateTime) && forecastDateTime.isBefore(twentyFourHoursLater);
      }).toList();
      var amList = todayRainPercentageList.sublist(0, 12);
      var amTempList = amList.map((e) => int.parse(e.fcstValue ?? '0')).toList();
      int amMaxValue = amTempList.reduce((value, element) => value > element ? value : element);
      SharedPreferencesUtil().setInt(kTodayAmRainPercentage, amMaxValue);
      // print('amList -> ${amList.length}');
      // amList.forEach((element) {print(element);});

      var pmList = todayRainPercentageList.sublist(12, 24);
      var pmTempList = pmList.map((e) => int.parse(e.fcstValue ?? '0')).toList();
      int pmMaxValue = pmTempList.reduce((value, element) => value > element ? value : element);
      SharedPreferencesUtil().setInt(kTodayPmRainPercentage, pmMaxValue);
      // print('pmList -> ${pmList.length}');
      // pmList.forEach((element) {print(element);});

      // 오늘 오전-오후 강수,하늘 상태
      var statusList = result.where((element) => element.category == kWeatherCategoryRainStatus).toList();
      var skyList = result.where((element) => element.category == kWeatherCategorySky).toList();
      var amStatusList = statusList.sublist(0, 24);
      var amStatusTempList = amStatusList.map((e) {
        var value = e.weatherCategory?.codeValues?[int.parse(e.fcstValue ?? '0')] ?? '없음';
        int result = 0;
        int index = amStatusList.indexOf(e);
        if (value != '없음') {
          result = kStatusStates[value] ?? 0;
        } else {
          var value2 = skyList[index].weatherCategory?.codeValues?[int.parse(skyList[index].fcstValue ?? '0')] ?? '없음';
          result = kStatusStates[value2] ?? 0;
        }
        return result;
      }).toList();
      int amStatusMaxValue = amStatusTempList.reduce((value, element) => value > element ? value : element);
      SharedPreferencesUtil().setInt(kTodayAmStatus, amStatusMaxValue);
      // print('amStatusMaxValue -> $amStatusMaxValue');
      // print('amStatusTempList -> ${amStatusTempList.length}');
      // amStatusTempList.forEach((element) {print(element);});

      var pmStatusList = statusList.sublist(24, 48);
      var pmStatusTempList = pmStatusList.map((e) {
        var value = e.weatherCategory?.codeValues?[int.parse(e.fcstValue ?? '0')] ?? '없음';
        int result = 0;
        int index = pmStatusList.indexOf(e) * 2;
        if (value != '없음') {
          result = kStatusStates[value] ?? 0;
        } else {
          var value2 = skyList[index].weatherCategory?.codeValues?[int.parse(skyList[index].fcstValue ?? '0')] ?? '없음';
          result = kStatusStates[value2] ?? 0;
        }
        return result;
      }).toList();
      int pmStatusMaxValue = pmStatusTempList.reduce((value, element) => value > element ? value : element);
      SharedPreferencesUtil().setInt(kTodayPmStatus, pmStatusMaxValue);
      // print('pmStatusMaxValue -> $pmStatusMaxValue');
      // print('pmStatusTempList -> ${pmStatusTempList.length}');
      // pmStatusTempList.forEach((element) {print(element);});

      DateTime tomorrowDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, 23);
      var tomorrowTwentyFourHoursLater = tomorrowDateTime.add(const Duration(hours: 25));

      // 내일 최고-최저 기온
      var tomorrowTemperatureList = temperatureList.where((item) {
        var forecastDateTime = DateTime.parse("${item.fcstDate} ${item.fcstTime.toString().padLeft(4, '0')}");
        return forecastDateTime.isAfter(tomorrowDateTime) && forecastDateTime.isBefore(tomorrowTwentyFourHoursLater);
      }).toList();
      // print('tomorrowTemperatureList -> ${tomorrowTemperatureList.length}');
      // tomorrowTemperatureList.forEach((element) {print(element);});

      var tomorrowTempList = tomorrowTemperatureList.map((e) => int.parse(e.fcstValue ?? '0')).toList();
      int tomorrowMaxValue = tomorrowTempList.reduce((value, element) => value > element ? value : element);
      int tomorrowMinValue = tomorrowTempList.reduce((value, element) => value < element ? value : element);
      SharedPreferencesUtil().setInt(kTomorrowMaxTemperature, tomorrowMaxValue);
      SharedPreferencesUtil().setInt(kTomorrowMinTemperature, tomorrowMinValue);

      // 내일 오전-오후 강수 확률
      var tomorrowRainPercentageList = rainPercentageList.where((item) {
        var forecastDateTime = DateTime.parse("${item.fcstDate} ${item.fcstTime.toString().padLeft(4, '0')}");
        return forecastDateTime.isAfter(tomorrowDateTime) && forecastDateTime.isBefore(tomorrowTwentyFourHoursLater);
      }).toList();
      var tomorrowAmList = tomorrowRainPercentageList.sublist(0, 12);
      var tomorrowAmTempList = tomorrowAmList.map((e) => int.parse(e.fcstValue ?? '0')).toList();
      int tomorrowAmMaxValue = tomorrowAmTempList.reduce((value, element) => value > element ? value : element);
      SharedPreferencesUtil().setInt(kTomorrowAmRainPercentage, tomorrowAmMaxValue);
      // print('tomorrowAmList -> ${tomorrowAmList.length}');
      // tomorrowAmList.forEach((element) {print(element);});

      var tomorrowPmList = tomorrowRainPercentageList.sublist(12, 24);
      var tomorrowPmTempList = tomorrowPmList.map((e) => int.parse(e.fcstValue ?? '0')).toList();
      int tomorrowPmMaxValue = tomorrowPmTempList.reduce((value, element) => value > element ? value : element);
      SharedPreferencesUtil().setInt(kTomorrowPmRainPercentage, tomorrowPmMaxValue);
      // print('tomorrowPmList -> ${tomorrowPmList.length}');
      // tomorrowPmList.forEach((element) {print(element);});
    }
  }

  // 중기 지역별 코드 조회
  Future<Result<MidCode>> getMidCode(String depth1, String depth2) async {
    final localList = await _dao.getAllMidCodeList();
    List<MidCode> list = [];
    MidCode result = MidCode();
    if (localList.isNotEmpty) {
      logger.i('getMidCode() local return');
      list = localList.map((e) => e.toMidCode()).toList();
    } else {
      logger.i('getMidCode() csv return');
      var csv = await rootBundle.loadString(
        "assets/data/mid_code.csv",
      );
      var midCodeParser = MidCodeParser();
      list = await midCodeParser.parse(csv);
      _dao.clearMidCodeList();
      _dao.insertMidCodeList(list.map((e) => e.toMidCodeEntity()).toList());
    }

    var d1 = list.where((e) => e.city == depth2);
    if (d1.isNotEmpty) {
      result = d1.toList()[0];
    } else {
      var d2 = list.where((e) => e.city == depth1);
      if (d2.isNotEmpty) {
        result = d2.toList()[0];
      } else {
        var d3 = list.where((e) => e.city == '서울특별시');
        if (d3.isNotEmpty) {
          result = d3.toList()[0];
        }
      }
    }

    if (result.city != null) {
      return Result.success(result);
    } else {
      return Result.error(Exception('getMidCode failed: not found'));
    }
  }

  String _getMidDate() {
    String date = '';
    // 30분전
    DateTime dateTime = DateTime.now();
    String dt = DateTime(dateTime.year, dateTime.month, dateTime.day,
        dateTime.hour, dateTime.minute - 30)
        .toString()
        .replaceAll(RegExp("[^0-9\\s]"), "")
        .replaceAll(" ", "");
    String current = dt.substring(0, 8);
    int currentTime = int.parse(dt.substring(8, 10));
    String prevDt = DateTime(dateTime.year, dateTime.month, dateTime.day - 1)
        .toString()
        .replaceAll(RegExp("[^0-9\\s]"), "")
        .replaceAll(" ", "");
    String prev = prevDt.substring(0, 8);
    if (currentTime < 6) {
      date = '${prev}1800';
    } else if (currentTime > 6 && currentTime < 18) {
      date = '${current}0600';
    } else {
      date = '${current}1800';
    }
    return date;
  }

  String _getMidFcstRegId(String depth1, String depth2) {
    String regId = '11B00000';
    for (String key in kMidCode.keys) {
      if (depth1 == '강원도' && depth2.isNotEmpty) {
        if (key.contains(depth2.substring(0, 2))) {
          regId = kMidCode[key]!;
          break;
        }
      } else {
        if (key.contains(depth1)) {
          regId = kMidCode[key]!;
          break;
        }
      }
    }
    return regId;
  }

  String _getCityName(String depth1) {
    String cityName = '전국';
    for (String key in kCityName.keys) {
      if (key.contains(depth1)) {
        cityName = kCityName[key]!;
      }
    }
    return cityName;
  }

  // 중기 기온 예보
  Future<Result<MidTermTemperature>> getMidTermTemperature(String id, String regId) async {
    final getWeatherMidTermTemperature = await _dao.getWeatherMidTermTemperature(id);
    String tmFc = _getMidDate();
    if (getWeatherMidTermTemperature != null) {
      if (tmFc == getWeatherMidTermTemperature.date) {
        logger.i('getMidTermTemperature() -> local return');
        return Result.success(getWeatherMidTermTemperature.toMidTermTemperature());
      }
    }

    // remote
    MidTermTemperature result = MidTermTemperature();
    try {
      final response = await _api.getMidTermTemperature(tmFc, regId);
      final jsonResult = jsonDecode(response.body);
      MidTaList list = MidTaList.fromJson(jsonResult['response']['body']);

      if (list.items?.item != null) {
        for (var item in list.items!.item!) {
          item.date = tmFc;
          result = item;
        }
      }

      if (id != kCreateWidgetId) {
        _dao.updateWeatherMidTermTemperature(id, result.toMidTermTemperatureEntity());
      }
      logger.i('getMidTermTemperature() -> api return');
      return Result.success(result);
    } catch (e) {
      return Result.error(Exception('getMidTermTemperature failed: ${e.toString()}'));
    }
  }

  // 중기 육상 예보
  Future<Result<MidTermLand>> getMidTermLand(String id, String depth1, String depth2) async {

    String tmFc = _getMidDate();
    String regId = _getMidFcstRegId(depth1, depth2);
    final getWeatherMidTermLand = await _dao.getWeatherMidTermLand(id);
    if (getWeatherMidTermLand != null) {
      if (tmFc == getWeatherMidTermLand.date) {
        logger.i('getMidTermLand() -> local return');
        return Result.success(getWeatherMidTermLand.toMidTermLand());
      }
    }

    // remote
    MidTermLand result = MidTermLand();
    try {
      final response = await _api.getMidTermLand(tmFc, regId);
      final jsonResult = jsonDecode(response.body);
      MidLandFcstList list = MidLandFcstList.fromJson(jsonResult['response']['body']);

      if (list.items?.item != null) {
        for (var item in list.items!.item!) {
          item.date = tmFc;
          result = item;
        }
      }
      // local update
      if (id != kCreateWidgetId) {
        _dao.updateWeatherMidTermLand(id, result.toMidTermLandEntity());
      }
      logger.i('getMidTermLand() -> api return');
      return Result.success(result);
    } catch (e) {
      return Result.error(Exception('getMidTermLand failed: ${e.toString()}'));
    }
  }

  // 일출 일몰
  Future<Result<SunRiseSet>> getSunRiseSetWithCoordinate(String id, double longitude, double latitude) async {
    final sunRiseSet = await _dao.getWeatherSunRiseSet(id);

    String dateTime = DateTime.now()
        .toString()
        .replaceAll(RegExp("[^0-9\\s]"), "")
        .replaceAll(" ", "");
    String currentDate = dateTime.toString().substring(0, 8);

    // 로컬에 있고 날짜가 변경 되지 않은 경우
    if (sunRiseSet != null && currentDate == sunRiseSet.locdate) {
      logger.i('getSunRiseSetWithCoordinate() -> local return');
      return Result.success(sunRiseSet.toSunRiseSet());
    }

    // remote
    try {
      final response = await _api.getRiseSetInfoWithCoordinate(
          currentDate, longitude, latitude);

      final xmlResult = XmlDocument.parse(utf8.decode(response.bodyBytes))
          .findAllElements('item');

      final jsonTransformer = Xml2Json();
      jsonTransformer.parse(xmlResult.toString());
      var json = jsonDecode(jsonTransformer.toParker());

      SunRiseSet result = SunRiseSet.fromJson(json['item']);

      // 로컬 업데이트
      if (result.locdate != null && id != kCreateWidgetId) {
        _dao.updateWeatherSunRiseSet(id, result.toSunRiseSetEntity());
      }
      logger.i('getRiseSetWithCoordinate() -> api return');
      return Result.success(result);
    } catch (e) {
      return Result.error(
          Exception('getRiseSetWithCoordinate failed: ${e.toString()}'));
    }
  }

  // 미세 먼지
  Future<Result<FineDust>> getFineDustWithCity(String id, String depth1) async {
    final fineDust = await _dao.getWeatherFineDust(id);

    final cityName = _getCityName(depth1);
    logger.d('getFineDustWithCity() cityName -> $cityName');

    // local
    if (fineDust != null && fineDust.dataTime != null) {
      DateTime dateTime = DateTime.now();
      String dt = DateTime(dateTime.year, dateTime.month, dateTime.day,
          dateTime.hour, dateTime.minute)
          .toString()
          .replaceAll(RegExp("[^0-9\\s]"), "")
          .replaceAll(" ", "");
      String currentDate = dt.substring(0, 10);
      String dataTime = fineDust.dataTime!.replaceAll(' ', '');
      String prevDate = dataTime.substring(0, 12).replaceAll("-", "");
      DateTime dateTime1 = Utils.parseDateString(currentDate);
      DateTime dateTime2 = Utils.parseDateString(prevDate);
      if (dateTime1.isAtSameMomentAs(dateTime2)) {
        logger.i('getFineDust() -> local return');
        return Result.success(fineDust.toFineDust());
      }
    }

    // remote
    try {
      final response = await _api.getFineDustWithCity(cityName);
      final jsonResult = jsonDecode(response.body);
      DnstyList list = DnstyList.fromJson(jsonResult['response']['body']);
      var fineDust = FineDust();
      var isUpdate = false;
      if (list.items != null) {
        isUpdate = true;
        fineDust = list.items![0];
      }
      // local update
      if (isUpdate && id != kCreateWidgetId) {
        _dao.updateWeatherFineDust(id, fineDust.toWeatherFineDustEntity());
      }
      logger.i('getFineDust() -> api return');
      return Result.success(fineDust);
    } catch (e) {
      return Result.error(Exception('getFineDust failed: ${e.toString()}'));
    }
  }

  // 관측소
  Future<Result<Observatory>> getObservatoryWithAddress(String depth1, String depth2) async {
    final localList = await _dao.getAllObservatoryList();
    List<Observatory> list = [];
    Observatory result = Observatory();
    if (localList.isNotEmpty) {
      list = localList.map((e) => e.toObservatory()).toList();
      logger.i('getObservatoryWithAddress local return');
    } else {
      var csv = await rootBundle.loadString(
        "assets/data/observatory.csv",
      );
      var observatoryParser = ObservatoryParser();
      list = await observatoryParser.parse(csv);
      _dao.clearObservatory();
      _dao.insertObservatoryList(
          list.map((e) => e.toObservatoryEntity()).toList());
      logger.i('getObservatoryWithAddress csv return');
    }

    var d1 = list.where((e) => e.depth1 == depth1 && e.depth2 == depth2);
    if (d1.isNotEmpty) {
      result = d1.toList()[0];
    } else {
      var d2 = list.where((e) => e.depth1 == depth1 && e.depth2 == '');
      if (d2.isNotEmpty) {
        result = d2.toList()[0];
      } else {
        var d3 = list.where((e) => e.depth1 == '서울특별시');
        if (d3.isNotEmpty) {
          result = d3.toList()[0];
        }
      }
    }

    if (result.depth1 != null) {
      return Result.success(result);
    } else {
      return Result.error(
          Exception('getObservatoryWithAddress failed: not found'));
    }
  }

  // 자외선
  Future<Result<Ultraviolet>> getUltraviolet(String id, String areaNo) async {
    final ultraviolet = await _dao.getWeatherUltraviolet(id);

    // 시간 기준 업데이트
    String dt = DateTime.now()
        .toString()
        .replaceAll(RegExp("[^0-9\\s]"), "")
        .replaceAll(" ", "");
    String currentDateTime = dt.substring(0, 10);

    if (ultraviolet != null && ultraviolet.date == currentDateTime) {
      logger.i('getUltraviolet() -> Local return');
      return Result.success(ultraviolet.toUltraviolet());
    }

    // remote
    Ultraviolet result = Ultraviolet();
    try {
      final response = await _api.getUltraviolet(currentDateTime, areaNo);
      final jsonResult = jsonDecode(response.body);
      UltravioletList list = UltravioletList.fromJson(jsonResult['response']['body']);
      if (list.items != null) {
        if (list.items!.item != null) {
          result = list.items!.item![0];
          logger.i('getUltraviolet() api result = $result');
          // 로컬 업데이트
          if (result.code != null && id != kCreateWidgetId) {
            for (Ultraviolet uv in list.items!.item!) {
              uv.date = currentDateTime;
            }
            _dao.updateWeatherUltraviolet(id, result.toWeatherUltravioletEntity());
          }
        }
      }
    } catch (e) {
      return Result.error(Exception('getUltraviolet failed: ${e.toString()}'));
    }

    if (result.code != null) {
      return Result.success(result);
    } else {
      return Result.error(Exception('getUltraviolet failed: not found'));
    }
  }
}
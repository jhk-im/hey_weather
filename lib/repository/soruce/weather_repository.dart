  import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/convert_gps.dart';
import 'package:hey_weather/common/utils.dart';
import 'package:hey_weather/repository/soruce/local/csv/observatory_parser.dart';
import 'package:hey_weather/repository/soruce/local/weather_dao.dart';
import 'package:hey_weather/repository/soruce/mapper/weather_mapper.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';
import 'package:hey_weather/repository/soruce/local/model/search_address.dart';
import 'package:hey_weather/repository/soruce/local/model/user_notification.dart';
import 'package:hey_weather/repository/soruce/remote/model/fine_dust.dart';
import 'package:hey_weather/repository/soruce/remote/model/observatory.dart';
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
      logger.i('getObservatoryWithAddress csv return = $list');
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

  // 날씨 category 에 따른 정보
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
      logger.i('getUltraShortTerm() api return');
      return Result.success(result);
    } catch (e) {
      return Result.error(Exception('getUltraShortTerm failed: ${e.toString()}'));
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
          if (result.code != null) {
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
      if (result.locdate != null) {
        _dao.updateWeatherSunRiseSet(id, result.toSunRiseSetEntity());
      }
      logger.i('getRiseSetWithCoordinate() -> api return');
      return Result.success(result);
    } catch (e) {
      return Result.error(
          Exception('getRiseSetWithCoordinate failed: ${e.toString()}'));
    }
  }

  // 미세먼지
  Future<Result<FineDust>> getFineDust(String id, String depth2) async {
    final fineDust = await _dao.getWeatherFineDust(id);

    // local
    if (fineDust != null && fineDust.dataTime != null) {
      DateTime dateTime = DateTime.now();
      String dt = DateTime(dateTime.year, dateTime.month, dateTime.day,
          dateTime.hour, dateTime.minute)
          .toString()
          .replaceAll(RegExp("[^0-9\\s]"), "")
          .replaceAll(" ", "");
      String currentDate = dt.substring(0, 8);
      String dataTime = fineDust.dataTime!;
      String prevDate = dataTime.substring(0, 10).replaceAll("-", "");
      String currentTime = dt.substring(8, 10);
      String prevTime =
      dataTime.substring(dataTime.length - 5, dataTime.length - 3);

      if (currentDate == prevDate && currentTime == prevTime) {
        logger.i('getFineDust() -> local return');
        return Result.success(fineDust.toFineDust());
      }
    }

    // remote
    try {
      final response = await _api.getFineDust(depth2);
      final jsonResult = jsonDecode(response.body);
      DnstyList list = DnstyList.fromJson(jsonResult['response']['body']);
      var fineDust = FineDust();
      if (list.items != null) {
        fineDust = list.items![0];
      }
      // 로컬 업데이트
      _dao.updateWeatherFineDust(id, fineDust.toWeatherFineDustEntity());
      logger.i('getFineDust() -> api return');
      return Result.success(fineDust);
    } catch (e) {
      return Result.error(Exception('getFineDust failed: ${e.toString()}'));
    }
  }
}
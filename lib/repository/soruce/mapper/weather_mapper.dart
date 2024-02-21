import 'package:hey_weather/repository/soruce/local/entity/address_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/observatory_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_sun_rise_set_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/user_notification_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_ultraviolet_entity.dart';
import 'package:hey_weather/repository/soruce/remote/dto/observatory_dto.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';
import 'package:hey_weather/repository/soruce/local/model/user_notification.dart';
import 'package:hey_weather/repository/soruce/remote/model/observatory.dart';
import 'package:hey_weather/repository/soruce/remote/model/sun_rise_set.dart';
import 'package:hey_weather/repository/soruce/remote/model/ultraviolet.dart';

// 주소
extension ToAddressEntity on Address {
  AddressEntity toAddressEntity() {
    var entity = AddressEntity();
    entity.id = id;
    entity.addressName = addressName;
    entity.region1depthName = region1depthName;
    entity.region2depthName = region2depthName;
    entity.region3depthName = region3depthName;
    entity.region4depthName = region4depthName;
    entity.x = x;
    entity.y = y;
    entity.code = code;
    entity.regionType = regionType;
    entity.createDateTime = createDateTime;
    return entity;
  }
}

extension ToAddress on AddressEntity {
  Address toAddress() {
    var address = Address(
      id: id,
      addressName: addressName,
      region1depthName: region1depthName,
      region2depthName: region2depthName,
      region3depthName: region3depthName,
      region4depthName: region4depthName,
      x: x,
      y: y,
      code: code,
      regionType: regionType,
      createDateTime: createDateTime,
    );
    return address;
  }
}

// 알림
extension ToUserNotificationEntity on UserNotification {
  UserNotificationEntity toUserNotificationEntity() {
    var entity = UserNotificationEntity();
    entity.id = id;
    entity.dateTime = dateTime;
    entity.isOn = isOn;
    return entity;
  }
}

extension ToUserNotification on UserNotificationEntity {
  UserNotification toUserNotification() {
    var userNotification = UserNotification(
      id: id,
      dateTime: dateTime,
      isOn: isOn,
    );
    return userNotification;
  }
}

// 관측소
extension ToObservatory on ObservatoryDto {
  Observatory toObservatory() {
    return Observatory(
      code: code,
      depth1: depth1,
      depth2: depth2,
      depth3: depth3,
      gridX: gridX,
      gridY: gridY,
      lonHour: lonHour,
      lonMin: lonMin,
      lonSec: lonSec,
      latHour: latHour,
      latMin: latMin,
      latSec: latSec,
      longitude: longitude,
      latitude: latitude,
    );
  }
}

extension ToObservatoryEntity on Observatory {
  ObservatoryEntity toObservatoryEntity() {
    var entity = ObservatoryEntity();
    entity.code = code;
    entity.depth1 = depth1;
    entity.depth2 = depth2;
    entity.depth3 = depth3;
    entity.gridX = gridX;
    entity.gridY = gridY;
    entity.lonHour = lonHour;
    entity.lonMin = lonMin;
    entity.lonSec = lonSec;
    entity.latHour = latHour;
    entity.latMin = latMin;
    entity.latSec = latSec;
    entity.longitude = longitude;
    entity.latitude = latitude;
    return entity;
  }
}

extension ToObservatoryFromEntity on ObservatoryEntity {
  Observatory toObservatory() {
    return Observatory(
      code: code,
      depth1: depth1,
      depth2: depth2,
      depth3: depth3,
      gridX: gridX,
      gridY: gridY,
      lonHour: lonHour,
      lonMin: lonMin,
      lonSec: lonSec,
      latHour: latHour,
      latMin: latMin,
      latSec: latSec,
      longitude: longitude,
      latitude: latitude,
    );
  }
}

// 자외선
extension ToWeatherUltravioletEntity on Ultraviolet {
  WeatherUltravioletEntity toWeatherUltravioletEntity() {
    var entity = WeatherUltravioletEntity();
    entity.code = code;
    entity.areaNo = areaNo;
    entity.date = date;
    entity.h0 = h0;
    entity.h3 = h3;
    entity.h6 = h6;
    entity.h9 = h9;
    entity.h12 = h12;
    entity.h15 = h15;
    entity.h18 = h18;
    entity.h21 = h21;
    entity.h24 = h24;
    return entity;
  }
}

extension ToUltraviolet on WeatherUltravioletEntity {
  Ultraviolet toUltraviolet() {
    var uvRays = Ultraviolet(
      code: code,
      areaNo: areaNo,
      date: date,
      h0: h0,
      h3: h3,
      h6: h6,
      h9: h9,
      h12: h12,
      h15: h15,
      h18: h18,
      h21: h21,
      h24: h24,
    );
    return uvRays;
  }
}

// 일출 일몰
extension ToWeatherSunRiseSetEntity on SunRiseSet {
  WeatherSunRiseSetEntity toSunRiseSetEntity() {
    var entity = WeatherSunRiseSetEntity();
    entity.locdate = locdate;
    entity.location = location;
    entity.sunrise = sunrise;
    entity.sunset = sunset;
    entity.moonrise = moonrise;
    entity.moonset = moonset;
    entity.longitudeNum = longitudeNum;
    entity.latitudeNum = latitudeNum;
    return entity;
  }
}

extension ToSunRiseSet on WeatherSunRiseSetEntity {
  SunRiseSet toSunRiseSet() {
    var address = SunRiseSet(
      locdate: locdate,
      location: location,
      sunrise: sunrise,
      sunset: sunset,
      moonrise: moonrise,
      moonset: moonset,
      longitudeNum: longitudeNum,
      latitudeNum: latitudeNum,
    );
    return address;
  }
}
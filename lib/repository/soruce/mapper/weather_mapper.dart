import 'package:hey_weather/repository/soruce/local/entity/address_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/observatory_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_fine_dust_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_sun_rise_set_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/user_notification_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_ultra_short_term_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_ultraviolet_entity.dart';
import 'package:hey_weather/repository/soruce/remote/dto/observatory_dto.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';
import 'package:hey_weather/repository/soruce/local/model/user_notification.dart';
import 'package:hey_weather/repository/soruce/remote/model/fine_dust.dart';
import 'package:hey_weather/repository/soruce/remote/model/observatory.dart';
import 'package:hey_weather/repository/soruce/remote/model/sun_rise_set.dart';
import 'package:hey_weather/repository/soruce/remote/model/ultra_short_term.dart';
import 'package:hey_weather/repository/soruce/remote/model/ultraviolet.dart';
import 'package:hey_weather/repository/soruce/remote/model/weather_category.dart';

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

// 초단기 실황
extension ToUltraShortTerm on WeatherUltraShortTermEntity {
  UltraShortTerm toUltraShortTerm() {
    var ncst = UltraShortTerm(
      baseDate: baseDate,
      baseTime: baseTime,
      category: category,
      nx: nx,
      ny: ny,
      obsrValue: obsrValue,
    );
    ncst.weatherCategory =
        WeatherCategory(name: name, unit: unit, codeValues: codeValues);
    return ncst;
  }
}

extension ToUltraShortTermEntity on UltraShortTerm {
  WeatherUltraShortTermEntity toWeatherUltraShortTermEntity() {
    var entity = WeatherUltraShortTermEntity(
      category: category ?? '',
      obsrValue: obsrValue ?? '',
    );
    entity.baseTime = baseTime;
    entity.baseDate = baseDate;
    entity.nx = nx;
    entity.ny = ny;
    entity.name = weatherCategory?.name ?? '';
    entity.unit = weatherCategory?.unit ?? '';
    entity.codeValues = weatherCategory?.codeValues ?? [];
    return entity;
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

// 미세먼지
extension ToFineDust on WeatherFineDustEntity {
  FineDust toFineDust() {
    var dnsty = FineDust();
    dnsty.so2Grade = so2Grade;
    dnsty.coFlag = coFlag;
    dnsty.khaiValue = khaiValue;
    dnsty.so2Value = so2Value;
    dnsty.coValue = coValue;
    dnsty.pm10Flag = pm10Flag;
    dnsty.pm10Value = pm10Value;
    dnsty.pm10Value24 = pm10Value24;
    dnsty.pm25Value = pm25Value;
    dnsty.pm25Value24 = pm25Value24;
    dnsty.o3Grade = o3Grade;
    dnsty.khaiGrade = khaiGrade;
    dnsty.no2Flag = no2Flag;
    dnsty.no2Grade = no2Grade;
    dnsty.o3Flag = o3Flag;
    dnsty.so2Flag = so2Flag;
    dnsty.dataTime = dataTime;
    dnsty.coGrade = coGrade;
    dnsty.no2Value = no2Value;
    dnsty.pm10Grade = pm10Grade;
    dnsty.o3Value = o3Value;
    return dnsty;
  }
}

extension ToWeatherFineDustEntity on FineDust {
  WeatherFineDustEntity toWeatherFineDustEntity() {
    var dnstyEntity = WeatherFineDustEntity();
    dnstyEntity.so2Grade = so2Grade;
    dnstyEntity.coFlag = coFlag;
    dnstyEntity.khaiValue = khaiValue;
    dnstyEntity.so2Value = so2Value;
    dnstyEntity.coValue = coValue;
    dnstyEntity.pm10Flag = pm10Flag;
    dnstyEntity.pm10Value = pm10Value;
    dnstyEntity.pm10Value24 = pm10Value24;
    dnstyEntity.pm25Value = pm25Value;
    dnstyEntity.pm25Value24 = pm25Value24;
    dnstyEntity.o3Grade = o3Grade;
    dnstyEntity.khaiGrade = khaiGrade;
    dnstyEntity.no2Flag = no2Flag;
    dnstyEntity.no2Grade = no2Grade;
    dnstyEntity.o3Flag = o3Flag;
    dnstyEntity.so2Flag = so2Flag;
    dnstyEntity.dataTime = dataTime;
    dnstyEntity.coGrade = coGrade;
    dnstyEntity.no2Value = no2Value;
    dnstyEntity.pm10Grade = pm10Grade;
    dnstyEntity.o3Value = o3Value;
    return dnstyEntity;
  }
}
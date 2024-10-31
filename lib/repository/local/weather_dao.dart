import 'package:hey_weather/repository/remote/model/short_term_response.dart';
import 'package:hey_weather/repository/local/entity/address_entity.dart';
import 'package:hey_weather/repository/local/entity/observatory_entity.dart';
import 'package:hey_weather/repository/local/entity/fine_dust_entity.dart';
import 'package:hey_weather/repository/local/entity/mid_code_entity.dart';
import 'package:hey_weather/repository/local/entity/mid_term_land_entity.dart';
import 'package:hey_weather/repository/local/entity/mid_term_temperature_entity.dart';
import 'package:hey_weather/repository/local/entity/short_term_list_entity.dart';
import 'package:hey_weather/repository/local/entity/sun_rise_entity.dart';
import 'package:hey_weather/repository/local/entity/live_short_term_entity.dart';
import 'package:hey_weather/repository/local/entity/ultraviolet_entity.dart';
import 'package:hey_weather/repository/mapper/weather_mapper.dart';
import 'package:hive/hive.dart';

class WeatherDao {
  /// 주소
  static const userAddress = 'userAddress';
  Future updateUserAddressWithId(String id, AddressEntity address) async {
    final box = await Hive.openBox<AddressEntity>(userAddress);
    await box.put(id, address);
  }

  Future<AddressEntity?> getUserAddressWithId(String addressId) async {
    final box = await Hive.openBox<AddressEntity>(userAddress);
    return box.get(addressId);
  }

  Future deleteUserAddressWithId(String addressId) async {
    final box = await Hive.openBox<AddressEntity>(userAddress);
    return box.delete(addressId);
  }

  Future<List<AddressEntity>> getAllUserAddressList() async {
    final box = await Hive.openBox<AddressEntity>(userAddress);
    return box.values.toList();
  }

  /// 사용자 편집 주소
  static const userAddressEdit = 'userAddressEdit';
  static const userAddressRecent = 'userAddressRecent';
  Future updateUserAddressEdit(List<String> idList) async {
    final box = await Hive.openBox<List<String>>(userAddressEdit);
    await box.put(userAddressEdit, idList);
  }

  Future<List<String>?> getUserAddressEditIdList() async {
    final box = await Hive.openBox<List<String>>(userAddressEdit);
    return box.get(userAddressEdit);
  }

  Future updateUserAddressRecent(List<String> idList) async {
    final box = await Hive.openBox<List<String>>(userAddressRecent);
    await box.put(userAddressRecent, idList);
  }

  Future<List<String>?> getUserAddressRecentIdList() async {
    final box = await Hive.openBox<List<String>>(userAddressRecent);
    return box.get(userAddressRecent);
  }

  /// 사용자 선택 날씨
  static const userMyWeather = 'userMyWeather';
  Future updateUserMyWeather(List<String> idList) async {
    final box = await Hive.openBox<List<String>>(userMyWeather);
    await box.put(userMyWeather, idList);
  }

  Future<List<String>?> getUserMyWeatherIdList() async {
    final box = await Hive.openBox<List<String>>(userMyWeather);
    return box.get(userMyWeather);
  }

  /// 관측소 정보
  static const weatherObservatory = 'weatherObservatory';
  Future<void> insertObservatoryList(List<ObservatoryEntity> list) async {
    final box = await Hive.openBox<ObservatoryEntity>(weatherObservatory);
    await box.addAll(list);
  }

  Future clearObservatory() async {
    final box = await Hive.openBox<ObservatoryEntity>(weatherObservatory);
    await box.clear();
  }

  Future<List<ObservatoryEntity>> getAllObservatoryList() async {
    final box = await Hive.openBox<ObservatoryEntity>(weatherObservatory);
    return box.values.toList();
  }

  /// 초단기 실황
  static const liveShortTermTemperature = 'liveShortTermTemperature';
  Future updateLiveShortTermTemperature(
      String id, LiveShortTermEntity weatherUltraShortTermEntity) async {
    final box =
        await Hive.openBox<LiveShortTermEntity>(liveShortTermTemperature);
    await box.put(id, weatherUltraShortTermEntity);
  }

  Future deleteLiveShortTermTemperature(String id) async {
    final box =
        await Hive.openBox<LiveShortTermEntity>(liveShortTermTemperature);
    return box.delete(id);
  }

  Future<LiveShortTermEntity?> getLiveShortTermTemperature(String id) async {
    final box =
        await Hive.openBox<LiveShortTermEntity>(liveShortTermTemperature);
    return box.get(id);
  }

  static const liveShortTermHumidity = 'liveShortTermHumidity';
  Future updateLiveShortTermHumidity(
      String id, LiveShortTermEntity weatherUltraShortTermEntity) async {
    final box = await Hive.openBox<LiveShortTermEntity>(liveShortTermHumidity);
    await box.put(id, weatherUltraShortTermEntity);
  }

  Future deleteLiveShortTermHumidity(String id) async {
    final box = await Hive.openBox<LiveShortTermEntity>(liveShortTermHumidity);
    return box.delete(id);
  }

  Future<LiveShortTermEntity?> getLiveShortTermHumidity(String id) async {
    final box = await Hive.openBox<LiveShortTermEntity>(liveShortTermHumidity);
    return box.get(id);
  }

  static const liveShortTermRain = 'liveShortTermRain';
  Future updateLiveShortTermRain(
      String id, LiveShortTermEntity weatherUltraShortTermEntity) async {
    final box = await Hive.openBox<LiveShortTermEntity>(liveShortTermRain);
    await box.put(id, weatherUltraShortTermEntity);
  }

  Future deleteLiveShortTermRain(String id) async {
    final box = await Hive.openBox<LiveShortTermEntity>(liveShortTermRain);
    return box.delete(id);
  }

  Future<LiveShortTermEntity?> getLiveShortTermRain(String id) async {
    final box = await Hive.openBox<LiveShortTermEntity>(liveShortTermRain);
    return box.get(id);
  }

  static const liveShortTermRainStatus = 'liveShortTermRainStatus';
  Future updateLiveShortTermRainStatus(
      String id, LiveShortTermEntity weatherUltraShortTermEntity) async {
    final box =
        await Hive.openBox<LiveShortTermEntity>(liveShortTermRainStatus);
    await box.put(id, weatherUltraShortTermEntity);
  }

  Future deleteLiveShortTermRainStatus(String id) async {
    final box =
        await Hive.openBox<LiveShortTermEntity>(liveShortTermRainStatus);
    return box.delete(id);
  }

  Future<LiveShortTermEntity?> getLiveShortTermRainStatus(String id) async {
    final box =
        await Hive.openBox<LiveShortTermEntity>(liveShortTermRainStatus);
    return box.get(id);
  }

  static const liveShortTermWindSpeed = 'liveShortTermWindSpeed';
  Future updateLiveShortTermWindSpeed(
      String id, LiveShortTermEntity weatherUltraShortTermEntity) async {
    final box = await Hive.openBox<LiveShortTermEntity>(liveShortTermWindSpeed);
    await box.put(id, weatherUltraShortTermEntity);
  }

  Future deleteLiveShortTermWindSpeed(String id) async {
    final box = await Hive.openBox<LiveShortTermEntity>(liveShortTermWindSpeed);
    return box.delete(id);
  }

  Future<LiveShortTermEntity?> getLiveShortTermWindSpeed(String id) async {
    final box = await Hive.openBox<LiveShortTermEntity>(liveShortTermWindSpeed);
    return box.get(id);
  }

  static const liveShortTermWindDirection = 'liveShortTermWindDirection';
  Future updateLiveShortTermWindDirection(
      String id, LiveShortTermEntity weatherUltraShortTermEntity) async {
    final box =
        await Hive.openBox<LiveShortTermEntity>(liveShortTermWindDirection);
    await box.put(id, weatherUltraShortTermEntity);
  }

  Future deleteLiveShortTermWindDirection(String id) async {
    final box =
        await Hive.openBox<LiveShortTermEntity>(liveShortTermWindDirection);
    return box.delete(id);
  }

  Future<LiveShortTermEntity?> getLiveShortTermWindDirection(String id) async {
    final box =
        await Hive.openBox<LiveShortTermEntity>(liveShortTermWindDirection);
    return box.get(id);
  }

  /// 초단기 예보
  static const shortTermListTemperature = 'shortTermListTemperature';
  Future updateShortTermListTemperature(
      String id, List<ShortTerm> shortTermList) async {
    var entity = ShortTermListEntity();
    entity.id = id;
    entity.items = shortTermList.map((e) => e.toShortTermEntity()).toList();
    final box =
        await Hive.openBox<ShortTermListEntity>(shortTermListTemperature);
    await box.put(id, entity);
  }

  Future deleteShortTermListTemperature(String id) async {
    final box =
        await Hive.openBox<ShortTermListEntity>(shortTermListTemperature);
    return box.delete(id);
  }

  Future<ShortTermListEntity?> getShortTermListTemperature(String id) async {
    final box =
        await Hive.openBox<ShortTermListEntity>(shortTermListTemperature);
    return box.get(id);
  }

  static const sixTimeShortTermList = 'sixTimeShortTermList';
  Future updateSixTimeShortTermList(
      String id, List<ShortTerm> shortTermList) async {
    var entity = ShortTermListEntity();
    entity.id = id;
    entity.items = shortTermList.map((e) => e.toShortTermEntity()).toList();
    final box = await Hive.openBox<ShortTermListEntity>(sixTimeShortTermList);
    await box.put(id, entity);
  }

  Future deleteSixTimeShortTermList(String id) async {
    final box = await Hive.openBox<ShortTermListEntity>(sixTimeShortTermList);
    return box.delete(id);
  }

  Future<ShortTermListEntity?> getSixTimeShortTermList(String id) async {
    final box = await Hive.openBox<ShortTermListEntity>(sixTimeShortTermList);
    return box.get(id);
  }

  static const yesterdayShortTermListTemperature =
      'yesterdayShortTermListTemperature';
  Future updateYesterdayShortTermListTemperature(
      String id, List<ShortTerm> shortTermList) async {
    var entity = ShortTermListEntity();
    entity.id = id;
    entity.items = shortTermList.map((e) => e.toShortTermEntity()).toList();
    final box = await Hive.openBox<ShortTermListEntity>(
        yesterdayShortTermListTemperature);
    await box.put(id, entity);
  }

  Future deleteYesterdayShortTermListTemperature(String id) async {
    final box = await Hive.openBox<ShortTermListEntity>(
        yesterdayShortTermListTemperature);
    return box.delete(id);
  }

  Future<ShortTermListEntity?> getYesterdayShortTermListTemperature(
      String id) async {
    final box = await Hive.openBox<ShortTermListEntity>(
        yesterdayShortTermListTemperature);
    return box.get(id);
  }

  /// 자외선
  static const weatherUltraviolet = 'weatherUltraviolet';
  Future updateUltraviolet(
      String id, UltravioletEntity weatherUltravioletEntity) async {
    final box = await Hive.openBox<UltravioletEntity>(weatherUltraviolet);
    await box.put(id, weatherUltravioletEntity);
  }

  Future deleteUltraviolet(String id) async {
    final box = await Hive.openBox<UltravioletEntity>(weatherUltraviolet);
    return box.delete(id);
  }

  Future<UltravioletEntity?> getUltraviolet(String id) async {
    final box = await Hive.openBox<UltravioletEntity>(weatherUltraviolet);
    return box.get(id);
  }

  /// 일출, 일몰
  static const weatherSunRise = 'weatherSunRise';
  Future updateSunRise(String id, SunRiseEntity sunRiseSetEntity) async {
    final box = await Hive.openBox<SunRiseEntity>(weatherSunRise);
    await box.put(id, sunRiseSetEntity);
  }

  Future deleteSunRise(String id) async {
    final box = await Hive.openBox<SunRiseEntity>(weatherSunRise);
    return box.delete(id);
  }

  Future<SunRiseEntity?> getSunRise(String id) async {
    final box = await Hive.openBox<SunRiseEntity>(weatherSunRise);
    return box.get(id);
  }

  /// 대기질
  static const weatherFineDust = 'weatherFineDust';
  Future updateFineDust(String id, FineDustEntity weatherFineDustEntity) async {
    final box = await Hive.openBox<FineDustEntity>(weatherFineDust);
    await box.put(id, weatherFineDustEntity);
  }

  Future deleteFineDust(String id) async {
    final box = await Hive.openBox<FineDustEntity>(weatherFineDust);
    return box.delete(id);
  }

  Future<FineDustEntity?> getFineDust(String id) async {
    final box = await Hive.openBox<FineDustEntity>(weatherFineDust);
    return box.get(id);
  }

  /// 중기 예보
  static const midCode = 'midCode';
  Future<void> insertMidCodeList(List<MidCodeEntity> list) async {
    final box = await Hive.openBox<MidCodeEntity>(midCode);
    await box.addAll(list);
  }

  Future clearMidCodeList() async {
    final box = await Hive.openBox<MidCodeEntity>(midCode);
    await box.clear();
  }

  Future<List<MidCodeEntity>> getAllMidCodeList() async {
    final box = await Hive.openBox<MidCodeEntity>(midCode);
    return box.values.toList();
  }

  static const weatherMidTermLand = 'weatherMidTermLand';
  Future updateWeatherMidTermLand(
      String id, MidTermLandEntity midTermLandEntity) async {
    final box = await Hive.openBox<MidTermLandEntity>(weatherMidTermLand);
    await box.put(id, midTermLandEntity);
  }

  Future deleteWeatherMidTermLand(String id) async {
    final box = await Hive.openBox<MidTermLandEntity>(weatherMidTermLand);
    return box.delete(id);
  }

  Future<MidTermLandEntity?> getWeatherMidTermLand(String id) async {
    final box = await Hive.openBox<MidTermLandEntity>(weatherMidTermLand);
    return box.get(id);
  }

  static const weatherMidTermTemperature = 'weatherMidTermTemperature';
  Future updateWeatherMidTermTemperature(
      String id, MidTermTemperatureEntity midTermTemperatureEntity) async {
    final box =
        await Hive.openBox<MidTermTemperatureEntity>(weatherMidTermTemperature);
    await box.put(id, midTermTemperatureEntity);
  }

  Future deleteWeatherMidTermTemperature(String id) async {
    final box =
        await Hive.openBox<MidTermTemperatureEntity>(weatherMidTermTemperature);
    return box.delete(id);
  }

  Future<MidTermTemperatureEntity?> getWeatherMidTermTemperature(
      String id) async {
    final box =
        await Hive.openBox<MidTermTemperatureEntity>(weatherMidTermTemperature);
    return box.get(id);
  }
}

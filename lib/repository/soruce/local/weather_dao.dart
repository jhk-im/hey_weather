import 'package:hey_weather/repository/soruce/local/entity/address_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/observatory_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_fine_dust_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_mid_code_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_mid_term_land_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_mid_term_temperature_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/short_term_list_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_sun_rise_set_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/live_short_term_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_ultraviolet_entity.dart';
import 'package:hey_weather/repository/soruce/mapper/weather_mapper.dart';
import 'package:hey_weather/repository/soruce/remote/model/short_term_response.dart';
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

  ///
  static const weatherUltraviolet = 'weather_ultraviolet';
  Future updateWeatherUltraviolet(
      String id, WeatherUltravioletEntity weatherUltravioletEntity) async {
    final box =
        await Hive.openBox<WeatherUltravioletEntity>(weatherUltraviolet);
    await box.put(id, weatherUltravioletEntity);
  }

  Future deleteWeatherUltraviolet(String id) async {
    final box =
        await Hive.openBox<WeatherUltravioletEntity>(weatherUltraviolet);
    return box.delete(id);
  }

  Future<WeatherUltravioletEntity?> getWeatherUltraviolet(String id) async {
    final box =
        await Hive.openBox<WeatherUltravioletEntity>(weatherUltraviolet);
    return box.get(id);
  }

  static const weatherSunRiseSet = 'weather_sun_rise_set';
  Future updateWeatherSunRiseSet(
      String id, WeatherSunRiseSetEntity sunRiseSetEntity) async {
    final box = await Hive.openBox<WeatherSunRiseSetEntity>(weatherSunRiseSet);
    await box.put(id, sunRiseSetEntity);
  }

  Future deleteWeatherSunRiseSet(String id) async {
    final box = await Hive.openBox<WeatherSunRiseSetEntity>(weatherSunRiseSet);
    return box.delete(id);
  }

  Future<WeatherSunRiseSetEntity?> getWeatherSunRiseSet(String id) async {
    final box = await Hive.openBox<WeatherSunRiseSetEntity>(weatherSunRiseSet);
    return box.get(id);
  }

  static const weatherFineDust = 'weather_fine_dust';
  Future updateWeatherFineDust(
      String id, WeatherFineDustEntity weatherFineDustEntity) async {
    final box = await Hive.openBox<WeatherFineDustEntity>(weatherFineDust);
    await box.put(id, weatherFineDustEntity);
  }

  Future deleteWeatherFineDust(String id) async {
    final box = await Hive.openBox<WeatherFineDustEntity>(weatherFineDust);
    return box.delete(id);
  }

  Future<WeatherFineDustEntity?> getWeatherFineDust(String id) async {
    final box = await Hive.openBox<WeatherFineDustEntity>(weatherFineDust);
    return box.get(id);
  }

  static const midCode = 'midCode';
  Future<void> insertMidCodeList(List<WeatherMidCodeEntity> list) async {
    final box = await Hive.openBox<WeatherMidCodeEntity>(midCode);
    await box.addAll(list);
  }

  Future clearMidCodeList() async {
    final box = await Hive.openBox<WeatherMidCodeEntity>(midCode);
    await box.clear();
  }

  Future<List<WeatherMidCodeEntity>> getAllMidCodeList() async {
    final box = await Hive.openBox<WeatherMidCodeEntity>(midCode);
    return box.values.toList();
  }

  static const weatherMidTermLand = 'weather_mid_term_land';
  Future updateWeatherMidTermLand(
      String id, WeatherMidTermLandEntity midTermLandEntity) async {
    final box =
        await Hive.openBox<WeatherMidTermLandEntity>(weatherMidTermLand);
    await box.put(id, midTermLandEntity);
  }

  Future deleteWeatherMidTermLand(String id) async {
    final box =
        await Hive.openBox<WeatherMidTermLandEntity>(weatherMidTermLand);
    return box.delete(id);
  }

  Future<WeatherMidTermLandEntity?> getWeatherMidTermLand(String id) async {
    final box =
        await Hive.openBox<WeatherMidTermLandEntity>(weatherMidTermLand);
    return box.get(id);
  }

  static const weatherMidTermTemperature = 'weather_mid_term_temperature';
  Future updateWeatherMidTermTemperature(String id,
      WeatherMidTermTemperatureEntity midTermTemperatureEntity) async {
    final box = await Hive.openBox<WeatherMidTermTemperatureEntity>(
        weatherMidTermTemperature);
    await box.put(id, midTermTemperatureEntity);
  }

  Future deleteWeatherMidTermTemperature(String id) async {
    final box = await Hive.openBox<WeatherMidTermTemperatureEntity>(
        weatherMidTermTemperature);
    return box.delete(id);
  }

  Future<WeatherMidTermTemperatureEntity?> getWeatherMidTermTemperature(
      String id) async {
    final box = await Hive.openBox<WeatherMidTermTemperatureEntity>(
        weatherMidTermTemperature);
    return box.get(id);
  }
}

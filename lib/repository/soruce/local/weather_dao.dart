import 'package:hey_weather/repository/soruce/local/entity/address_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/observatory_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_fine_dust_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_mid_code_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_mid_term_land_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_mid_term_temperature_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_short_term_list_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_sun_rise_set_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/user_notification_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_ultra_short_term_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_ultraviolet_entity.dart';
import 'package:hey_weather/repository/soruce/mapper/weather_mapper.dart';
import 'package:hey_weather/repository/soruce/remote/model/short_term.dart';
import 'package:hive/hive.dart';

class WeatherDao {
  static const userAddress = 'user_address';
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

  static const userAddressSort = 'user_address_sort';
  static const userAddressEdit = 'user_address_edit';
  static const userAddressRecent = 'user_address_recent';
  Future updateUserAddressEdit(List<String> idList) async {
    final box = await Hive.openBox<List<String>>(userAddressSort);
    await box.put(userAddressEdit, idList);
  }

  Future<List<String>?> getUserAddressEditIdList() async {
    final box = await Hive.openBox<List<String>>(userAddressSort);
    return box.get(userAddressEdit);
  }

  Future updateUserAddressRecent(List<String> idList) async {
    final box = await Hive.openBox<List<String>>(userAddressSort);
    await box.put(userAddressRecent, idList);
  }

  Future<List<String>?> getUserAddressRecentIdList() async {
    final box = await Hive.openBox<List<String>>(userAddressSort);
    return box.get(userAddressRecent);
  }

  static const userWeatherSort = 'user_weather_sort';
  static const userMyWeather = 'user_my_weather';
  Future updateUserMyWeather(List<String> idList) async {
    final box = await Hive.openBox<List<String>>(userWeatherSort);
    await box.put(userMyWeather, idList);
  }

  Future<List<String>?> getUserMyWeatherIdList() async {
    final box = await Hive.openBox<List<String>>(userWeatherSort);
    return box.get(userMyWeather);
  }


  static const userNotification = 'user_notification';
  Future updateUserNotification(String id, UserNotificationEntity notification) async {
    final box = await Hive.openBox<UserNotificationEntity>(userNotification);
    await box.put(id, notification);
  }

  Future deleteUserNotification(String id) async {
    final box = await Hive.openBox<UserNotificationEntity>(userNotification);
    return box.delete(id);
  }

  Future clearUserNotification() async {
    final box = await Hive.openBox<UserNotificationEntity>(userNotification);
    return box.clear();
  }

  Future<List<UserNotificationEntity>?> getUserNotificationList() async {
    final box = await Hive.openBox<UserNotificationEntity>(userNotification);
    return box.values.toList();
  }

  static const observatory = 'weather_observatory';
  Future<void> insertObservatoryList(List<ObservatoryEntity> list) async {
    final box = await Hive.openBox<ObservatoryEntity>(observatory);
    await box.addAll(list);
  }

  Future clearObservatory() async {
    final box = await Hive.openBox<ObservatoryEntity>(observatory);
    await box.clear();
  }

  Future<List<ObservatoryEntity>> getAllObservatoryList() async {
    final box = await Hive.openBox<ObservatoryEntity>(observatory);
    return box.values.toList();
  }

  static const weatherShortListTemperature = 'weather_short_list_temperature';
  Future updateWeatherShortListTemperature(String id, List<ShortTerm> shortTermList) async {
    var entity = WeatherShortTermListEntity();
    entity.id = id;
    entity.items = shortTermList.map((e) => e.toShortTermEntity()).toList();
    final box = await Hive.openBox<WeatherShortTermListEntity>(weatherShortListTemperature);
    await box.put(id, entity);
  }

  Future deleteWeatherShortListTemperature(String id) async {
    final box = await Hive.openBox<WeatherShortTermListEntity>(weatherShortListTemperature);
    return box.delete(id);
  }

  Future<WeatherShortTermListEntity?> getWeatherShortListTemperature(String id) async {
    final box = await Hive.openBox<WeatherShortTermListEntity>(weatherShortListTemperature);
    return box.get(id);
  }

  static const weatherUltraShortListSixTime = 'weather_short_list_six_time';
  Future updateWeatherShortListSixTime(String id, List<ShortTerm> shortTermList) async {
    var entity = WeatherShortTermListEntity();
    entity.id = id;
    entity.items = shortTermList.map((e) => e.toShortTermEntity()).toList();
    final box = await Hive.openBox<WeatherShortTermListEntity>(weatherUltraShortListSixTime);
    await box.put(id, entity);
  }

  Future deleteWeatherShortListSixTime(String id) async {
    final box = await Hive.openBox<WeatherShortTermListEntity>(weatherUltraShortListSixTime);
    return box.delete(id);
  }

  Future<WeatherShortTermListEntity?> getWeatherShortListSixTime(String id) async {
    final box = await Hive.openBox<WeatherShortTermListEntity>(weatherUltraShortListSixTime);
    return box.get(id);
  }

  static const weatherYesterdayShortListTemperature = 'weather_yesterday_short_list_temperature';
  Future updateWeatherYesterdayShortListTemperature(String id, List<ShortTerm> shortTermList) async {
    var entity = WeatherShortTermListEntity();
    entity.id = id;
    entity.items = shortTermList.map((e) => e.toShortTermEntity()).toList();
    final box = await Hive.openBox<WeatherShortTermListEntity>(weatherYesterdayShortListTemperature);
    await box.put(id, entity);
  }

  Future deleteWeatherYesterdayShortListTemperature(String id) async {
    final box = await Hive.openBox<WeatherShortTermListEntity>(weatherYesterdayShortListTemperature);
    return box.delete(id);
  }

  Future<WeatherShortTermListEntity?> getWeatherYesterdayShortListTemperature(String id) async {
    final box = await Hive.openBox<WeatherShortTermListEntity>(weatherYesterdayShortListTemperature);
    return box.get(id);
  }

  static const weatherUltraShortTemperature = 'weather_ultra_short_temperature';
  Future updateWeatherUltraShortTemperature(String id, WeatherUltraShortTermEntity weatherUltraShortTermEntity) async {
    final box = await Hive.openBox<WeatherUltraShortTermEntity>(weatherUltraShortTemperature);
    await box.put(id, weatherUltraShortTermEntity);
  }

  Future deleteWeatherUltraShortTemperature(String id) async {
    final box = await Hive.openBox<WeatherUltraShortTermEntity>(weatherUltraShortTemperature);
    return box.delete(id);
  }

  Future<WeatherUltraShortTermEntity?> getWeatherUltraShortTemperature(String id) async {
    final box = await Hive.openBox<WeatherUltraShortTermEntity>(weatherUltraShortTemperature);
    return box.get(id);
  }

  static const weatherUltraShortHumidity = 'weather_ultra_short_humidity';
  Future updateWeatherUltraShortHumidity(String id, WeatherUltraShortTermEntity weatherUltraShortTermEntity) async {
    final box = await Hive.openBox<WeatherUltraShortTermEntity>(weatherUltraShortHumidity);
    await box.put(id, weatherUltraShortTermEntity);
  }

  Future deleteWeatherUltraShortHumidity(String id) async {
    final box = await Hive.openBox<WeatherUltraShortTermEntity>(weatherUltraShortHumidity);
    return box.delete(id);
  }

  Future<WeatherUltraShortTermEntity?> getWeatherUltraShortHumidity(String id) async {
    final box = await Hive.openBox<WeatherUltraShortTermEntity>(weatherUltraShortHumidity);
    return box.get(id);
  }

  static const weatherUltraShortRain = 'weather_ultra_short_rain';
  Future updateWeatherUltraShortRain(String id, WeatherUltraShortTermEntity weatherUltraShortTermEntity) async {
    final box = await Hive.openBox<WeatherUltraShortTermEntity>(weatherUltraShortRain);
    await box.put(id, weatherUltraShortTermEntity);
  }

  Future deleteWeatherUltraShortRain(String id) async {
    final box = await Hive.openBox<WeatherUltraShortTermEntity>(weatherUltraShortRain);
    return box.delete(id);
  }

  Future<WeatherUltraShortTermEntity?> getWeatherUltraShortRain(String id) async {
    final box = await Hive.openBox<WeatherUltraShortTermEntity>(weatherUltraShortRain);
    return box.get(id);
  }

  static const weatherUltraShortRainStatus = 'weather_ultra_short_rain_status';
  Future updateWeatherUltraShortRainStatus(String id, WeatherUltraShortTermEntity weatherUltraShortTermEntity) async {
    final box = await Hive.openBox<WeatherUltraShortTermEntity>(weatherUltraShortRainStatus);
    await box.put(id, weatherUltraShortTermEntity);
  }

  Future deleteWeatherUltraShortRainStatus(String id) async {
    final box = await Hive.openBox<WeatherUltraShortTermEntity>(weatherUltraShortRainStatus);
    return box.delete(id);
  }

  Future<WeatherUltraShortTermEntity?> getWeatherUltraShortRainStatus(String id) async {
    final box = await Hive.openBox<WeatherUltraShortTermEntity>(weatherUltraShortRainStatus);
    return box.get(id);
  }

  static const weatherUltraShortWindSpeed = 'weatherUltraShortWindSpeed';
  Future updateWeatherUltraShortWindSpeed(String id, WeatherUltraShortTermEntity weatherUltraShortTermEntity) async {
    final box = await Hive.openBox<WeatherUltraShortTermEntity>(weatherUltraShortWindSpeed);
    await box.put(id, weatherUltraShortTermEntity);
  }

  Future deleteWeatherUltraShortWindSpeed(String id) async {
    final box = await Hive.openBox<WeatherUltraShortTermEntity>(weatherUltraShortWindSpeed);
    return box.delete(id);
  }

  Future<WeatherUltraShortTermEntity?> getWeatherUltraShortWindSpeed(String id) async {
    final box = await Hive.openBox<WeatherUltraShortTermEntity>(weatherUltraShortWindSpeed);
    return box.get(id);
  }

  static const weatherUltraShortWindDirection = 'weatherUltraShortWindDirection';
  Future updateWeatherUltraShortWindDirection(String id, WeatherUltraShortTermEntity weatherUltraShortTermEntity) async {
    final box = await Hive.openBox<WeatherUltraShortTermEntity>(weatherUltraShortWindDirection);
    await box.put(id, weatherUltraShortTermEntity);
  }

  Future deleteWeatherUltraShortWindDirection(String id) async {
    final box = await Hive.openBox<WeatherUltraShortTermEntity>(weatherUltraShortWindDirection);
    return box.delete(id);
  }

  Future<WeatherUltraShortTermEntity?> getWeatherUltraShortWindDirection(String id) async {
    final box = await Hive.openBox<WeatherUltraShortTermEntity>(weatherUltraShortWindDirection);
    return box.get(id);
  }

  static const weatherUltraviolet = 'weather_ultraviolet';
  Future updateWeatherUltraviolet(String id, WeatherUltravioletEntity weatherUltravioletEntity) async {
    final box = await Hive.openBox<WeatherUltravioletEntity>(weatherUltraviolet);
    await box.put(id, weatherUltravioletEntity);
  }

  Future deleteWeatherUltraviolet(String id) async {
    final box = await Hive.openBox<WeatherUltravioletEntity>(weatherUltraviolet);
    return box.delete(id);
  }

  Future<WeatherUltravioletEntity?> getWeatherUltraviolet(String id) async {
    final box = await Hive.openBox<WeatherUltravioletEntity>(weatherUltraviolet);
    return box.get(id);
  }

  static const weatherSunRiseSet = 'weather_sun_rise_set';
  Future updateWeatherSunRiseSet(String id, WeatherSunRiseSetEntity sunRiseSetEntity) async {
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
  Future updateWeatherFineDust(String id, WeatherFineDustEntity weatherFineDustEntity) async {
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
  Future updateWeatherMidTermLand(String id, WeatherMidTermLandEntity midTermLandEntity) async {
    final box = await Hive.openBox<WeatherMidTermLandEntity>(weatherMidTermLand);
    await box.put(id, midTermLandEntity);
  }

  Future deleteWeatherMidTermLand(String id) async {
    final box = await Hive.openBox<WeatherMidTermLandEntity>(weatherMidTermLand);
    return box.delete(id);
  }

  Future<WeatherMidTermLandEntity?> getWeatherMidTermLand(String id) async {
    final box = await Hive.openBox<WeatherMidTermLandEntity>(weatherMidTermLand);
    return box.get(id);
  }

  static const weatherMidTermTemperature = 'weather_mid_term_temperature';
  Future updateWeatherMidTermTemperature(String id, WeatherMidTermTemperatureEntity midTermTemperatureEntity) async {
    final box = await Hive.openBox<WeatherMidTermTemperatureEntity>(weatherMidTermTemperature);
    await box.put(id, midTermTemperatureEntity);
  }

  Future deleteWeatherMidTermTemperature(String id) async {
    final box = await Hive.openBox<WeatherMidTermTemperatureEntity>(weatherMidTermTemperature);
    return box.delete(id);
  }

  Future<WeatherMidTermTemperatureEntity?> getWeatherMidTermTemperature(String id) async {
    final box = await Hive.openBox<WeatherMidTermTemperatureEntity>(weatherMidTermTemperature);
    return box.get(id);
  }
}

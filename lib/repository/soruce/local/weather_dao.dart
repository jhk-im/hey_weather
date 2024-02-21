import 'package:hey_weather/repository/soruce/local/entity/address_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/observatory_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_sun_rise_set_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/user_notification_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/weather_ultraviolet_entity.dart';
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

  static const weatherUltraviolet = 'weather_ultraviolet';
  Future updateWeatherUltraviolet(String id, WeatherUltravioletEntity weatherUltravioletEntity) async {
    final box = await Hive.openBox<WeatherUltravioletEntity>(weatherUltraviolet);
    await box.put(id, weatherUltravioletEntity);
  }

  Future deleteWeatherUltraviolet(String id) async {
    final box = await Hive.openBox<WeatherUltravioletEntity>(weatherUltraviolet);
    return box.delete(id);
  }

  Future<WeatherUltravioletEntity?> getWeatherUltravioletWithId(String id) async {
    final box = await Hive.openBox<WeatherUltravioletEntity>(weatherUltraviolet);
    return box.get(id);
  }

  static const weatherSunRiseSet = 'weather_sun_rise_set';
  Future updateWeatherSunRiseSet(String id, WeatherSunRiseSetEntity sunRiseSetEntity) async {
    final box = await Hive.openBox<WeatherSunRiseSetEntity>(weatherSunRiseSet);
    await box.put(id, sunRiseSetEntity);
  }

  Future deleteSunRiseSet(String id) async {
    final box = await Hive.openBox<WeatherSunRiseSetEntity>(weatherSunRiseSet);
    return box.delete(id);
  }

  Future<WeatherSunRiseSetEntity?> getSunRiseSetWithId(String id) async {
    final box = await Hive.openBox<WeatherSunRiseSetEntity>(weatherSunRiseSet);
    return box.get(id);
  }
}

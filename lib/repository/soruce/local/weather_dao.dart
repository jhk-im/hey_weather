import 'package:hey_weather/repository/soruce/local/entity/address_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/user_notification_entity.dart';
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
}

import 'package:hey_weather/repository/soruce/local/entity/address_entity.dart';
import 'package:hive/hive.dart';

class WeatherDao {
  static const userAddress = 'userAddress';
  Future<void> insertAddress(AddressEntity address) async {
    final box = await Hive.openBox<AddressEntity>(userAddress);
    await box.add(address);
  }

  Future<void> updateAddress(AddressEntity address) async {
    final box = await Hive.openBox<AddressEntity>(userAddress);
    await box.put(address.code, address);
  }

  Future clearAddress() async {
    final box = await Hive.openBox<AddressEntity>(userAddress);
    await box.clear();
  }

  Future<List<AddressEntity>> getAllAddressList() async {
    final box = await Hive.openBox<AddressEntity>(userAddress);
    return box.values.toList();
  }
}

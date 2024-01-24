import 'package:hey_weather/repository/soruce/local/entity/address_entity.dart';
import 'package:hive/hive.dart';

class WeatherDao {
  static const userAddress = 'user_address';
  Future<void> insertAddress(AddressEntity address) async {
    final box = await Hive.openBox<AddressEntity>(userAddress);
    await box.add(address);
  }

  Future<void> updateAddressWithIndex(int index, AddressEntity address) async {
    final box = await Hive.openBox<AddressEntity>(userAddress);
    await box.putAt(index, address);
  }

  Future<void> updateAddressWithId(String id, AddressEntity address) async {
    final box = await Hive.openBox<AddressEntity>(userAddress);
    await box.put(id, address);
  }

  Future<AddressEntity?> getAddressWithId(String addressId) async {
    final box = await Hive.openBox<AddressEntity>(userAddress);
    return box.get(addressId);
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

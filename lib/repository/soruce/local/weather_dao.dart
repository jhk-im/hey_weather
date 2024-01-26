import 'package:hey_weather/repository/soruce/local/entity/address_entity.dart';
import 'package:hive/hive.dart';

class WeatherDao {
  static const userAddress = 'user_address';
  Future updateAddressWithId(String id, AddressEntity address) async {
    final box = await Hive.openBox<AddressEntity>(userAddress);
    await box.put(id, address);
  }

  Future<AddressEntity?> getAddressWithId(String addressId) async {
    final box = await Hive.openBox<AddressEntity>(userAddress);
    return box.get(addressId);
  }

  Future deleteAddressWithId(String addressId) async {
    final box = await Hive.openBox<AddressEntity>(userAddress);
    return box.delete(addressId);
  }

  Future<List<AddressEntity>> getAllAddressList() async {
    final box = await Hive.openBox<AddressEntity>(userAddress);
    return box.values.toList();
  }

  /*Future<void> insertAddress(AddressEntity address) async {
    final box = await Hive.openBox<AddressEntity>(userAddress);
    await box.add(address);
  }

  Future<void> updateAddressWithIndex(int index, AddressEntity address) async {
    final box = await Hive.openBox<AddressEntity>(userAddress);
    await box.putAt(index, address);
  }

  Future clearAddress() async {
    final box = await Hive.openBox<AddressEntity>(userAddress);
    await box.clear();
  }*/

  static const cardSort = 'card_sort';
  Future updateAddressCardSort(List<String> idList) async {
    final box = await Hive.openBox<List<String>>(cardSort);
    await box.put('address_card_sort', idList);
  }

  Future<List<String>?> getAddressSortIdList() async {
    final box = await Hive.openBox<List<String>>(cardSort);
    return box.get('address_card_sort');
  }

}

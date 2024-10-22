import 'package:get/get.dart';
import 'package:hey_weather/pages/address/address_controller.dart';
import 'package:hey_weather/pages/home/home_controller.dart';
import 'package:hey_weather/pages/setting/setting_main_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());

    Get.lazyPut(() => AddressController());
    Get.lazyPut(() => SettingMainController());
  }
}

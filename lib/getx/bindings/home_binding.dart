import 'package:get/get.dart';
import 'package:hey_weather/pages/home/home_controller.dart';

class HomeBinding implements Bindings {

  @override
  void dependencies() {
    Get.put(HomeController());
  }
}
import 'package:get/get.dart';
import 'package:hey_weather/pages/splash_controller.dart';

class InitBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}

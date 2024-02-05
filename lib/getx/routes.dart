import 'package:get/get.dart';
import 'package:hey_weather/getx/bindings/home_binding.dart';
import 'package:hey_weather/pages/address/address_page.dart';
import 'package:hey_weather/pages/home/home_page.dart';
import 'package:hey_weather/pages/setting/setting_main_page.dart';
import 'package:hey_weather/pages/setting/setting_notification_page.dart';
import 'package:hey_weather/pages/splash_page.dart';

class Routes {
  static const String routeRoot = '/';
  static const String routeHome = '/home';
  static const String routeAddress = '/address';
  static const String routeSetting = '/setting';
  static const String routeSettingNotification = '/setting_notification';

  static List<GetPage> pages = [
    GetPage(name: routeRoot, page: () => const SplashPage()),

    GetPage(name: routeHome, page: () => const HomePage(), binding: HomeBinding()),
    GetPage(name: routeAddress, page: () => const AddressPage(), binding: HomeBinding()),
    GetPage(name: routeSetting, page: () => const SettingMainPage(), binding: HomeBinding()),
    GetPage(name: routeSettingNotification, page: () => const SettingNotificationPage(), binding: HomeBinding()),
  ];
}
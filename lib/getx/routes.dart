import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/getx/bindings/home_binding.dart';
import 'package:hey_weather/pages/home/home_page.dart';
import 'package:hey_weather/pages/splash_page.dart';

class Routes {
  static const String routeRoot = '/';
  static const String routeRootHome = '/home';

  static List<GetPage> pages = [
    GetPage(name: routeRoot, page: () => const SplashPage()),
    GetPage(name: routeRootHome, page: () => const HomePage(), binding: HomeBinding()),
  ];

  static List<Widget> navigationPages = const [

  ];
}
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/image_utils.dart';
import 'package:hey_weather/pages/splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryDarkerColor,
      body: Center(
        child: ImageUtils.svg(context, 'splash_logo', width: 120, height: 70),
      ),
    );
  }
}
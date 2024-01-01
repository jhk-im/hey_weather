import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hey_weather/common/image_utils.dart';
import 'package:hey_weather/pages/splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.primary,
      body: Center(
        child: ImageUtils.svg(context, 'splash_logo', width: 135, height: 80,),
      ),
    );
  }
}
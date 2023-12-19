import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/pages/home/home_controller.dart';
import 'package:hey_weather/widgets/loading_widget.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() => LoadingWidget(controller.isLoading)),
          ],
        ),
      ),
    );
  }
}
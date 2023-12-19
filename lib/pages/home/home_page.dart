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
            Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Expanded(child: Text('home.card.1'.tr)),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FlutterLogo(),
                          const SizedBox(height: 16),
                          Text('home.card.2'.tr),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.flutter_dash, color: Colors.lightBlue,),
                          const SizedBox(height: 16),
                          Text('home.card.3'.tr),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Obx(() => LoadingWidget(controller.isLoading)),
          ],
        ),
      ),
    );
  }
}
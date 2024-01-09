import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/image_utils.dart';

class HeyWeatherLargeCard extends StatefulWidget {
  const HeyWeatherLargeCard({
    super.key,
    required this.sunrise,
    required this.sunset,
  });

  final String sunrise;
  final String sunset;

  @override
  State<HeyWeatherLargeCard> createState() => _HeyWeatherLargeCardState();
}

class _HeyWeatherLargeCardState extends State<HeyWeatherLargeCard> {
  final status = 0.obs; // 0 -> default, 1 -> edit, 2 -> select

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width) - 28;
    return Obx(() => GestureDetector(
      onTap: () {
        if (status.value == 2) {
          status.value = 0;
        } else {
          status.value += 1;
        }
      },
      child: Container(
        width: width,
        height: width,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kBaseColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: status.value == 2 ? kPrimaryDarkerColor : kBaseColor,
            width: 1, // 외곽선 두께
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // icon, title
                  Row(
                    children: [
                      ImageUtils.weatherIcon(
                        context,
                        'weather_by_time',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 6),
                      HeyText.bodySemiBold(
                        'weather_by_time'.tr,
                        fontSize: kFont16,
                        color: kTextDisabledColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 55,
                            child: Column(
                              children: [
                                HeyText.title3Bold(
                                  '23˚'.tr,
                                  fontSize: kFont16,
                                  color: kTextDisabledColor,
                                ),
                                const SizedBox(height: 16),
                                RotatedBox(
                                  quarterTurns: 3,
                                  child: SizedBox(
                                    width: 60,
                                    child: LinearProgressIndicator(
                                      borderRadius: BorderRadius.circular(10.0),
                                      backgroundColor: kButtonColor,
                                      valueColor: const AlwaysStoppedAnimation<Color>( kProgressForegroundColor),
                                      value: 0.8,
                                      minHeight: 6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Visibility(
              visible: status.value > 0,
              child: Container(
                color: status.value == 1 ? Colors.transparent : kBaseColor.withOpacity(0.5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        ImageUtils.icon(
                          context,
                          status.value == 1
                              ? 'circle_check'
                              : 'circle_check_selected',
                          width: 24,
                          height: 24,
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';

class HeyWeatherSunCard extends StatefulWidget {
  const HeyWeatherSunCard({
    super.key,
    required this.sunrise,
    required this.sunset,
  });

  final String sunrise;
  final String sunset;

  @override
  State<HeyWeatherSunCard> createState() => _HeyWeatherSunCardState();
}

class _HeyWeatherSunCardState extends State<HeyWeatherSunCard> {
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
                children: [
                  // icon, title
                  Row(
                    children: [
                      SvgUtils.icon(
                        context,
                        'sunrise_sunset',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 6),
                      HeyText.bodySemiBold(
                        'sunrise_sunset'.tr,
                        fontSize: kFont16,
                        color: kTextDisabledColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Spacer(),
                      Column(
                        children: [
                          SvgUtils.icon(
                            context,
                            'sunrise',
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              HeyText.bodySemiBold(
                                'am'.tr,
                                fontSize: kFont16,
                                color: kTextDisabledColor,
                              ),
                              const SizedBox(width: 2),
                              HeyText.bodySemiBold(
                                widget.sunrise,
                                fontSize: kFont16,
                                color: kTextPointColor,
                              ),
                            ],
                          )
                        ],
                      ),
                      const Spacer(),
                      Container(
                        height: 80,
                        width: 1,
                        color: kDividerPrimaryColor,
                      ),
                      const VerticalDivider(width: 1, color: kTextDisabledColor),
                      const Spacer(),
                      Column(
                        children: [
                          SvgUtils.icon(
                            context,
                            'sunset',
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              HeyText.bodySemiBold(
                                'am'.tr,
                                fontSize: kFont16,
                                color: kTextDisabledColor,
                              ),
                              const SizedBox(width: 2),
                              HeyText.bodySemiBold(
                                widget.sunset,
                                fontSize: kFont16,
                                color: kTextPointColor,
                              ),
                            ],
                          )
                        ],
                      ),
                      const Spacer(),
                    ],
                  )
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
                        SvgUtils.icon(
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
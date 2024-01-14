import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/image_utils.dart';

class HeyWeatherBigCard extends StatefulWidget {
  const HeyWeatherBigCard({
    super.key,
    required this.sunrise,
    required this.sunset,
  });

  final String sunrise;
  final String sunset;

  @override
  State<HeyWeatherBigCard> createState() => _HeyWeatherBigCardState();
}

class _HeyWeatherBigCardState extends State<HeyWeatherBigCard> {
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
        height: width * 1.18,
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
                      ImageUtils.icon(
                        context,
                        'weather_week',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 6),
                      HeyText.bodySemiBold(
                        'weather_week'.tr,
                        fontSize: kFont16,
                        color: kTextDisabledColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _weatherItem(
                    dateText: '',
                    dateText2: '09.12',
                    amPercent: 100,
                    pmPercent: 100,
                    amIconName: 'drizzle_on',
                    pmIconName: 'drizzle_on',
                    minTemp: -1,
                    maxTemp: 5,
                  ),
                  const SizedBox(height: 10),
                  _weatherItem(
                    dateText: 'tomorrow'.tr,
                    dateText2: '09.13',
                    amPercent: 30,
                    pmPercent: 30,
                    amIconName: 'drizzle_on',
                    pmIconName: 'drizzle_on',
                    minTemp: 9,
                    maxTemp: 11,
                  ),
                  const SizedBox(height: 10),
                  _weatherItem(
                    dateText: '화',
                    dateText2: '09.13',
                    amPercent: 10,
                    pmPercent: 0,
                    amIconName: 'drizzle_on',
                    pmIconName: 'partly_cloudy',
                    minTemp: 11,
                    maxTemp: 15,
                  ),
                  const SizedBox(height: 10),
                  _weatherItem(
                    dateText: '수',
                    dateText2: '09.15',
                    amPercent: 10,
                    pmPercent: 0,
                    amIconName: 'drizzle_on',
                    pmIconName: 'partly_cloudy',
                    minTemp: 13,
                    maxTemp: 15,
                  ),
                  const SizedBox(height: 10),
                  _weatherItem(
                    dateText: '목',
                    dateText2: '09.16',
                    amPercent: 10,
                    pmPercent: 0,
                    amIconName: 'drizzle_on',
                    pmIconName: 'partly_cloudy',
                    minTemp: 11,
                    maxTemp: 25,
                  ),
                  const SizedBox(height: 10),
                  _weatherItem(
                    dateText: '금',
                    dateText2: '09.17',
                    amPercent: 10,
                    pmPercent: 0,
                    amIconName: 'drizzle_on',
                    pmIconName: 'partly_cloudy',
                    minTemp: 11,
                    maxTemp: 25,
                  ),
                  const SizedBox(height: 10),
                  _weatherItem(
                    dateText: '토',
                    dateText2: '09.12',
                    amPercent: 10,
                    pmPercent: 0,
                    amIconName: 'drizzle_on',
                    pmIconName: 'partly_cloudy',
                    minTemp: 11,
                    maxTemp: 25,
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

  Widget _weatherItem({
    String dateText = '',
    String dateText2 = '',
    int amPercent = 0,
    int pmPercent = 0,
    String amIconName = '',
    String pmIconName = '',
    int minTemp = 0,
    int maxTemp = 0,
  }) {
    return SizedBox(
      width: double.maxFinite,

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              HeyText.callOutSemiBold(
                dateText.isEmpty ? 'today'.tr : dateText,
                color: dateText.isEmpty ? kTextPointColor : kTextDisabledColor,
              ),
              HeyText.caption1(
                dateText2,
                color: kTextPointColor.withOpacity(0.3),
              ),
            ],
          ),

          const Spacer(flex: 4),

          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Visibility(
                    visible: dateText.isEmpty,
                    child: HeyText.caption1(
                      'am'.tr,
                      color: kTextDisabledColor,
                    ),
                  ),
                  HeyText.caption1(
                    '$amPercent%',
                    color: amPercent > 0 ? kPrimarySecondColor : kDisabledText,
                  ),
                ],
              ),
              const SizedBox(width: 8),
              ImageUtils.weatherIcon(
                context,
                amIconName,
                width: 34,
                height: 34,
              ),
              const SizedBox(width: 8),
              ImageUtils.weatherIcon(
                context,
                pmIconName,
                width: 34,
                height: 34,
              ),
              const SizedBox(width: 8),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: dateText.isEmpty,
                    child: HeyText.caption1(
                      'pm'.tr,
                      color: kTextDisabledColor,
                    ),
                  ),
                  HeyText.caption1(
                    '$pmPercent%',
                    color: pmPercent > 0 ? kPrimarySecondColor : kDisabledText,
                  ),
                ],
              ),
            ],
          ),

          const Spacer(flex: 3),

          SizedBox(
            child: Row(
              children: [
                const SizedBox(width: 16),
                HeyText.bodySemiBold(
                  '$minTemp˚',
                  fontSize: kFont16,
                  color: kTextPointColor.withOpacity(0.6),
                ),
                const SizedBox(width: 16),
                HeyText.bodySemiBold(
                  '$maxTemp˚',
                  fontSize: kFont16,
                  color: kTextPointColor,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
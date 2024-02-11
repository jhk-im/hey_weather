import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';

class HeyWeatherWeekCard extends StatefulWidget {
  const HeyWeatherWeekCard({
    super.key,
    this.buttonStatus = 0,
    this.setHeight,
    this.onSelect,
    this.onRemove,
  });

  final int buttonStatus;
  final Function? setHeight;
  final Function? onSelect;
  final Function? onRemove;

  @override
  State<HeyWeatherWeekCard> createState() => _HeyWeatherWeekCardState();
}

class _HeyWeatherWeekCardState extends State<HeyWeatherWeekCard> {
  final id = kWeatherCardWeek;
  final status = 0.obs; // 0 -> default, 1 -> edit, 2 -> select, 3 -> delete

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width) - 28;
    double height = 432;
    status(widget.buttonStatus);
    widget.setHeight?.call(id, height);
    return Obx(() => Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: status.value == 1 || status.value == 2 ? () {
          if (status.value == 1) {
            status(2);
          } else {
            status(1);
          }
          widget.onSelect?.call(id, status.value == 2);
        } : null,
        child: Container(
          width: width,
          height: height,
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
                        SvgUtils.icon(
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
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                  ],
                ),
              ),

              Visibility(
                visible: status.value > 0,
                child: Container(
                  color: status.value == 1 || status.value == 3 ? Colors.transparent : kBaseColor.withOpacity(0.5),
                  child: Column(
                    children: [
                      InkWell(
                        splashColor: kBaseColor,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onTap: status.value == 3 ? () {
                          widget.onRemove?.call(id);
                        } : null,
                        child: Row(
                          children: [
                            const Spacer(),
                            SvgUtils.icon(
                              context,
                              status.value == 1
                                  ? 'circle_check'
                                  : status.value == 2
                                  ? 'circle_check_selected'
                                  : 'circle_minus',
                              width: 24,
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
              SvgUtils.weatherIcon(
                context,
                amIconName,
                width: 34,
                height: 34,
              ),
              const SizedBox(width: 8),
              SvgUtils.weatherIcon(
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
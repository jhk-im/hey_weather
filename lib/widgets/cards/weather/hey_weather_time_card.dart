import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';

class HeyWeatherTimeCard extends StatefulWidget {
  const HeyWeatherTimeCard({
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
  State<HeyWeatherTimeCard> createState() => _HeyWeatherTimeCardState();
}

class _HeyWeatherTimeCardState extends State<HeyWeatherTimeCard> {
  final id = kWeatherCardTime;
  final status = 0.obs; // 0 -> default, 1 -> edit, 2 -> select, 3 -> delete

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width) - 28;
    double height = 286;
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
          padding: const EdgeInsets.only(left: 14, top: 14, bottom: 14),
          decoration: BoxDecoration(
            color: kBaseColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: status.value == 2 ? kPrimaryDarkerColor : kBaseColor,
              width: 1, // 외곽선 두께
            ),
          ),
          child: Stack(
            alignment: AlignmentDirectional.centerEnd,
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
                            _weatherItem(
                              temp: 23,
                              progress: 0.3,
                              iconName: 'partly_cloudy',
                              percent: 0,
                              timeText: '',
                            ),
                            _weatherItem(
                              temp: 25,
                              progress: 0.6,
                              iconName: 'drizzle_on',
                              percent: 60,
                              timeText: '오후 6시',
                            ),
                            _weatherItem(
                              temp: 22,
                              progress: 0.55,
                              iconName: 'drizzle_on',
                              percent: 50,
                              timeText: '오후 7시',
                            ),
                            _weatherItem(
                              temp: 21,
                              progress: 0.5,
                              iconName: 'drizzle_on',
                              percent: 80,
                              timeText: '오후 8시',
                            ),
                            _weatherItem(
                              temp: 20,
                              progress: 0.4,
                              iconName: 'drizzle_on',
                              percent: 20,
                              timeText: '오후 9시',
                            ),
                            _weatherItem(
                              temp: 19,
                              progress: 0.3,
                              iconName: 'drizzle_on',
                              percent: 30,
                              timeText: '오후 10시',
                            ),
                            _weatherItem(
                              temp: 19,
                              progress: 0.3,
                              iconName: 'drizzle_on',
                              percent: 30,
                              timeText: '오후 11시',
                            ),
                            _weatherItem(
                              temp: 19,
                              progress: 0.3,
                              iconName: 'drizzle_on',
                              percent: 30,
                              timeText: '오후 12시',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      
              Container(
                width: 50,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [kWidgetGradientLeft, kWidgetGradientRight],
                  ),
                ),
              ),
      
              Visibility(
                visible: status.value > 0,
                child: Container(
                  color: status.value == 1 || status.value == 3 ? Colors.transparent : kBaseColor.withOpacity(0.5),
                  padding: const EdgeInsets.only(right: 14),
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
    int temp = 0,
    double progress = 0,
    String iconName = '',
    int percent = 0,
    String timeText = '',
  }) {
    return SizedBox(
      width: 55,
      child: Column(
        children: [
          HeyText.title3Bold(
            '$temp˚',
            fontSize: kFont16,
            color: kTextDisabledColor,
          ),

          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: RotatedBox(
              quarterTurns: 3,
              child: SizedBox(
                width: 60,
                child: LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(10.0),
                  backgroundColor: kButtonColor,
                  valueColor: const AlwaysStoppedAnimation<Color>( kProgressForegroundColor),
                  value: 0.5,
                  minHeight: 6,
                ),
              ),
            ),
          ),

          SvgUtils.weatherIcon(
            context,
            iconName,
            width: 32,
            height: 32,
          ),

          const SizedBox(height: 1.5),
          HeyText.caption1(
            '$percent%',
            color: percent > 0 ? kPrimarySecondColor : Colors.transparent,
          ),
          const Spacer(),
          HeyText.subHeadline(
            timeText.isEmpty ? 'now'.tr : timeText,
            fontSize: kFont12,
            color: timeText.isEmpty ? kTextPointColor : kTextDisabledColor,
          ),
        ],
      ),
    );
  }
}
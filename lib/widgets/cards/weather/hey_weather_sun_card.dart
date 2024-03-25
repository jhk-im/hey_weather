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
    this.buttonStatus = 0,
    this.setHeight,
    this.onSelect,
    this.onRemove,
  });

  final String sunrise;
  final String sunset;
  final int buttonStatus;
  final Function? setHeight;
  final Function? onSelect;
  final Function? onRemove;

  @override
  State<HeyWeatherSunCard> createState() => _HeyWeatherSunCardState();
}

class _HeyWeatherSunCardState extends State<HeyWeatherSunCard> {
  final id = kWeatherCardSun;
  final status = 0.obs; // 0 -> default, 1 -> edit, 2 -> select, 3 -> delete

  @override
  Widget build(BuildContext context) {
    double editWidth = (MediaQuery.of(context).size.width / 2) - 28;
    double width = (MediaQuery.of(context).size.width) - 28;
    double height = 170;
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
          width: status.value == 3 ? editWidth : width,
          height: height,
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 24, right: status.value == 3 ? 20 : 24),
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
              Column(
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
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SvgUtils.icon(
                              context,
                              'sunrise',
                              width: 40,
                              height: 40,
                            ),
                            Row(
                              children: [
                                HeyText.bodySemiBold(
                                  'am'.tr,
                                  fontSize: kFont16,
                                  color: kTextDisabledColor,
                                ),
                                if (status.value != 3) ... {
                                  const SizedBox(width: 2),
                                  HeyText.bodySemiBold(
                                    widget.sunrise,
                                    fontSize: kFont16,
                                    color: kTextPointColor,
                                  ),
                                },
                              ],
                            ),
                          ],
                        ),

                        Container(
                          width: 1,
                          color: kButtonColor,
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SvgUtils.icon(
                              context,
                              'sunset',
                              width: 40,
                              height: 40,
                            ),
                            Row(
                              children: [
                                HeyText.bodySemiBold(
                                  'pm'.tr,
                                  fontSize: kFont16,
                                  color: kTextDisabledColor,
                                ),
                                if (status.value != 3) ... {
                                  const SizedBox(width: 2),
                                  HeyText.bodySemiBold(
                                    widget.sunset,
                                    fontSize: kFont16,
                                    color: kTextPointColor,
                                  ),
                                },
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
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
}
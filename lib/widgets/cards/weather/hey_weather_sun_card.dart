import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';
import 'package:hey_weather/common/utils.dart';

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

  @override
  Widget build(BuildContext context) {
    RxInt status = widget
        .buttonStatus.obs; // 0 -> default, 1 -> edit, 2 -> select, 3 -> delete

    double editWidth = (MediaQuery.of(context).size.width / 2) - 28;
    double width = (MediaQuery.of(context).size.width) - 28;
    double height = 170;
    widget.setHeight?.call(id, height);

    RxDouble rxWidth;
    if (status.value == 3) {
      rxWidth = editWidth.obs;
    } else {
      rxWidth = width.obs;
    }

    return Obx(() => Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: status.value == 1 || status.value == 2
                ? () {
                    if (status.value == 1) {
                      status(2);
                    } else {
                      status(1);
                    }
                    widget.onSelect?.call(id, status.value == 2);
                  }
                : null,
            child: ShakeWidget(
              autoPlay: status.value == 3,
              duration: const Duration(milliseconds: 5700),
              shakeConstant: ShakeLittleConstant1(),
              child: Container(
                width: rxWidth.value,
                height: height,
                padding: const EdgeInsets.only(top: 14, bottom: 20, left: 24),
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
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          child: Row(
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
                        ),
                        const SizedBox(height: 24),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(right: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SvgUtils.icon(
                                      context,
                                      'sunrise',
                                      width: 40,
                                      height: 40,
                                    ),
                                    Row(
                                      children: [
                                        if (status.value != 3) ...{
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
                                        } else ...{
                                          HeyText.bodySemiBold(
                                            Utils().convertToTimeFormat2(
                                                widget.sunrise),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SvgUtils.icon(
                                      context,
                                      'sunset',
                                      width: 40,
                                      height: 40,
                                    ),
                                    Row(
                                      children: [
                                        if (status.value != 3) ...{
                                          HeyText.bodySemiBold(
                                            'pm'.tr,
                                            fontSize: kFont16,
                                            color: kTextDisabledColor,
                                          ),
                                          const SizedBox(width: 2),
                                          HeyText.bodySemiBold(
                                            widget.sunset,
                                            fontSize: kFont16,
                                            color: kTextPointColor,
                                          ),
                                        } else ...{
                                          HeyText.bodySemiBold(
                                            Utils().convertToTimeFormat2(
                                                widget.sunset),
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
                          ),
                        )
                      ],
                    ),
                    Visibility(
                      visible: status.value > 0,
                      child: Container(
                        color: status.value == 1 || status.value == 3
                            ? Colors.transparent
                            : kBaseColor.withOpacity(0.5),
                        padding: const EdgeInsets.only(right: 14),
                        child: Column(
                          children: [
                            InkWell(
                              splashColor: kBaseColor,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              onTap: status.value == 3
                                  ? () {
                                      widget.onRemove?.call(id);
                                    }
                                  : null,
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
          ),
        ));
  }
}

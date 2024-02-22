import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';

class HeyWeatherHumidityCard extends StatefulWidget {
  const HeyWeatherHumidityCard({
    super.key,
    this.today = 0,
    this.yesterday = 0,
    this.buttonStatus = 0,
    this.setHeight,
    this.onSelect,
    this.onRemove,
  });
  final int today;
  final int yesterday;
  final int buttonStatus;
  final Function? setHeight;
  final Function? onSelect;
  final Function? onRemove;

  @override
  State<HeyWeatherHumidityCard> createState() => _HeyWeatherHumidityCardState();
}

class _HeyWeatherHumidityCardState extends State<HeyWeatherHumidityCard> {
  final status = 0.obs; // 0 -> default, 1 -> edit, 2 -> select, 3 -> delete

  // Colors
  final Map<String, Color> stateColors = {
    'low'.tr : kPrimaryDarkerColor,
    'normal'.tr : kHeyGreenColor,
    'high'.tr : kSubColor,
    'very_high'.tr: kHeyOrangeColor,
  };

  final stateList = [
    'low'.tr,
    'normal'.tr,
    'high'.tr,
    'very_high'.tr,
  ];

  @override
  Widget build(BuildContext context) {
    String id = kWeatherCardHumidity;
    double width = (MediaQuery.of(context).size.width / 2) - 28;
    status(widget.buttonStatus);
    widget.setHeight?.call(id, width);

    // humidity
    int today = 0;
    int yesterday = 0;
    int diff = 0;
    bool isUp = false;
    today = widget.today;
    yesterday = widget.yesterday;
    if (today > yesterday) {
      isUp = true;
      diff = today - yesterday;
    } else {
      diff = yesterday - today;
    }

    // 0 이상 40 미만 = 낮음
    // 40 이상 60 미만 = 보통
    // 60 이상 80 미만 = 높음
    // 80 이상 = 매우 높음
    int stateIndex = 0;
    if (today >= 40 && today < 60) {
      stateIndex = 1;
    } else if (today >= 60 && today < 80) {
      stateIndex = 2;
    } else if (today >= 80) {
      stateIndex = 3;
    }


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
          height: width,
          constraints: const BoxConstraints(minHeight: 162),
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
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // icon, title
                            Row(
                              children: [
                                SvgUtils.icon(
                                  context,
                                  'humidity',
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(width: 6),
                                HeyText.bodySemiBold(
                                  'humidity'.tr,
                                  fontSize: kFont16,
                                  color: kTextDisabledColor,
                                ),
                              ],
                            ),
                            const Spacer(),
                            // status
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: HeyText.subHeadlineSemiBold(
                                stateList[stateIndex],
                                color: stateColors[stateList[stateIndex]] ?? kTextPointColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                HeyText.largeTitleBold(
                                  today.toString(),
                                  color: kTextPointColor,
                                ),
                                const SizedBox(width: 4),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: HeyText.bodySemiBold(
                                    '%',
                                    color: kTextDisabledColor,
                                    fontSize: kFont20,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),

                            Row(
                              children: [
                                if (today == yesterday) ... {
                                  HeyText.footnote(
                                    'same_yesterday'.tr,
                                    color: kTextDisabledColor,
                                  ),
                                } else ... {
                                  HeyText.footnote(
                                    'than_yesterday'.tr,
                                    color: kTextDisabledColor,
                                  ),
                                  const SizedBox(width: 4),
                                  SvgUtils.icon(
                                    context,
                                    isUp ? 'up' : 'down',
                                    width: 10,
                                    height: 10,
                                  ),
                                  HeyText.footnote(
                                    diff.toString(),
                                    color: kTextDisabledColor,
                                  ),
                                }
                              ],
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
}
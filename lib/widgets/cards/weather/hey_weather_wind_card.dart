import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';

class HeyWeatherWindCard extends StatefulWidget {
  const HeyWeatherWindCard({
    super.key,
    this.speed = 0,
    this.direction = 0,
    this.buttonStatus = 0,
    this.setHeight,
    this.onSelect,
    this.onRemove,
  });

  final double speed;
  final int direction;
  final int buttonStatus;
  final Function? setHeight;
  final Function? onSelect;
  final Function? onRemove;

  @override
  State<HeyWeatherWindCard> createState() => _HeyWeatherWindCardState();
}

class _HeyWeatherWindCardState extends State<HeyWeatherWindCard> {
  final status = 0.obs; // 0 -> default, 1 -> edit, 2 -> select, 3 -> delete

  // Colors
  final Map<String, Color> stateColors = {
    'weak'.tr : kPrimaryDarkerColor,
    'normal'.tr : kHeyGreenColor,
    'strong'.tr: kHeyOrangeColor,
    'very_strong'.tr: kHeyRedColor,
  };

  final stateList = [
    'weak'.tr,
    'normal'.tr,
    'strong'.tr,
    'very_strong'.tr,
  ];


  @override
  Widget build(BuildContext context) {
    String id = kWeatherCardWind;
    double width = (MediaQuery.of(context).size.width / 2) - 28;
    status(widget.buttonStatus);
    widget.setHeight?.call(id, width);

    // 4 미만 -> 약함
    // 4 이상 9 미만 -> 약함
    // 9 이상 14 미만 -> 강함
    // 14 이상 -> 위험
    int stateIndex = 0;
    if (widget.speed >= 4.0 && widget.speed < 9.0) {
      stateIndex = 1;
    } else if (widget.speed >= 9.0 && widget.speed < 14.0) {
      stateIndex = 2;
    } else if (widget.speed >= 14.0) {
      stateIndex = 3;
    }

    // 0 - 45 = NNE 북북동
    // 45 - 90 = NEE 북동
    // 90 - 135 = ESE 동남동
    // 135 - 180 = SE 남동
    // 180 - 225 = SSW 남남서
    // 225 - 270 = SWW 남서
    // 270 - 315 = WNW 서북서
    // 315 - 360 = NWN 북서
    String direction = '북북동';
    if (widget.direction >= 45 && widget.direction < 90) {
      direction = '북동';
    } else if (widget.direction >= 90 && widget.direction < 135) {
      direction = '동남동';
    } else if (widget.direction >= 135 && widget.direction < 180) {
      direction = '남동';
    } else if (widget.direction >= 180 && widget.direction < 225) {
      direction = '남남서';
    } else if (widget.direction >= 225 && widget.direction < 270) {
      direction = '남서';
    } else if (widget.direction >= 270 && widget.direction < 315) {
      direction = '서북서';
    } else if (widget.direction >= 315 && widget.direction < 360) {
      direction = '북서';
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
                                  'wind',
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(width: 6),
                                HeyText.bodySemiBold(
                                  'wind'.tr,
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
                                  widget.speed < 1 ? '1' : widget.speed.round().toString(),
                                  color: kTextPointColor,
                                ),
                                const SizedBox(width: 4),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: HeyText.bodySemiBold(
                                    'm/s',
                                    color: kTextDisabledColor,
                                    fontSize: kFont20,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),

                            Row(
                              children: [
                                HeyText.footnote(
                                  direction,
                                  color: kTextDisabledColor,
                                ),
                                const SizedBox(width: 4),
                                SvgUtils.icon(
                                  context,
                                  'direction',
                                  width: 10,
                                  height: 10,
                                ),
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
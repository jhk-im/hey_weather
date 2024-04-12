import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';

class HeyWeatherUltravioletCard extends StatefulWidget {
  const HeyWeatherUltravioletCard({
    super.key,
    this.ultraviolet = 0,
    this.buttonStatus = 0,
    this.setHeight,
    this.onSelect,
    this.onRemove,
  });

  final int ultraviolet;

  final int buttonStatus;
  final Function? setHeight;
  final Function? onSelect;
  final Function? onRemove;

  @override
  State<HeyWeatherUltravioletCard> createState() => _HeyWeatherUltravioletCardState();
}

class _HeyWeatherUltravioletCardState extends State<HeyWeatherUltravioletCard> {
  final status = 0.obs; // 0 -> default, 1 -> edit, 2 -> select, 3 -> delete

  // Colors
  final Map<String, Color> stateColors = {
    'low'.tr : kPrimaryDarkerColor,
    'normal'.tr : kHeyGreenColor,
    'high'.tr : kSubColor,
    'very_high'.tr: kHeyOrangeColor,
    'danger'.tr: kHeyRedColor,
  };

  final stateList = [
    'low'.tr,
    'normal'.tr,
    'high'.tr,
    'very_high'.tr,
    'danger'.tr,
  ];

  @override
  Widget build(BuildContext context) {
    String id = kWeatherCardUltraviolet;
    double width = (MediaQuery.of(context).size.width / 2) - 28;
    status(widget.buttonStatus);
    widget.setHeight?.call(id, width);

    int stateIndex = 0;
    int ultraviolet = widget.ultraviolet;
    if (ultraviolet > 2 && ultraviolet < 6) {
      stateIndex = 1;
    } else if (ultraviolet > 5 && ultraviolet < 8) {
      stateIndex = 2;
    } else if (ultraviolet > 7 && ultraviolet < 11) {
      stateIndex = 3;
    } else if (ultraviolet > 10) {
      ultraviolet = 12;
      stateIndex = 4;
    }

    const maxProgress = 82;
    var progress = (ultraviolet / 12) * 82;

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
        child: ShakeWidget(
          autoPlay: status.value == 3,
          duration: const Duration(milliseconds: 5800),
          shakeConstant: ShakeLittleConstant1(),
          child: Container(
            width: width,
            height: 170,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // icon, title
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          child: Row(
                            children: [
                              SvgUtils.icon(
                                context,
                                'ultraviolet',
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: 6),
                              HeyText.bodySemiBold(
                                'ultraviolet'.tr,
                                fontSize: kFont16,
                                color: kTextDisabledColor,
                              ),
                            ],
                          ),
                        ),

                        // status
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: HeyText.subHeadlineSemiBold(
                            stateList[stateIndex],
                            color: stateColors[stateList[stateIndex]] ?? kTextPointColor,
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.only(top: 16, bottom: 8),
                          child: HeyText.largeTitleBold(
                            widget.ultraviolet.toString(),
                            color: kTextPointColor,
                          ),
                        ),

                        Stack(
                          children: [
                            Container(
                              width: double.maxFinite,
                              height: 8,
                              margin: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  colors: [
                                    kPrimaryDarkerColor,
                                    kHeyGreenColor,
                                    kSubColor,
                                    kHeyOrangeColor,
                                    kHeyRedColor,
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                            ),
                            Positioned(
                              left: (progress / maxProgress) * (width - 50),
                              child: GestureDetector(
                                // onHorizontalDragUpdate: (details) {
                                //   // 좌우 드래그 시 프로그레스 바 업데이트
                                //   updateProgress(details.primaryDelta! / 200.0);
                                // },
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
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
      ),
    ));
  }
}
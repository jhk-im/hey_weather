import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';

class HeyWeatherUltravioletCard extends StatefulWidget {
  const HeyWeatherUltravioletCard({
    super.key,
    required this.id,
    required this.ultraviolet,
    this.buttonStatus = 0,
    this.setHeight,
    this.onSelect,
    this.onRemove,
  });

  final String id;
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
    double width = (MediaQuery.of(context).size.width / 2) - 28;
    status(widget.buttonStatus);
    widget.setHeight?.call(widget.id, width);

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
          widget.onSelect?.call(widget.id, status.value == 2);
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeyText.largeTitleBold(
                              widget.ultraviolet.toString(),
                              color: kTextPointColor,
                            ),
                            const Spacer(),
                            Stack(
                              children: [
                                Container(
                                  width: double.maxFinite,
                                  height: 8,
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
                          widget.onRemove?.call(widget.id);
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
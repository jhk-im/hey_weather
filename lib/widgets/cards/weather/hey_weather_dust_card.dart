import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';

class HeyWeatherDustCard extends StatefulWidget {
  const HeyWeatherDustCard({
    super.key,
    required this.fine,
    required this.ultra,
    this.buttonStatus = 0,
    this.setHeight,
    this.onSelect,
    this.onRemove,
  });

  final int fine;
  final int ultra;
  final int buttonStatus;
  final Function? onSelect;
  final Function? onRemove;
  final Function? setHeight;

  @override
  State<HeyWeatherDustCard> createState() => _HeyWeatherDustCardState();
}

class _HeyWeatherDustCardState extends State<HeyWeatherDustCard> {
  final id = kWeatherCardDust;
  final status = 0.obs; // 0 -> default, 1 -> edit, 2 -> select, 3 -> delete

  // Colors
  final Map<String, Color> stateColors = {
    'good'.tr : kPrimaryDarkerColor,
    'normal'.tr : kHeyGreenColor,
    'bad'.tr : kHeyOrangeColor,
    'very_bad'.tr: kHeyRedColor,
  };

  final stateList = [
    'good'.tr,
    'normal'.tr,
    'bad'.tr,
    'very_bad'.tr,
  ];

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width) - 28;
    double height = 173;
    status(widget.buttonStatus);
    widget.setHeight?.call(id, height);

    String fineState = stateList[0];
    if (widget.fine > 30 && widget.fine <= 80) {
      fineState = stateList[1];
    } else if (widget.fine > 80 && widget.fine <= 150) {
      fineState = stateList[2];
    } else if (widget.fine > 150) {
      fineState = stateList[3];
    }

    String ultraState = stateList[0];
    if (widget.ultra > 15 && widget.ultra <= 50) {
      ultraState = stateList[1];
    } else if (widget.ultra > 50 && widget.ultra <= 100) {
      ultraState = stateList[2];
    } else if (widget.ultra > 100) {
      ultraState = stateList[3];
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
          height: 173,
          // constraints: const BoxConstraints(minHeight: 173),
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
                          'dust',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 6),
                        HeyText.bodySemiBold(
                          'dust'.tr,
                          fontSize: kFont16,
                          color: kTextDisabledColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Row(
                        children: [
                          // 미세먼지
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    HeyText.bodySemiBold(
                                      'dust_fine'.tr,
                                      fontSize: kFont15,
                                      color: kTextDisabledColor,
                                    ),
                                    const SizedBox(width: 8),
                                    HeyText.bodySemiBold(
                                      fineState,
                                      fontSize: kFont15,
                                      color: stateColors[fineState] ?? kTextPointColor,
                                    ),
                                  ],
                                ),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    HeyText.largeTitleBold(
                                      widget.fine.toString(),
                                      color: kTextPointColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: HeyText.bodySemiBold(
                                        '㎍/m³',
                                        fontSize: kFont20,
                                        color: kIconColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            color: kButtonColor,
                          ),
                          // 초미세먼지
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      HeyText.bodySemiBold(
                                        'dust_ultra'.tr,
                                        fontSize: kFont15,
                                        color: kTextDisabledColor,
                                      ),
                                      const SizedBox(width: 8),
                                      HeyText.bodySemiBold(
                                        ultraState,
                                        fontSize: kFont15,
                                        color: stateColors[ultraState] ?? kTextPointColor,
                                      ),
                                    ],
                                  ),
                      
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      HeyText.largeTitleBold(
                                        widget.ultra.toString(),
                                        color: kTextPointColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 4),
                                        child: HeyText.bodySemiBold(
                                          '㎍/m³',
                                          fontSize: kFont20,
                                          color: kIconColor,
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
                    )
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
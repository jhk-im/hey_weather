import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';

class HeyWeatherDustCard extends StatefulWidget {
  const HeyWeatherDustCard({
    super.key,
    required this.fine,
    required this.fineState,
    required this.ultra,
    required this.ultraState,
    this.buttonStatus = 0,
    this.setHeight,
    this.onSelect,
    this.onRemove,
  });

  final String fine;
  final String fineState;
  final String ultra;
  final String ultraState;
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
    'none'.tr : kIconColor,
    'low'.tr : kPrimaryDarkerColor,
    'good'.tr : kPrimaryDarkerColor,
    'weak'.tr : kPrimaryDarkerColor,
    'high'.tr : kSubColor,
    'normal'.tr : kHeyGreenColor,
    'bad'.tr : kHeyOrangeColor,
    'very_high'.tr: kHeyOrangeColor,
    'strong'.tr: kHeyRedColor,
    'danger'.tr: kHeyRedColor,
    'very_bad'.tr: kHeyRedColor,
    'very_good'.tr: kHeySkyBlueColor,
  };

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width) - 28;
    double height = 173;
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
                                      widget.fineState,
                                      fontSize: kFont15,
                                      color: stateColors[widget.fineState] ?? kTextPointColor,
                                    ),
                                  ],
                                ),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    HeyText.largeTitleBold(
                                      widget.fine,
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
                                        widget.ultraState,
                                        fontSize: kFont15,
                                        color: stateColors[widget.ultraState] ?? kTextPointColor,
                                      ),
                                    ],
                                  ),
                      
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      HeyText.largeTitleBold(
                                        widget.ultra,
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
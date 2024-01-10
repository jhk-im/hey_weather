import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/image_utils.dart';

class HeyWeatherSmallCard extends StatefulWidget {
  const HeyWeatherSmallCard({
    super.key,
    required this.title,
    required this.iconName,
    this.subtitle = '',
    this.state = '',
    this.secondState = '',
  });

  final String title;
  final String iconName;
  final String subtitle;
  final String state;
  final String secondState;

  @override
  State<HeyWeatherSmallCard> createState() => _HeyWeatherSmallCardState();
}

class _HeyWeatherSmallCardState extends State<HeyWeatherSmallCard> {
  final status = 0.obs; // 0 -> default, 1 -> edit, 2 -> select

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

  // Colors
  final Map<String, String> stateUnits = {
    'humidity'.tr : '%',
    'wind'.tr : 'm/s',
    'rain'.tr : 'mm',
    'fine_dust'.tr : '㎍/m³',
    'ultra_fine_dust'.tr : '㎍/m³',
    'wind_chill'.tr: '˚',
  };

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width / 2) - 22;

    // humidity
    int today = 0;
    int yesterday = 0;
    int diff = 0;
    bool isUp = false;
    if (widget.title == 'humidity'.tr) {
      today = int.parse(widget.state);
      yesterday = int.parse(widget.secondState);
      if (today > yesterday) {
        isUp = true;
        diff = today - yesterday;
      } else {
        diff = yesterday - today;
      }
    }

    // ultraviolet
    int ultraviolet = 0;
    if (widget.title == 'ultraviolet'.tr) {
      ultraviolet = int.parse(widget.state);
    }

    return Obx(() => GestureDetector(
      onTap: () {
        if (status.value == 2) {
          status.value = 0;
        } else {
          status.value += 1;
        }
      },
      child: Container(
        width: width,
        height: width,
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
                  // 체감온도
                  if (widget.title == 'wind_chill'.tr) ... {
                    // icon, title
                    Row(
                      children: [
                        ImageUtils.icon(
                          context,
                          widget.iconName,
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 6),
                        HeyText.bodySemiBold(
                          widget.title,
                          fontSize: kFont16,
                          color: kTextDisabledColor,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Row(
                          children: [
                            HeyText.bodySemiBold(
                              'highest'.tr,
                              color: kTextPointColor,
                            ),
                            ImageUtils.icon(
                              context,
                              'highest',
                              width: 24,
                              height: 24,
                            ),
                            HeyText.largeTitleBold(
                              '${widget.state.split(" ").first}${stateUnits[widget.title]}',
                              color: kTextPointColor,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            HeyText.bodySemiBold(
                              'lowest'.tr,
                              color: kTextPointColor,
                            ),
                            ImageUtils.icon(
                              context,
                              'lowest',
                              width: 24,
                              height: 24,
                            ),
                            HeyText.largeTitleBold(
                              '${widget.state.split(" ").last}${stateUnits[widget.title]}',
                              color: kTextPointColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  }
                  else ... {
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
                                ImageUtils.icon(
                                  context,
                                  widget.iconName,
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(width: 6),
                                HeyText.bodySemiBold(
                                  widget.title,
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
                                widget.subtitle,
                                color: stateColors[widget.subtitle] ?? kTextPointColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                                  widget.state,
                                  color: kTextPointColor,
                                ),
                                const SizedBox(width: 4),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: HeyText.bodySemiBold(
                                    stateUnits[widget.title] ?? '',
                                    color: kTextDisabledColor,
                                    fontSize: kFont20,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),

                            // 습도
                            if (widget.title == 'humidity'.tr) ... {
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
                                    ImageUtils.icon(
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
                            }
                            // 바람
                            else if (widget.title == 'wind'.tr) ... {
                              Row(
                                children: [
                                  HeyText.footnote(
                                    widget.secondState,
                                    color: kTextDisabledColor,
                                  ),
                                  const SizedBox(width: 4),
                                  ImageUtils.icon(
                                    context,
                                    'direction',
                                    width: 10,
                                    height: 10,
                                  ),
                                ],
                              ),
                            }
                            // 강수
                            else if (widget.title == 'rain'.tr) ... {
                                Row(
                                  children: [
                                    HeyText.footnote(
                                      widget.secondState.isNotEmpty
                                          ? '${widget.secondState} ${'within'.tr}'
                                          : 'no_forecast'.tr,
                                      color: widget.secondState.isNotEmpty ? kPrimaryDarkerColor : kIconColor,
                                    ),
                                    const SizedBox(width: 4),
                                    ImageUtils.icon(
                                      context,
                                      'direction',
                                      width: 10,
                                      height: 10,
                                      color: widget.secondState.isNotEmpty ? kPrimaryDarkerColor : kIconColor,
                                    ),
                                  ],
                                ),
                            }
                            // 자외선
                            else if (widget.title == 'ultraviolet'.tr) ... {
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
                                    left: (ultraviolet / 82) * (width - 50),
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
                              )
                            }
                            else ... {
                              LinearProgressIndicator(
                                borderRadius: BorderRadius.circular(10.0),
                                backgroundColor: kProgressBackgroundColor,
                                minHeight: 8,
                                valueColor: AlwaysStoppedAnimation<Color>(stateColors[widget.subtitle] ?? kPrimaryDarkerColor),
                                value: 0.8,
                              ),
                            },
                          ],
                        ),
                      ),
                    ),
                  },
                ],
              ),
            ),

            Visibility(
              visible: status.value > 0,
              child: Container(
                color: status.value == 1 ? Colors.transparent : kBaseColor.withOpacity(0.5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        ImageUtils.icon(
                          context,
                          status.value == 1
                              ? 'circle_check'
                              : 'circle_check_selected',
                          width: 24,
                          height: 24,
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
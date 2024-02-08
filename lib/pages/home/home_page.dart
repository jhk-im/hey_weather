import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';
import 'package:hey_weather/getx/routes.dart';
import 'package:hey_weather/pages/home/home_controller.dart';
import 'package:hey_weather/widgets/buttons/hey_elevated_button.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_week_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_dust_card.dart';
import 'package:hey_weather/widgets/cards/hey_weather_home_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_time_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_sun_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_small_card.dart';
import 'package:hey_weather/widgets/loading_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reorderables/reorderables.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double emptyHeight = (MediaQuery.of(context).size.height) - 157;
    return Scaffold(
      body: Obx(() => Stack(
        children: [
          Column(
            children: [
              // StatusBar
              SizedBox(height: statusBarHeight),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                child: Row(
                  children: [
                    InkWell(
                      splashColor: kBaseColor,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {
                        /*HeyBottomSheet.showSelectAddressBottomSheet(
                          context,
                          addressList: controller.recentAddressList,
                          currentAddress: controller.currentAddress,
                          onSelectedAddress: (addressId) {
                            controller.logger.d('onSelectedAddress: (addressId) -> $addressId / currentAddress -> ${controller.currentAddress}');
                            if (addressId != controller.currentAddress) {
                              controller.resetData(addressId);
                            }
                          },
                          onMoveToAddress: controller.moveToAddress,
                        );*/
                        controller.moveToAddress();
                      },
                      child: Row(
                        children: [
                          SvgUtils.icon(
                            context,
                            controller.currentAddress == kCurrentLocationId ? 'location_target' : 'location',
                          ),
                          const SizedBox(width: 6),
                          HeyText.body(controller.addressText, color: kTextSecondaryColor),
                        ],
                      ),
                    ),
                    const Spacer(),
                    /*InkWell(
                      splashColor: kBaseColor,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: controller.moveToAddress,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: SvgUtils.icon(context, 'map'),
                      ),
                    ),*/
                    InkWell(
                      splashColor: kBaseColor,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {
                        Get.toNamed(Routes.routeSetting);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: SvgUtils.icon(context, 'setting'),
                      ),
                    ),
                  ],
                ),
              ),

              // MY, ALL, 편집
              _tab(context, controller.scrollY > 395),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      // Location Permission
                      if (!controller.isLocationPermission) ... {
                        Container(
                          margin: const EdgeInsets.only(top: 12, left: 20, right: 20),
                          child: InkWell(
                            splashColor: kBaseColor,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onTap: openAppSettings,
                            child: Container(
                              padding: const EdgeInsets.only(left: 20, top: 12, bottom: 12, right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: kBaseColor,
                              ),
                              width: double.maxFinite,
                              child: Row(
                                children: [
                                  HeyText.footnote('location_permission_message'.tr),
                                  const Spacer(),
                                  SvgUtils.icon(context, 'arrow_right'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      },

                      // Today Card
                      Container(
                        margin: const EdgeInsets.only(top: 12, left: 20, right: 20),
                        child: const HeyWeatherHomeCard(
                          weatherStatus: '구름 조금',
                          temperature: '19',
                          message1: '어제보다 1℃ 낮아요',
                          message2: '저녁 6시에 비 올 확률이 80%예요',
                          message3: '미세먼지가 없고 하늘이 깨끗해요',
                        ),
                      ),

                      // Contents
                      Container(
                        margin: const EdgeInsets.only(top: 25),
                        color: kHomeBottomColor,
                        child: Column(
                          children: [
                            // MY, ALL, 편집
                            _tab(context, controller.scrollY < 395),
                            if (!controller.isAllTab) ... {
                              if (controller.myWeatherList.isEmpty) ... {
                                // Empty
                                Container(
                                  width: double.maxFinite,
                                  height: emptyHeight,
                                  color: kHomeBottomColor,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 50),
                                        HeyElevatedButton.secondaryIcon2(
                                          context,
                                          width: 58,
                                          onPressed: () {

                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        HeyText.subHeadline(
                                          'home_add_desc'.tr,
                                          color: kTextDisabledColor,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              } else ... {
                                // My
                                ReorderableWrap(
                                  spacing: 15,
                                  runSpacing: 15,
                                  padding: const EdgeInsets.only(top: 16, bottom: 24, left: 20, right: 20),
                                  scrollPhysics: const NeverScrollableScrollPhysics(),
                                  enableReorder: controller.isEditMode,
                                  controller: controller.myScrollController,
                                  buildDraggableFeedback: (context, constraints, widget) {
                                    return widget;
                                  },
                                  onReorder: (oldIndex, newIndex) {
                                    if (oldIndex < newIndex) {
                                      newIndex -= 1;
                                    }
                                    final item = controller.myWeatherList.removeAt(oldIndex);
                                    controller.myWeatherList.insert(newIndex, item);
                                  },
                                  children: List.generate(controller.myWeatherList.length, (index) {
                                    return _myWeatherWidgets(
                                      controller.myWeatherList[index],
                                      controller.isEditMode ? 3 : 0,
                                      onTap: (id, status) {
                                        print('id: $id, status: $status');
                                        controller.myWeatherList.remove(id);
                                      },
                                    );
                                  }),
                                ),
                              },
                            } else ... {
                              // ALL
                              _allWeatherWidgets(),
                            },
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.only(top: statusBarHeight),
            child: LoadingWidget(controller.isLoading),
          ),
        ],
      )),
    );
  }

  Widget _tab(BuildContext context, bool isVisible) {
    return Visibility(
      visible: isVisible,
      child: Container(
        width: double.maxFinite,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: kHomeBottomColor,
          border: Border(
            top: BorderSide(
              color:   kButtonColor,
              width:1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 24, bottom: 12, right: 20),
          child: controller.isEditMode ? Row(
            children: [
              const SizedBox(width: 10),
              HeyElevatedButton.secondaryIcon2(
                context,
                width: 58,
                onPressed: () {

                },
              ),
              const Spacer(),
              HeyElevatedButton.secondaryText2(
                text: 'done'.tr,
                onPressed: () {
                  controller.editToggle(false);
                },
              ),
            ],
          ) : Row(
            children: [
              InkWell(
                onTap: () {
                  controller.tabToggle(false);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: HeyText.title3Bold(
                    'home_tab_1'.tr,
                    color: !controller.isAllTab ? kTextDisabledColor : kButtonColor,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  controller.tabToggle(true);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: HeyText.title3Bold(
                    'home_tab_2'.tr,
                    color: controller.isAllTab ? kTextDisabledColor : kButtonColor,
                  ),
                ),
              ),

              if (controller.myWeatherList.isEmpty || controller.isAllTab) ... {
                const SizedBox(height: 48),
              } else ... {
                const Spacer(),
                HeyElevatedButton.secondaryText2(
                  text: 'edit'.tr,
                  onPressed: () {
                    controller.editToggle(true);
                  },
                ),
              },
            ],
          ),
        ),
      ),
    );
  }

  Widget _myWeatherWidgets(String id, int buttonStatus, {required Function onTap}) {
    switch (id) {
      case kWeatherCardTime:
        return HeyWeatherTimeCard(
          buttonStatus: buttonStatus,
          onTap: (id, status) {
            onTap.call(id, status);
          },
        );
      case kWeatherCardWeek:
        return HeyWeatherWeekCard(
          buttonStatus: buttonStatus,
          onTap: (id, status) {
            onTap.call(id, status);
          },
        );
      case kWeatherCardDust:
        return HeyWeatherDustCard(
          fine: '13',
          fineState: '최고 좋음',
          ultra: '10',
          ultraState: '좋음',
          buttonStatus: buttonStatus,
          onTap: (id, status) {
            onTap.call(id, status);
          },
        );
      case kWeatherCardRain:
        return HeyWeatherSmallCard(
          id: id,
          title: 'rain'.tr,
          iconName: 'rain',
          subtitle: '없음',
          weatherState: '0',
          buttonStatus: buttonStatus,
          onTap: (id, status) {
            onTap.call(id, status);
          },
        );
      case kWeatherCardHumidity:
        return HeyWeatherSmallCard(
          id: id,
          title: 'humidity'.tr,
          iconName: 'humidity',
          subtitle: '낮음',
          weatherState: '16',
          secondWeatherState: '17',
          buttonStatus: buttonStatus,
          onTap: (id, status) {
            onTap.call(id, status);
          },
        );
      case kWeatherCardWind:
        return HeyWeatherSmallCard(
          id: id,
          title: 'wind'.tr,
          iconName: 'wind',
          subtitle: '없음',
          weatherState:'3',
          secondWeatherState: '북동',
          buttonStatus: buttonStatus,
          onTap: (id, status) {
            onTap.call(id, status);
          },
        );
      case kWeatherCardSun:
        return HeyWeatherSunCard(
          sunrise: '7시 34분',
          sunset: '5시 34분',
          buttonStatus: buttonStatus,
          onTap: (id, status) {
            onTap.call(id, status);
          },
        );
      default :
        return HeyWeatherSmallCard(
          id: id,
          title: 'ultraviolet'.tr,
          iconName: 'ultraviolet',
          subtitle: '낮음',
          weatherState: '3',
          secondWeatherState: '3',
          buttonStatus: buttonStatus,
          onTap: (id, status) {
            onTap.call(id, status);
          },
        );
    }
  }

  Widget _allWeatherWidgets() {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 24, left: 20, right: 20),
      color: kHomeBottomColor,
      child: Center(
        child: Wrap(
          spacing: 15,
          runSpacing: 15,
          children: [
            // 시간대별 날씨
            HeyWeatherTimeCard(
              onTap: (id, status) {},
            ),
            // 주간 날씨
            HeyWeatherWeekCard(
              onTap: (id, status) {},
            ),
            // 대기질
            HeyWeatherDustCard(
              fine: '13',
              fineState: '최고 좋음',
              ultra: '10',
              ultraState: '좋음',
              onTap: (id, status) {},
            ),
            // 강수
            HeyWeatherSmallCard(
              id: kWeatherCardRain,
              title: 'rain'.tr,
              iconName: 'rain',
              subtitle: '없음',
              weatherState: '0',
              onTap: (id, status) {},
            ),
            // 습도
            HeyWeatherSmallCard(
              id: kWeatherCardHumidity,
              title: 'humidity'.tr,
              iconName: 'humidity',
              subtitle: '낮음',
              weatherState: '16',
              secondWeatherState: '17',
              onTap: (id, status) {},
            ),
            // 체감온도
            HeyWeatherSmallCard(
              id: kWeatherCardFeel,
              title: 'feel_temp'.tr,
              iconName: 'feel_temp',
              weatherState: '30 28',
              onTap: (id, status) {},
            ),
            // 바람
            HeyWeatherSmallCard(
              id: kWeatherCardWind,
              title: 'wind'.tr,
              iconName: 'wind',
              subtitle: '없음',
              weatherState:'3',
              secondWeatherState: '북동',
              onTap: (id, status) {},
            ),
            // 일출 일몰
            HeyWeatherSunCard(
              sunrise: '7시 34분',
              sunset: '5시 34분',
              onTap: (id, status) {},
            ),
            // 자외선
            HeyWeatherSmallCard(
              id: kWeatherCardUltraviolet,
              title: 'ultraviolet'.tr,
              iconName: 'ultraviolet',
              subtitle: '낮음',
              weatherState: '3',
              secondWeatherState: '3',
              onTap: (id, status) {},
            ),
          ],
        ),
      ),
    );
  }
}
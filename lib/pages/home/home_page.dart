import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_dialog.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';
import 'package:hey_weather/getx/routes.dart';
import 'package:hey_weather/pages/home/home_controller.dart';
import 'package:hey_weather/widgets/buttons/hey_elevated_button.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_humidity_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_rain_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_ultraviolet_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_week_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_dust_card.dart';
import 'package:hey_weather/widgets/cards/hey_weather_home_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_time_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_sun_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_chill_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_wind_card.dart';
import 'package:hey_weather/widgets/loading_widget.dart';
import 'package:hey_weather/widgets/reorder/hey_reorder_wrap.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double emptyHeight = (MediaQuery.of(context).size.height) - 72;
    return Scaffold(
      body: Obx(() => RefreshIndicator(
        color: Colors.white,
        backgroundColor: kPrimaryDarkerColor,
        onRefresh: () async {
          await controller.getData();
        },
        child: Stack(
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
                              controller.currentAddressId == kCurrentLocationId ? 'location_target' : 'location',
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
                        onTap: () async {
                          bool update = await Get.toNamed(Routes.routeSetting);
                          if (update) {
                            controller.getData();
                          }
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
                          child: HeyWeatherHomeCard(
                            weatherStatus: controller.homeWeatherStatus,
                            temperature: controller.ultraShortTemperature,
                            yesterdayTemperature: controller.yesterdayTemperature,
                            iconName: controller.homeWeatherIconName,
                            rain: controller.ultraShortRain,
                            rainStatus: controller.ultraShortRainStatus,
                            rainTime: controller.homeRainTime,
                            rainPercent: controller.homeRainPercent,
                            fineDust: controller.fineDust,
                            ultraFineDust: controller.ultraFineDust,
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
                                            onPressed: controller.showAddWeather,
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
                                  HeyReorderWrap(
                                    spacing: 15,
                                    runSpacing: 15,
                                    padding: const EdgeInsets.only(top: 16, bottom: 24, left: 20, right: 20),
                                    scrollPhysics: const NeverScrollableScrollPhysics(),
                                    scrollAnimationDuration: const Duration(milliseconds: 150),
                                    reorderAnimationDuration: const Duration(milliseconds: 250),
                                    enableReorder: controller.isEditMode,
                                    buildDraggableFeedback: (context, constraints, widget) {
                                      controller.updateScroll();
                                      return widget;
                                    },
                                    onReorder: (oldIndex, newIndex) {
                                      final item = controller.myWeatherList.removeAt(oldIndex);
                                      if (controller.myWeatherList.length - 1 >= newIndex) {
                                        controller.myWeatherList.insert(newIndex, item);
                                      } else {
                                        controller.myWeatherList.add(item);
                                      }
                                      controller.updateUserMyWeather(controller.myWeatherList);
                                    },
                                    onReorderStarted: (index) {
                                      controller.setSelectIndex(index, controller.myWeatherList[index]);
                                    },
                                    onUpdateReorder: (moveIndex) {
                                      if (moveIndex != controller.currentIndex) {
                                        final scrollPosition = controller.scrollController.position.pixels;
                                        var toScroll = 396.0;
                                        if (controller.currentIndex > moveIndex) {
                                          toScroll = scrollPosition - controller.selectHeight;
                                        } else {
                                          toScroll = scrollPosition + controller.selectHeight;
                                        }
                                        controller.setCurrentIndex(moveIndex);
                                        if (toScroll < 396) toScroll = 396;
                                        controller.updateScroll(isUpdate: true, toScroll: toScroll);
                                      }
                                    },
                                    children: List.generate(controller.myWeatherList.length, (index) {
                                      Map<String, String> weatherNameMap = {
                                        kWeatherCardTime: '시간대별 날씨',
                                        kWeatherCardWeek: '주간 날씨',
                                        kWeatherCardDust: '대기질',
                                        kWeatherCardRain: '강수',
                                        kWeatherCardHumidity: '습도',
                                        kWeatherCardFeel: '체감온도',
                                        kWeatherCardWind: '바람',
                                        kWeatherCardSun: '일출일몰',
                                        kWeatherCardUltraviolet: '자외',
                                      };
                                      return _myWeatherWidgets(
                                        controller.myWeatherList[index],
                                        controller.isEditMode ? 3 : 0,
                                        onRemove: (id) {
                                          if (Get.context != null) {
                                            HeyDialog.showCommonDialog(
                                              Get.context!,
                                              title: 'dialog_delete_weather_title'.trParams({'name' : weatherNameMap[id] ?? ''}),
                                              subtitle: 'dialog_delete_weather_subtitle'.tr,
                                              onOk: () {
                                                Get.back();
                                                controller.myWeatherList.remove(id);
                                                controller.updateUserMyWeather(controller.myWeatherList);
                                              },
                                            );
                                          }
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
        ),
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
              if (controller.myWeatherList.length < 9) ... {
                const SizedBox(width: 10),
                HeyElevatedButton.secondaryIcon2(
                  context,
                  width: 58,
                  onPressed: controller.showAddWeather,
                ),
              },
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

  Widget _myWeatherWidgets(String id, int buttonStatus, {required Function onRemove}) {
    switch (id) {
      case kWeatherCardTime:
        return HeyWeatherTimeCard(
          temperatureList: controller.temperatureList,
          skyStatusList: controller.skyStatusList,
          rainStatusList: controller.rainStatusList,
          rainPercentList: controller.rainPercentList,
          sunset: controller.sunsetTime,
          sunrise: controller.sunriseTime,
          currentTemperature: controller.ultraShortTemperature,
          buttonStatus: buttonStatus,
          setHeight: (id, height) {
            controller.weatherHeightMap[id] = height;
          },
          onRemove: (id) {
            onRemove(id);
          },
        );
      case kWeatherCardWeek:
        return HeyWeatherWeekCard(
          midTermLand: controller.midTermLand,
          midTermTemperature: controller.midTermTemperature,
          buttonStatus: buttonStatus,
          setHeight: (id, height) {
            controller.weatherHeightMap[id] = height;
          },
          onRemove: (id) {
            onRemove(id);
          },
        );
      case kWeatherCardDust:
        return HeyWeatherDustCard(
          fine: controller.fineDust,
          ultra: controller.ultraFineDust,
          buttonStatus: buttonStatus,
          setHeight: (id, height) {
            controller.weatherHeightMap[id] = height;
          },
          onRemove: (id) {
            onRemove(id);
          },
        );
      case kWeatherCardRain:
        return HeyWeatherRainCard(
          rain: controller.ultraShortRain,
          rainStatus: controller.ultraShortRainStatus,
          percentage: controller.rainPercentage,
          buttonStatus: buttonStatus,
          setHeight: (id, height) {
            controller.weatherHeightMap[id] = height;
          },
          onRemove: (id) {
            onRemove(id);
          },
        );
      case kWeatherCardHumidity:
        return HeyWeatherHumidityCard(
          today: controller.ultraShortHumidity,
          setHeight: (id, height) {
            controller.weatherHeightMap[id] = height;
          },
          buttonStatus: buttonStatus,
          onRemove: (id) {
            onRemove(id);
          },
        );
      case kWeatherCardFeel:
        return HeyWeatherFeelCard(
          max: controller.apparentTemperatureMax,
          min: controller.apparentTemperatureMin,
          buttonStatus: buttonStatus,
          setHeight: (id, height) {
            controller.weatherHeightMap[id] = height;
          },
          onRemove: (id) {
            onRemove(id);
          },
        );
      case kWeatherCardWind:
        return HeyWeatherWindCard(
          speed: controller.ultraShortWindSpeed,
          direction: controller.ultraShortWindDirection,
          buttonStatus: buttonStatus,
          setHeight: (id, height) {
            controller.weatherHeightMap[id] = height;
          },
          onRemove: (id) {
            onRemove(id);
          },
        );
      case kWeatherCardSun:
        return HeyWeatherSunCard(
          sunrise: controller.sunrise,
          sunset: controller.sunset,
          buttonStatus: buttonStatus,
          setHeight: (id, height) {
            controller.weatherHeightMap[id] = height;
          },
          onRemove: (id) {
            onRemove(id);
          },
        );
      default :
        return HeyWeatherUltravioletCard(
          ultraviolet: controller.ultraviolet,
          buttonStatus: buttonStatus,
          setHeight: (id, height) {
            controller.weatherHeightMap[id] = height;
          },
          onRemove: (id) {
            onRemove(id);
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
              temperatureList: controller.temperatureList,
              skyStatusList: controller.skyStatusList,
              rainStatusList: controller.rainStatusList,
              rainPercentList: controller.rainPercentList,
              sunset: controller.sunsetTime,
              sunrise: controller.sunriseTime,
              currentTemperature: controller.ultraShortTemperature,
            ),
            // 주간 날씨
            HeyWeatherWeekCard(
              midTermLand: controller.midTermLand,
              midTermTemperature: controller.midTermTemperature,
            ),
            // 대기질
            HeyWeatherDustCard(
              fine: controller.fineDust,
              ultra: controller.ultraFineDust,
            ),
            // 강수
            HeyWeatherRainCard(
              rain: controller.ultraShortRain,
              rainStatus: controller.ultraShortRainStatus,
              percentage: controller.rainPercentage,
            ),
            // 습도
            HeyWeatherHumidityCard(
              today: controller.ultraShortHumidity,
            ),
            // 체감온도
            HeyWeatherFeelCard(
              max: controller.apparentTemperatureMax,
              min: controller.apparentTemperatureMin,
            ),
            // 바람
            HeyWeatherWindCard(
              speed: controller.ultraShortWindSpeed,
              direction: controller.ultraShortWindDirection,
            ),
            // 일출 일몰
            HeyWeatherSunCard(
              sunrise: controller.sunrise,
              sunset: controller.sunset,
            ),
            HeyWeatherUltravioletCard(
              ultraviolet: controller.ultraviolet,
            )
          ],
        ),
      ),
    );
  }
}
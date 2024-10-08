import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
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
    double emptyHeight = (MediaQuery.of(context).size.height) - 176;

    /*FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(notification.title ?? 'No title'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(notification.body ?? 'No body'),
                  ],
                ),
              ),
            );
          },
        );
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(notification.title ?? 'No title'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(notification.body ?? 'No body'),
                  ],
                ),
              ),
            );
          },
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(notification.title ?? 'No title'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(notification.body ?? 'No body'),
                  ],
                ),
              ),
            );
          },
        );
      }
    });*/

    return Scaffold(
      body: RefreshIndicator(
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
                Obx(() => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 20),
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
                                  controller.currentAddressId ==
                                          kCurrentLocationId
                                      ? 'location_target'
                                      : 'location',
                                ),
                                const SizedBox(width: 6),
                                HeyText.bodySemiBold(controller.addressText,
                                    color: kTextSecondaryColor),
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
                              bool update =
                                  await Get.toNamed(Routes.routeSetting);
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
                    )),

                // MY, ALL, 편집
                Obx(() => _tab(context, controller.scrollY > 395)),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    controller: controller.scrollController,
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        // Location Permission
                        Obx(() => Visibility(
                              visible: !controller.isLocationPermission,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: 12, left: 20, right: 20),
                                child: InkWell(
                                  splashColor: kBaseColor,
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  onTap: openAppSettings,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 20,
                                        top: 12,
                                        bottom: 12,
                                        right: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: kBaseColor,
                                    ),
                                    width: double.maxFinite,
                                    child: Row(
                                      children: [
                                        HeyText.footnote(
                                            'location_permission_message'.tr),
                                        const Spacer(),
                                        SvgUtils.icon(context, 'arrow_right'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )),

                        // Today Card
                        Obx(() => Container(
                              margin: const EdgeInsets.only(
                                  top: 12, left: 20, right: 20),
                              child: HeyWeatherHomeCard(
                                homeWeatherStatusText:
                                    controller.homeWeatherStatusText,
                                homeWeatherIconName:
                                    controller.homeWeatherIconName,
                                homeTemperature: controller.homeTemperature,
                                homeYesterdayTemperature:
                                    controller.homeYesterdayTemperature,
                                homeRain: controller.homeRain.round(),
                                homeRainTimeText: controller.homeRainTimeText,
                                homeRainPercent: controller.homeRainPercent,
                                homeFineDust: controller.fineDust,
                                homeUltraFineDust: controller.ultraFineDust,
                                isSkeleton: controller.isSkeleton,
                              ),
                            )),

                        // Contents
                        Container(
                          margin: const EdgeInsets.only(top: 25),
                          color: kHomeBottomColor,
                          //height: controller.myWeatherList.length < 2 ? 395 : null,
                          child: Column(
                            children: [
                              // MY, ALL, 편집
                              Obx(() =>
                                  _tab(context, controller.scrollY < 395)),
                              // Empty
                              Obx(() => Visibility(
                                    visible: !controller.isAllTab &&
                                        controller.myWeatherList.length < 2,
                                    child: Container(
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
                                              onPressed:
                                                  controller.showAddWeather,
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
                                  )),
                              // My
                              Obx(() => Visibility(
                                    visible: !controller.isAllTab &&
                                        controller.myWeatherList.length >= 2,
                                    child: HeyReorderWrap(
                                      spacing: 15,
                                      runSpacing: 15,
                                      padding: const EdgeInsets.only(
                                          top: 16,
                                          bottom: 24,
                                          left: 20,
                                          right: 20),
                                      scrollPhysics:
                                          const NeverScrollableScrollPhysics(),
                                      scrollAnimationDuration:
                                          const Duration(milliseconds: 100),
                                      reorderAnimationDuration:
                                          const Duration(milliseconds: 100),
                                      enableReorder: controller.isEditMode,
                                      buildDraggableFeedback:
                                          (context, constraints, widget) {
                                        controller.updateScroll();
                                        return widget;
                                      },
                                      onReorder: (oldIndex, newIndex) {
                                        final item = controller.myWeatherList
                                            .removeAt(oldIndex);
                                        if (controller.myWeatherList.length -
                                                1 >=
                                            newIndex) {
                                          controller.myWeatherList
                                              .insert(newIndex, item);
                                        } else {
                                          controller.myWeatherList.add(item);
                                        }
                                        controller.updateUserMyWeather(
                                            controller.myWeatherList);
                                      },
                                      onReorderStarted: (index) {
                                        controller.setSelectIndex(index,
                                            controller.myWeatherList[index]);
                                      },
                                      onUpdateReorder: (moveIndex) {
                                        if (moveIndex !=
                                            controller.currentIndex) {
                                          final scrollPosition = controller
                                              .scrollController.position.pixels;
                                          var toScroll = 396.0;
                                          if (controller.currentIndex >
                                              moveIndex) {
                                            toScroll = scrollPosition -
                                                controller.selectHeight;
                                          } else {
                                            toScroll = scrollPosition +
                                                controller.selectHeight;
                                          }
                                          controller.setCurrentIndex(moveIndex);
                                          if (toScroll < 396) toScroll = 396;
                                          controller.updateScroll(
                                              isUpdate: true,
                                              toScroll: toScroll);
                                        }
                                      },
                                      children: List.generate(
                                          controller.myWeatherList.length,
                                          (index) {
                                        Map<String, String> weatherNameMap = {
                                          kWeatherCardTime: '시간대별 날씨',
                                          kWeatherCardWeek: '주간 날씨',
                                          kWeatherCardDust: '대기질',
                                          kWeatherCardRain: '강수',
                                          kWeatherCardHumidity: '습도',
                                          kWeatherCardFeel: '체감온도',
                                          kWeatherCardWind: '바람',
                                          kWeatherCardSun: '일출일몰',
                                          kWeatherCardUltraviolet: '자외선',
                                        };
                                        return _myWeatherWidgets(
                                          controller.myWeatherList[index],
                                          controller.isEditMode ? 3 : 0,
                                          onRemove: (id) {
                                            controller.removeUserMyWeather(
                                              'dialog_delete_weather_title'
                                                  .trParams({
                                                'name': weatherNameMap[id] ?? ''
                                              }),
                                              id,
                                            );
                                          },
                                        );
                                      }),
                                    ),
                                  )),
                              // All
                              Obx(() => Visibility(
                                    visible: controller.isAllTab,
                                    child: _allWeatherWidgets(),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Obx(() => Padding(
                  padding: EdgeInsets.only(top: statusBarHeight),
                  child: LoadingWidget(controller.isLoading),
                )),
          ],
        ),
      ),
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
              color: kButtonColor,
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, top: 24, bottom: 12, right: 20),
          child: controller.isEditMode
              ? Row(
                  children: [
                    const SizedBox(width: 10),
                    Visibility(
                      visible: controller.myWeatherList.length < 10,
                      child: HeyElevatedButton.secondaryIcon2(
                        context,
                        width: 58,
                        onPressed: controller.showAddWeather,
                      ),
                    ),
                    const Spacer(),
                    HeyElevatedButton.secondaryText2(
                      text: 'done'.tr,
                      onPressed: () {
                        controller.editToggle(false);
                      },
                    ),
                  ],
                )
              : Row(
                  children: [
                    InkWell(
                      onTap: () {
                        controller.tabToggle(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: HeyText.title3Bold(
                          'home_tab_1'.tr,
                          color: !controller.isAllTab
                              ? kTextDisabledColor
                              : kButtonColor,
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
                          color: controller.isAllTab
                              ? kTextDisabledColor
                              : kButtonColor,
                        ),
                      ),
                    ),
                    if (controller.myWeatherList.length < 2 ||
                        controller.isAllTab) ...{
                      const SizedBox(height: 48),
                    } else ...{
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

  Widget _myWeatherWidgets(String id, int buttonStatus,
      {required Function onRemove}) {
    switch (id) {
      case kWeatherCardTime:
        return HeyWeatherTimeCard(
          temperatureList: controller.timeTemperatureList,
          skyStatusList: controller.timeSkyStatusList,
          rainStatusList: controller.timeRainStatusList,
          rainPercentList: controller.timeRainPercentList,
          sunset: controller.timeSunset,
          sunrise: controller.timeSunrise,
          currentTemperature: controller.homeTemperature,
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
          midTermLand: controller.weekMidTermLand,
          midTermTemperature: controller.weekMidTermTemperature,
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
          rain: controller.homeRain,
          rainStatus: controller.rainStatusText,
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
          today: controller.homeHumidity,
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
          max: controller.feelTemperatureMax,
          min: controller.feelTemperatureMin,
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
          speed: controller.windSpeed,
          direction: controller.windDirection,
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
      case kWeatherCardUltraviolet:
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
      default:
        return Container();
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
              temperatureList: controller.timeTemperatureList,
              skyStatusList: controller.timeSkyStatusList,
              rainStatusList: controller.timeRainStatusList,
              rainPercentList: controller.timeRainPercentList,
              sunset: controller.timeSunset,
              sunrise: controller.timeSunrise,
              currentTemperature: controller.homeTemperature,
            ),
            // 주간 날씨
            HeyWeatherWeekCard(
              midTermLand: controller.weekMidTermLand,
              midTermTemperature: controller.weekMidTermTemperature,
            ),
            // 대기질
            HeyWeatherDustCard(
              fine: controller.fineDust,
              ultra: controller.ultraFineDust,
            ),
            // 강수
            HeyWeatherRainCard(
              rain: controller.homeRain,
              rainStatus: controller.rainStatusText,
              percentage: controller.rainPercentage,
            ),
            // 습도
            HeyWeatherHumidityCard(
              today: controller.homeHumidity,
            ),
            // 체감온도
            HeyWeatherFeelCard(
              max: controller.feelTemperatureMax,
              min: controller.feelTemperatureMin,
            ),
            // 바람
            HeyWeatherWindCard(
              speed: controller.windSpeed,
              direction: controller.windDirection,
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

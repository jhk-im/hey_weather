import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';
import 'package:hey_weather/pages/address/address_controller.dart';
import 'package:hey_weather/widgets/cards/hey_weather_address_card.dart';
import 'package:hey_weather/widgets/loading_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class AddressPage extends GetView<AddressController> {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                // 헤더, 검색 필드, 아이템 리스트
                Column(
                  children: [
                    // 헤더
                    SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // back
                          GestureDetector(
                            onTap: () {
                              Get.back(result: controller.isUpdated);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 24, bottom: 24, left: 16, right: 24),
                              child: SvgUtils.icon(
                                context,
                                'arrow_left',
                                color: kTextPrimaryColor,
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ),

                          // 타이틀
                          const Spacer(),
                          HeyText.bodySemiBold(
                            'setting_location'.tr,
                            color: kTextPrimaryColor,
                          ),
                          const Spacer(),

                          // 편집
                          Obx(() => Visibility(
                                visible: controller.addressList.isNotEmpty,
                                child: GestureDetector(
                                  onTap: controller.editModeToggle,
                                  child: Container(
                                    width: 72,
                                    padding: const EdgeInsets.only(right: 24),
                                    child: Row(
                                      children: [
                                        const Spacer(),
                                        Obx(() => HeyText.body(
                                              controller.isEditMode
                                                  ? 'done'.tr
                                                  : 'edit'.tr,
                                              color: kTextDisabledColor,
                                              fontSize: kFont18,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              )),

                          Obx(() => Visibility(
                                visible: controller.addressList.isEmpty,
                                child: Container(width: 72),
                              )),
                        ],
                      ),
                    ),

                    // 검색 필드
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 16, bottom: 20),
                      child: TextFormField(
                        focusNode: controller.focusNode,
                        controller: controller.textFieldController,
                        onTapOutside: (event) {
                          if (controller.searchAddressList.isEmpty) {
                            controller.resetTextField();
                          }
                        },
                        style: const TextStyle(
                          color: kTextPointColor,
                          fontFamily: kPretendardMedium,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        onChanged: controller.textFieldListener,
                        decoration: InputDecoration(
                          hintText: 'hint_address_input'.tr,
                          prefixIcon: Container(
                            margin: const EdgeInsets.only(right: 12, left: 16),
                            child: SvgUtils.icon(
                              context,
                              'search',
                              color: kIconColor,
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 현재 위치
                    Obx(() => Visibility(
                          visible: controller.isLocationPermission,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                HeyWeatherAddressCard(
                                  address: controller.currentAddress,
                                  isCurrentLocation: true,
                                  onSelectAddress: controller.selectAddress,
                                ),
                              ],
                            ),
                          ),
                        )),

                    // 현재 위치 - 위치 권한
                    Obx(() => Visibility(
                          visible: !controller.isLocationPermission,
                          child: InkWell(
                            splashColor: kBaseColor,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onTap: openAppSettings,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              padding: const EdgeInsets.only(
                                  left: 20, top: 12, bottom: 12, right: 12),
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
                                  SvgUtils.icon(
                                    context,
                                    'arrow_right',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),

                    // Divider
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: const Divider(color: kButtonColor, height: 1),
                    ),

                    Expanded(
                      child: Obx(() => ReorderableListView(
                            buildDefaultDragHandles: controller.isEditMode,
                            proxyDecorator: (widget, animation, proxy) {
                              return widget;
                            },
                            onReorder: (oldIndex, newIndex) {
                              if (oldIndex < newIndex) {
                                newIndex -= 1;
                              }
                              final item =
                                  controller.addressList.removeAt(oldIndex);
                              controller.addressList.insert(newIndex, item);
                            },
                            children: List.generate(
                              controller.addressList.length,
                              (index) {
                                return Container(
                                  key: ValueKey(controller.addressList[index]),
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, bottom: 20),
                                  child: HeyWeatherAddressCard(
                                    address: controller.addressList[index],
                                    status: controller.editStatus,
                                    onSelectAddress: controller.selectAddress,
                                    onRemoveAddress: controller.removeAddress,
                                  ),
                                );
                              },
                            ),
                          )),
                    ),
                  ],
                ),

                // 검색 리스트
                Obx(() => Visibility(
                      visible: controller.searchAddressList.isNotEmpty,
                      child: Container(
                        width: double.maxFinite,
                        height: 300,
                        color: kElevationColor,
                        margin: const EdgeInsets.only(top: 164),
                        child: ListView.builder(
                          itemCount: controller.searchAddressList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              splashColor: kBaseColor,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              onTap: () {
                                controller.focusNode.unfocus();
                                controller.showCreateAddressBottomSheet(context,
                                    controller.searchAddressList[index]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: EasyRichText(
                                  controller.searchAddressList[index]
                                          .addressName ??
                                      '',
                                  defaultStyle: const TextStyle(
                                    fontFamily: kPretendardSemiBold,
                                    color: kTextPrimaryColor,
                                    fontSize: kFont17,
                                  ),
                                  patternList: [
                                    EasyRichTextPattern(
                                      targetString:
                                          controller.searchAddressText,
                                      matchWordBoundaries: false,
                                      style: const TextStyle(
                                        fontFamily: kPretendardSemiBold,
                                        color: kPrimaryDarkerColor,
                                        fontSize: kFont17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )),

                Obx(() => LoadingWidget(controller.isLoading)),
              ],
            ),
          ),
        );
      },
    );
  }
}

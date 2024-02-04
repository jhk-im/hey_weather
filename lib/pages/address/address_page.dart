import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_bottom_sheet.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';
import 'package:hey_weather/pages/address/address_controller.dart';
import 'package:hey_weather/widgets/cards/hey_weather_address_card.dart';
import 'package:hey_weather/widgets/loading_widget.dart';


class AddressPage extends GetView<AddressController> {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: Obx(() => Stack(
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
                              padding: const EdgeInsets.symmetric(vertical: 23, horizontal: 24),
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
                          HeyText.body(
                            'setting_location'.tr,
                            color: kTextPrimaryColor,
                            fontSize: kFont18,
                          ),
                          const Spacer(),

                          // 편집
                          GestureDetector(
                            onTap: controller.editModeToggle,
                            child: Container(
                              width: 72,
                              padding: const EdgeInsets.only(right: 20),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  HeyText.body(
                                    controller.isEditMode ? 'done'.tr : 'edit'.tr,
                                    color: kTextDisabledColor,
                                    fontSize: kFont18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 검색 필드
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 20),
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
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          HeyWeatherAddressCard(
                            address: controller.currentAddress,
                            weatherStatus: '구름 조금',
                            temperature: '19',
                            isEditMode: controller.isEditMode,
                            isCurrentLocation: true,
                            onSelectAddress: controller.selectAddress,
                          ),
                        ],
                      ),
                    ),

                    // Divider
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: const Divider(color: kButtonColor, height: 1),
                    ),

                    Expanded(
                      child: ReorderableListView(
                        proxyDecorator: (widget, animation, proxy) {
                          return widget;
                        },
                        onReorder: (oldIndex, newIndex) {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final item = controller.addressList.removeAt(oldIndex);
                          controller.addressList.insert(newIndex, item);
                        },
                        children: List.generate(controller.addressList.length, (index) {
                            return Container(
                              key: ValueKey(controller.addressList[index]),
                              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                              child: HeyWeatherAddressCard(
                                address: controller.addressList[index],
                                weatherStatus: '구름 조금',
                                temperature: '19',
                                isEditMode: controller.isEditMode,
                                onSelectAddress: controller.selectAddress,
                                onRemoveAddress: controller.removeAddress,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                  ],
                ),

                // 검색 리스트
                Visibility(
                  visible: controller.searchAddressList.isNotEmpty,
                  child: Container(
                    width: double.maxFinite,
                    height: 300,
                    color: kElevationColor,
                    margin: const EdgeInsets.only(top: 164),
                    child: ListView.builder(
                      itemCount: controller.searchAddressList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            controller.focusNode.unfocus();
                            HeyBottomSheet.showCreateAddressBottomSheet(
                              context,
                              address: controller.searchAddressList[index],
                              searchText: controller.searchAddressText,
                              weatherStatus: '구름 조금',
                              temperature: '19',
                              message1: '어제보다 1℃ 낮아요',
                              message2: '저녁 6시에 비 올 확률이 80%예요',
                              message3: '미세먼지가 없고 하늘이 깨끗해요',
                              onCreateAddress: (address, searchText) {
                                Get.back();
                                controller.createSearchAddress(address, searchText);
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: EasyRichText(
                              controller.searchAddressList[index].addressName ?? '',
                              defaultStyle: const TextStyle(
                                fontFamily: kPretendardSemiBold,
                                color: kTextPrimaryColor,
                                fontSize: kFont17,
                              ),
                              patternList: [
                                EasyRichTextPattern(
                                  targetString: controller.searchAddressText,
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
                ),

                LoadingWidget(controller.isLoading),
              ],
            )),
          ),
        );
      },
    );
  }

}


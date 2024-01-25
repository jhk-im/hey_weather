import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/image_utils.dart';
import 'package:hey_weather/pages/address/address_controller.dart';
import 'package:hey_weather/widgets/loading_widget.dart';


class AddressPage extends GetView<AddressController> {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 23, horizontal: 24),
                          child: ImageUtils.icon(
                            context,
                            'arrow_left',
                            color: kTextPrimaryColor,
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),

                      const Spacer(),
                      HeyText.body(
                        'setting_location'.tr,
                        color: kTextPrimaryColor,
                        fontSize: kFont18,
                      ),
                      const Spacer(),

                      GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                          width: 72,
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            children: [
                              const Spacer(),
                              HeyText.body(
                                'edit'.tr,
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
                        child: ImageUtils.icon(
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
                child: Scrollbar(
                  thickness: 10,
                  radius: const Radius.circular(10),
                  thumbVisibility: true,
                  interactive: true,
                  child: ListView.builder(
                    itemCount: controller.searchAddressList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          print(controller.searchAddressList[index]);
                          controller.selectSearchAddress(controller.searchAddressList[index]);
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
            ),

            LoadingWidget(controller.isLoading),
          ],
        )),
      ),
    );
  }

}


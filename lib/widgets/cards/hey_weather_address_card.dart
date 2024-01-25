import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/image_utils.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';
import 'package:hey_weather/widgets/buttons/hey_custom_button.dart';

class HeyWeatherAddressCard extends StatefulWidget {
  const HeyWeatherAddressCard({
    super.key,
    this.address,
    this.weatherStatus,
    this.temperature,
    this.isLast = false,
  });

  final Address? address;
  final String? weatherStatus;
  final String? temperature;
  final bool isLast;


  @override
  State<HeyWeatherAddressCard> createState() => _HeyWeatherAddressCardState();
}

class _HeyWeatherAddressCardState extends State<HeyWeatherAddressCard> {
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {

      },
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 28),
        decoration: BoxDecoration(
          color: kBaseColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: kBaseColor,
            width: 1, // 외곽선 두께
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 27,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HeyText.footnote(
                    widget.weatherStatus ?? '',
                    color: kTextDisabledColor,
                  ),
                  if (widget.isLast || widget.address?.id == kCurrentAddressId) ... {
                    const Spacer(),
                    HeyCustomButton.tag(
                      paddingVertical: 4,
                      paddingHorizontal: 6,
                      backgroundColor: kButtonColor,
                      text: HeyText.footnoteSemiBold(
                        widget.isLast ? 'recent_added'.tr : 'current_location'.tr,
                        color: kPrimaryDarkerColor,
                      ),
                    ),
                  },
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: HeyText.callOutSemiBold(
                    widget.address?.addressName ?? '',
                    color: kTextPointColor,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: ImageUtils.weatherIcon(
                    context,
                    'cloudy_on',
                    width: 40,
                    height: 40,
                  ),
                ),
                HeyText.bodySemiBold(
                  '${widget.temperature}˚',
                  color: kTextPointColor,
                  fontSize: kFont28,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
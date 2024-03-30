import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/shared_preferences_util.dart';
import 'package:hey_weather/common/svg_utils.dart';
import 'package:hey_weather/common/utils.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';
import 'package:hey_weather/widgets/buttons/hey_custom_button.dart';

class HeyWeatherAddressCard extends StatefulWidget {
  const HeyWeatherAddressCard({
    super.key,
    this.address,
    this.isCurrentLocation = false,
    required this.onSelectAddress,
    this.status = 0,
    this.onRemoveAddress,
  });

  final Address? address;
  final Function onSelectAddress;
  final Function? onRemoveAddress;
  final bool isCurrentLocation;
  final int status;


  @override
  State<HeyWeatherAddressCard> createState() => _HeyWeatherAddressCardState();
}

class _HeyWeatherAddressCardState extends State<HeyWeatherAddressCard> {
  @override
  Widget build(BuildContext context) {
    final isFahrenheit = false.obs;
    isFahrenheit(SharedPreferencesUtil().getBool(kFahrenheit));
    RxInt status = widget.status.obs; // 0 -> none, 1 -> edit start, 2 -> drag, 3 -> edit done

    RxDouble rxWidth;
    if (!widget.isCurrentLocation) {
      switch (status.value) {
        case 1 :
          rxWidth = 0.0.obs;
          Future.delayed(const Duration(milliseconds: 50), () {
            rxWidth(40);
          });
        case 2 : // drag
          rxWidth = 40.0.obs;
        case 3 : // edit done
          rxWidth = 40.0.obs;
          Future.delayed(const Duration(milliseconds: 50), () {
            status(0);
            rxWidth(0);
          });
        default : // none
          rxWidth = 0.0.obs;
      }
    } else {
      rxWidth = 0.0.obs;
    }

    return Row(
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          child: GestureDetector(
            onTap: () {
              widget.onRemoveAddress?.call(widget.address);
            },
            child: Obx(() => Container(
              padding: const EdgeInsets.only(right: 16),
              width: rxWidth.value,
              child: SvgUtils.icon(context, 'circle_minus'),
            )),
          ),
        ),

        Expanded(
          child: GestureDetector(
            onTap: () {
              widget.onSelectAddress(widget.address);
            },
            child: Container(
              padding: const EdgeInsets.only(top: 20, left: 24, bottom: 28),
              decoration: BoxDecoration(
                color: kBaseColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: kBaseColor,
                  width: 1, // 외곽선 두께
                ),
              ),
              child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (status.value == 0) ... {
                    Container(
                      height: 27,
                      margin: const EdgeInsets.only(right: 24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          HeyText.footnote(
                            widget.address?.weatherStatusText ?? '흐림',
                            color: kTextDisabledColor,
                          ),
                          if (widget.address?.isRecent == true || widget.address?.id == kCurrentLocationId) ... {
                            const Spacer(),
                            HeyCustomButton.tag(
                              paddingVertical: 4,
                              paddingHorizontal: 6,
                              backgroundColor: kButtonColor,
                              text: HeyText.footnoteSemiBold(
                                widget.address?.isRecent == true ? 'recent_added'.tr : 'current_location'.tr,
                                color: kPrimaryDarkerColor,
                              ),
                            ),
                          },
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  } else ... {
                    const SizedBox(height: 8),
                  },

                  Row(
                    children: [
                      Expanded(
                        child: HeyText.callOutSemiBold(
                          widget.address?.region2depthName != null
                              ? '${widget.address?.region2depthName} ${widget.address?.region3depthName}'
                              : widget.address?.addressName ?? '',
                          color: kTextPointColor,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: SvgUtils.weatherIcon(
                          context,
                          widget.address?.weatherIconName != null ?
                          '${widget.address?.weatherIconName}_on' : 'cloudy_on',
                          width: 40,
                          height: 40,
                        ),
                      ),
                      HeyText.bodySemiBold(
                        '${isFahrenheit.value ? Utils.celsiusToFahrenheit(double.parse(widget.address?.temperature.toString() ?? '0')) : widget.address?.temperature ?? '0'}°',
                        color: kTextPointColor,
                        fontSize: kFont28,
                      ),
                      if (!widget.isCurrentLocation && status.value > 0) ... {
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: SvgUtils.icon(context, 'drag'),
                        ),
                      } else ... {
                        const SizedBox(width: 24),
                      },
                    ],
                  ),
                ],
              )),
            ),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';
import 'package:hey_weather/widgets/buttons/hey_custom_button.dart';

class HeyWeatherAddressCard extends StatefulWidget {
  const HeyWeatherAddressCard({
    super.key,
    this.address,
    this.weatherStatus,
    this.temperature,
    this.isEditMode = false,
    this.isCurrentLocation = false,
    required this.onSelectAddress,
    this.onRemoveAddress,
  });

  final Address? address;
  final String? weatherStatus;
  final String? temperature;
  final Function onSelectAddress;
  final Function? onRemoveAddress;
  final bool isCurrentLocation;
  final bool isEditMode;

  @override
  State<HeyWeatherAddressCard> createState() => _HeyWeatherAddressCardState();
}

class _HeyWeatherAddressCardState extends State<HeyWeatherAddressCard> {
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        widget.onSelectAddress(widget.address);
      },
      child: Row(
        children: [
          if (!widget.isCurrentLocation && widget.isEditMode) ... {
            GestureDetector(
              onTap: () {
                widget.onRemoveAddress?.call(widget.address);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SvgUtils.icon(context, 'circle_minus'),
              ),
            ),
          },

          Expanded(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.isEditMode) ... {
                    Container(
                      height: 27,
                      margin: const EdgeInsets.only(right: 24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          HeyText.footnote(
                            widget.weatherStatus ?? '',
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
                          widget.address?.addressName ?? '',
                          color: kTextPointColor,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: SvgUtils.weatherIcon(
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

                      if (!widget.isCurrentLocation && widget.isEditMode) ... {
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
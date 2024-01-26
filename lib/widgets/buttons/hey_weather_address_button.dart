import 'package:flutter/material.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';

class HeyWeatherAddressButton extends StatefulWidget {
  const HeyWeatherAddressButton({
    super.key,
    required this.address,
    this.isSelected = false,
    this.onSelectedAddress,
  });

  final Address address;
  final bool isSelected;
  final Function? onSelectedAddress;

  @override
  State<HeyWeatherAddressButton> createState() => _HeyWeatherAddressButtonState();
}

class _HeyWeatherAddressButtonState extends State<HeyWeatherAddressButton> {

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        // isSelected(isSelected.value != true);
        widget.onSelectedAddress?.call(widget.address.id);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30, left: 24, right: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HeyText.bodySemiBold(
              '${widget.address.region1depthName} ${widget.address.region2depthName} ${widget.address.region3depthName}',
              color: widget.isSelected ? kPrimaryDarkerColor : kTextPrimaryColor,
            ),
            const SizedBox(width: 12),
            Visibility(
              visible: widget.isSelected,
              child: SvgUtils.icon(
                context,
                'check_outline',
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
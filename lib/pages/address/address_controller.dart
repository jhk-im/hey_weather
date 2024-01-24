import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/shared_preferences_util.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';
import 'package:hey_weather/repository/soruce/weather_repository.dart';
import 'package:logger/logger.dart';

class AddressController extends GetxController {
  final WeatherRepository _repository = GetIt.I<WeatherRepository>();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxString _addressText = ''.obs;
  String get addressText => _addressText.value;

  final RxString _currentAddress = ''.obs;
  String get currentAddress => _currentAddress.value;

  final RxList<Address> _addressList = <Address>[].obs;
  List<Address> get addressList => _addressList;

  // input field
  TextEditingController textFieldController = TextEditingController();
  final RxString _searchText = ''.obs;
  String get searchText => _searchText.value;

  _textFieldListener() {
    _searchText.value = textFieldController.text;
  }

  var logger = Logger();

  @override
  void onInit() {
    textFieldController.addListener(_textFieldListener);
    super.onInit();
    _getData();
  }

  @override
  void onClose() {
    textFieldController.removeListener(_textFieldListener);
    textFieldController.dispose();
    super.onClose();
  }


  Future _getData() async {
    _isLoading(true);

    var getAddressId = SharedPreferencesUtil().getString(kCurrentAddressId);
    if (getAddressId == null) {
      // 최초 진입
      logger.i('HomeController getData() -> init currentLocation setting');
      _currentAddress(kCurrentAddressId);
      await SharedPreferencesUtil().setString(kCurrentAddressId, kCurrentAddressId);
    } else {
      _currentAddress(getAddressId);
      logger.i('HomeController getData() -> currentLocation = $getAddressId');
    }

    var getAddressList =  await _repository.getAddressList();
    getAddressList.when(success: (addressList) async {
      _addressList(addressList);
    }, error: (Exception e) {
      logger.e(e);
    });

    _isLoading(false);
  }
}
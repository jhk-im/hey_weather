import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/shared_preferences_util.dart';
import 'package:logger/logger.dart';

class SettingMainController extends GetxController with WidgetsBindingObserver {
  // final WeatherRepository _repository = GetIt.I<WeatherRepository>();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxBool _isNotificationPermission = false.obs;
  bool get isNotificationPermission => _isNotificationPermission.value;

  final RxBool _isFahrenheit = false.obs;
  bool get isFahrenheit => _isFahrenheit.value;

  var logger = Logger();

  fahrenheitToggle(bool update) {
    _isFahrenheit(update);
    SharedPreferencesUtil().setBool(kFahrenheit, update);
  }

  updateNotification() {
    _isNotificationPermission(SharedPreferencesUtil().getBool(kNotificationPermission));
  }

  @override
  void onInit() {
    _isNotificationPermission(SharedPreferencesUtil().getBool(kNotificationPermission));
    _isFahrenheit(SharedPreferencesUtil().getBool(kFahrenheit));
    super.onInit();
  }
}
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/shared_preferences_util.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingNotificationController extends GetxController with WidgetsBindingObserver {
  // final WeatherRepository _repository = GetIt.I<WeatherRepository>();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxBool _isNotificationPermission = false.obs;
  bool get isNotificationPermission => _isNotificationPermission.value;

  final RxBool _isEditMode = false.obs;
  bool get isEditMode => _isEditMode.value;

  final RxBool _isUpdated = false.obs;
  bool get isUpdated => _isUpdated.value;

  var logger = Logger();

  var _isOpenAppSettings = false;

  notificationToggle(bool isOn) async {
    _isUpdated(true);
    if (!isOn) {
      _isNotificationPermission(isOn);
      SharedPreferencesUtil().setBool(kNotificationPermission, isOn);
    } else {
      var status = await Permission.notification.status;
      if (status.isGranted) {
        _isNotificationPermission(isOn);
        SharedPreferencesUtil().setBool(kNotificationPermission, isOn);
      } else {
        _isOpenAppSettings = true;
        openAppSettings();
      }
    }
  }

  @override
  void onInit() {
    _isNotificationPermission(SharedPreferencesUtil().getBool(kNotificationPermission));
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (_isOpenAppSettings) {
        _isOpenAppSettings = false;
        _checkNotificationPermission();
      }
    }
  }

  editModeToggle() async {
    _isEditMode(!_isEditMode.value);

    if (!isEditMode) {

    }
  }

  _checkNotificationPermission() async {
    var status = await Permission.notification.status;
    _isNotificationPermission(status.isGranted);
    SharedPreferencesUtil().setBool(kNotificationPermission, status.isGranted);
  }
}
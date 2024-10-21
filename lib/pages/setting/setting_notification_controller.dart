import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_dialog.dart';
import 'package:hey_weather/common/shared_preferences_util.dart';
import 'package:hey_weather/repository/soruce/local/model/user_notification.dart';
import 'package:hey_weather/repository/soruce/weather_repository.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class SettingNotificationController extends GetxController
    with WidgetsBindingObserver {
  final WeatherRepository _repository = GetIt.I<WeatherRepository>();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxBool _isNotificationPermission = false.obs;
  bool get isNotificationPermission => _isNotificationPermission.value;

  final RxBool _isEditMode = false.obs;
  bool get isEditMode => _isEditMode.value;

  final RxBool _isUpdated = false.obs;
  bool get isUpdated => _isUpdated.value;

  final RxList<UserNotification> _notificationList = <UserNotification>[].obs;
  List<UserNotification> get notificationList => _notificationList;

  var logger = Logger();

  var _isOpenAppSettings = false;

  @override
  void onInit() {
    _isNotificationPermission(
        SharedPreferencesUtil().getBool(kNotificationPermission));
    _getNotificationList();
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

  _checkNotificationPermission() async {
    var status = await Permission.notification.status;
    _isNotificationPermission(status.isGranted);
    SharedPreferencesUtil().setBool(kNotificationPermission, status.isGranted);
  }

  /// User Interaction
  notificationPermissionToggle(bool isOn) async {
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

        if (Get.context != null) {
          HeyDialog.showCommonDialog(
            Get.context!,
            title: 'dialog_setting_title'.tr,
            subtitle: 'dialog_setting_subtitle'.tr,
            okText: 'dialog_setting_ok'.tr,
            onOk: openAppSettings,
          );
        }
      }
    }
  }

  notificationToggle(int index, UserNotification notification) async {
    final isOn = notification.isOn ?? false;
    notification.isOn = !isOn;
    await _repository.updateUserNotification(notification);
    notificationList[index] = notification;
  }

  editModeToggle() async {
    _isEditMode(!_isEditMode.value);
  }

  removeNotification(UserNotification notification) async {
    if (Get.context != null) {
      HeyDialog.showCommonDialog(
        Get.context!,
        title: 'setting_notification'.tr,
        subtitle: 'dialog_delete_notification'.tr,
        onOk: () async {
          await _repository.deleteUserNotification(notification.id ?? '');
          _notificationList.remove(notification);
        },
      );
    }
  }

  createNotification(String dateTime) async {
    var checkNotification = notificationList.firstWhereOrNull((element) {
      DateTime dateTime1 = DateTime.parse(element.dateTime ?? '');
      DateTime dateTime2 = DateTime.parse(dateTime);
      int hour1 = dateTime1.hour;
      int hour2 = dateTime2.hour;
      return hour1 == hour2;
    });

    if (checkNotification == null) {
      String uuid = const Uuid().v4();
      final newNotification = UserNotification();
      newNotification.id = uuid;
      newNotification.dateTime = dateTime;
      newNotification.isOn = true;
      await _repository.updateUserNotification(newNotification);
      await _getNotificationList();
    } else {
      _showUpdateDialog();
    }
  }

  updateNotification(
      int index, String updateDateTime, UserNotification notification) async {
    DateTime dateTime1 = DateTime.parse(notification.dateTime ?? '');
    DateTime dateTime2 = DateTime.parse(updateDateTime);
    int hour1 = dateTime1.hour;
    int hour2 = dateTime2.hour;

    if (hour1 == hour2) {
      notification.dateTime = updateDateTime;
      await _repository.updateUserNotification(notification);
      _notificationList[index] = notification;
      _notificationList.sort((a, b) => DateTime.parse(a.dateTime ?? '')
          .compareTo(DateTime.parse(b.dateTime ?? '')));
    } else {
      var checkNotification = notificationList.firstWhereOrNull((element) {
        DateTime dateTime1 = DateTime.parse(element.dateTime ?? '');
        DateTime dateTime2 = DateTime.parse(updateDateTime);
        int hour1 = dateTime1.hour;
        int hour2 = dateTime2.hour;
        return hour1 == hour2;
      });
      if (checkNotification == null) {
        notification.dateTime = updateDateTime;
        await _repository.updateUserNotification(notification);
        _notificationList[index] = notification;
        _notificationList.sort((a, b) => DateTime.parse(a.dateTime ?? '')
            .compareTo(DateTime.parse(b.dateTime ?? '')));
      } else {
        _showUpdateDialog();
      }
    }
  }

  _showUpdateDialog() {
    if (Get.context != null) {
      HeyDialog.showCommonDialog(
        Get.context!,
        title: 'setting_notification'.tr,
        subtitle: 'dialog_notification_subtitle'.tr,
        cancelText: '',
        onOk: () {},
      );
    }
  }

  /// Data
  _getNotificationList() async {
    var getUserNotificationList = await _repository.getUserNotificationList();
    getUserNotificationList.when(
      success: (notificationList) async {
        if (notificationList.isEmpty) {
          DateTime now = DateTime.now();
          DateTime morning7 = DateTime(now.year, now.month, now.day, 7);
          await createNotification(morning7.toString());
          DateTime evening5 = DateTime(now.year, now.month, now.day, 17);
          await createNotification(evening5.toString());
          _getNotificationList();
        } else {
          notificationList.sort((a, b) => DateTime.parse(a.dateTime ?? '')
              .compareTo(DateTime.parse(b.dateTime ?? '')));
          _notificationList(notificationList);
        }
      },
      error: (Exception e) {
        logger.e('SettingNotificationController.getNotificationList $e');
      },
    );
  }
}

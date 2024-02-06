import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/shared_preferences_util.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    // _listenForPermissionStatus();

    Future.delayed(const Duration(seconds: 2), () {
      _requestPermissions();
    });
  }

  _requestPermissions() async {
    await _checkPermissionStatus(Permission.location);
    await _checkPermissionStatus(Permission.notification);
    Get.offAllNamed('/home');
  }

  _checkPermissionStatus(Permission permission) async {
    var status = await permission.status;
    if (status.isDenied) {
      await _requestPermission(permission);
    } else if (status.isPermanentlyDenied) {
      if (permission == Permission.location) {
        SharedPreferencesUtil().setBool(kLocationPermission, false);
      } else if (permission == Permission.notification) {
        SharedPreferencesUtil().setBool(kNotificationPermission, false);
      }
    } else if (status.isGranted) {
      if (permission == Permission.location) {
        SharedPreferencesUtil().setBool(kLocationPermission, true);
      }
    }
  }

  _requestPermission(Permission permission) async {
    var result = await permission.request();
    if (!result.isGranted) {
      if (permission == Permission.location) {
        SharedPreferencesUtil().setBool(kLocationPermission, false);
      } else if (permission == Permission.notification) {
        SharedPreferencesUtil().setBool(kNotificationPermission, false);
      }
    } else {
      if (permission == Permission.location) {
        SharedPreferencesUtil().setBool(kLocationPermission, true);
      }  else if (permission == Permission.notification) {
        SharedPreferencesUtil().setBool(kNotificationPermission, true);
      }
    }
  }
}
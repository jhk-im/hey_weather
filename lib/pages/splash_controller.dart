import 'package:get/get.dart';
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
    await _checkPermissionStatus(Permission.appTrackingTransparency);
    await _checkPermissionStatus(Permission.location, isOpenAppSettings: true);
    await _checkPermissionStatus(Permission.notification);
    Get.offAllNamed('/home');
  }

  _checkPermissionStatus(Permission permission, {isOpenAppSettings = false}) async {
    var status = await permission.status;
    if (status.isDenied) {
      await _requestPermission(permission, isOpenAppSettings: isOpenAppSettings);
    } else if (status.isPermanentlyDenied) {
      if (isOpenAppSettings) {
        openAppSettings();
      }
    }
  }

  _requestPermission(Permission permission, {isOpenAppSettings = false}) async {
    var result = await permission.request();
    if (!result.isGranted) {
      if (isOpenAppSettings) {
        // TODO: 앱 종료 혹은 설정에서 권한 허용하도록 안내 팝업
        // openAppSettings();
      }
    }
  }
}
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/shared_preferences_util.dart';
import 'package:logger/logger.dart';
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ios_utsname_ext/extension.dart';

class SettingMainController extends GetxController with WidgetsBindingObserver {
  // final WeatherRepository _repository = GetIt.I<WeatherRepository>();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxBool _isNotificationPermission = false.obs;
  bool get isNotificationPermission => _isNotificationPermission.value;

  final RxBool _isFahrenheit = false.obs;
  bool get isFahrenheit => _isFahrenheit.value;

  final RxBool _isUpdate = false.obs;
  bool get isUpdate => _isUpdate.value;

  var logger = Logger();

  @override
  void onInit() {
    _isNotificationPermission(SharedPreferencesUtil().getBool(kNotificationPermission));
    _isFahrenheit(SharedPreferencesUtil().getBool(kFahrenheit));
    super.onInit();
  }

  /// User Interaction
  fahrenheitToggle(bool update) {
    _isUpdate(true);
    _isFahrenheit(update);
    SharedPreferencesUtil().setBool(kFahrenheit, update);
  }

  updateNotification() {
    _isNotificationPermission(SharedPreferencesUtil().getBool(kNotificationPermission));
  }

  sendEmail() async {
    var email = 'teamsoolwww@gmail.com';
    var subject = '헤이웨더 의견보내기';
    var body = await _getEmailBody();

    var url = 'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw '이메일 앱을 열 수 없습니다.';
    }
  }

  Future<String> _getEmailBody() async {
    Map<String, dynamic> appInfo = await _getAppInfo();
    Map<String, dynamic> deviceInfo = await _getDeviceInfo();

    String body = "안녕하세요, 헤이웨더 팀입니다.\n아래에 의견을 자유롭게 남겨주세요.\n\n";

    body += "================================\n";
    body += "아래 내용을 함께 보내주시면 도움이 됩니다.\n";
    appInfo.forEach((key, value) {
      body += "$key: $value\n";
    });
    deviceInfo.forEach((key, value) {
      body += "$key: $value\n";
    });
    body += "================================\n";

    return body;
  }

  Future<Map<String, dynamic>> _getAppInfo() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    return {
      "헤이웨더 버전": info.version
    };
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (GetPlatform.isAndroid) {
        deviceData = _readAndroidDeviceInfo(await deviceInfoPlugin.androidInfo);
      } else if (GetPlatform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } catch(error) {
      deviceData = {
        "Error": "Failed to get platform version."
      };
    }

    return deviceData;
  }

  Map<String, dynamic> _readAndroidDeviceInfo(AndroidDeviceInfo info) {
    var release = info.version.release;
    var sdkInt = info.version.sdkInt;
    var manufacturer = info.manufacturer;
    var model = info.model;

    return {
      "OS 버전": "Android $release (SDK $sdkInt)",
      "기기": "$manufacturer $model"
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo info) {
    var systemName = info.systemName;
    var version = info.systemVersion;
    var machine = info.utsname.machine.iOSProductName;

    return {
      "OS 버전": "$systemName $version",
      "기기": machine
    };
  }
}
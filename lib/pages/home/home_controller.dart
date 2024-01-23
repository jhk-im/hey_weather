import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_dialog.dart';
import 'package:hey_weather/common/shared_preferences_util.dart';
import 'package:hey_weather/repository/soruce/weather_repository.dart';
import 'package:logger/logger.dart';

class HomeController extends GetxController {
  final WeatherRepository _repository = GetIt.I<WeatherRepository>();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxString _addressText = ''.obs;
  String get addressText => _addressText.value;

  var logger = Logger();

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  showOnboardBottomSheet() {
    HeyDialog.showOnBoardingBottomSheet(Get.context!);
  }


  Future getData() async {

    _isLoading(true);

    var location = '';
    var getLocation = SharedPreferencesUtil().getString(currentLocation);
    if (getLocation == null) {
      // 최초 진입
      logger.i('HomeController getData() -> init currentLocation setting');
      location = currentLocation;
      await SharedPreferencesUtil().setString(currentLocation, location);
    } else {
      location = getLocation;
      logger.i('HomeController getData() -> currentLocation = $location');
    }

    // 현재 위치 업데이트
    // 현재 위치가 선택된 경우 그대로 진행
    var getCurrentAddress = await _repository.getUpdateAddressWithCoordinate();
    getCurrentAddress.when(success: (address) async {
      if (location == currentLocation) {
        String depth1 = address.region1depthName ?? '';
        String depth2 = address.region2depthName ?? '';
        String depth3 = address.region3depthName ?? '';
        _addressText('$depth1 $depth2 $depth3');
      } else {

      }
    }, error: (Exception e) {
      logger.e(e);
    });

    _isLoading(false);
    showOnboardBottomSheet();
  }
}
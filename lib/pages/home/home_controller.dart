import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_bottom_sheet.dart';
import 'package:hey_weather/common/shared_preferences_util.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';
import 'package:hey_weather/repository/soruce/weather_repository.dart';
import 'package:logger/logger.dart';

class HomeController extends GetxController {
  final WeatherRepository _repository = GetIt.I<WeatherRepository>();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxString _addressText = ''.obs;
  String get addressText => _addressText.value;

  final RxString _currentAddress = ''.obs;
  String get currentAddress => _currentAddress.value;

  final RxList<Address> _addressList = <Address>[].obs;
  List<Address> get addressList => _addressList;

  var logger = Logger();

  @override
  void onInit() {
    super.onInit();
    _getData();
  }

  _showOnboardBottomSheet() {
    HeyBottomSheet.showOnBoardingBottomSheet(Get.context!);
  }

  resetData(String addressId) async {
    await SharedPreferencesUtil().setString(kCurrentAddressId, addressId);
    _getData();
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

    // 현재 위치 업데이트 -> 현재 위치가 선택된 경우 그대로 진행
    var getCurrentAddress = await _repository.getUpdateAddressWithCoordinate(_currentAddress.value);
    getCurrentAddress.when(success: (address) async {
      String depth1 = address.region1depthName ?? '';
      String depth2 = address.region2depthName ?? '';
      String depth3 = address.region3depthName ?? '';
      _addressText('$depth1 $depth2 $depth3');
      await SharedPreferencesUtil().setString(kCurrentAddressId, address.id!);
    }, error: (Exception e) {
      logger.e(e);
    });

    var getAddressList =  await _repository.getAddressList();
    getAddressList.when(success: (addressList) async {
      _addressList(addressList);
    }, error: (Exception e) {
      logger.e(e);
    });

    _isLoading(false);
    _showOnboardBottomSheet();
  }
}
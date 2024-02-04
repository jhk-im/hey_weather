import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/getx/routes.dart';
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

  final RxList<Address> _recentRecentList = <Address>[].obs;
  List<Address> get recentAddressList => _recentRecentList;

  var logger = Logger();

  @override
  void onInit() {
    super.onInit();
    _getData();
  }

  /*_showOnboardBottomSheet() {
    if (Get.context != null) {
      HeyBottomSheet.showOnBoardingBottomSheet(Get.context!);
    }
  }*/

  moveToAddress() async {
    var result = await Get.toNamed(Routes.routeAddress);

    if (result) {
      updateUserAddressList();
    }
  }

  resetData(String addressId) async {
    // 최근 선택 주소 리스트 업데이트
    await _repository.updateUserAddressRecentIdList(addressId, isSelect: true);
    updateUserAddressList();
  }

  Future _getUpdateAddressWithCoordinate() async {
    logger.i('HomeController getUpdateAddressWithCoordinate()');
    var getUpdateAddressWithCoordinate = await _repository.getUpdateAddressWithCoordinate(_currentAddress.value);
    getUpdateAddressWithCoordinate.when(success: (address) async {
      _addressText(address.addressName);

      // 최초 진입
      if (recentAddressList.isEmpty) {
        _recentRecentList.add(address);
      }
    }, error: (Exception e) {
      logger.e(e);
    });
  }

  Future _getData() async {
    _isLoading(true);

    // 사용자 주소 리스트
    var getUserAddressList =  await _repository.getUserAddressList();
    getUserAddressList.when(success: (addressList) async {

      // 최근 선택 주소 idList
      var getUserAddressRecentIdList =  await _repository.getUserAddressRecentIdList();
      getUserAddressRecentIdList.when(
        success: (idList) {
          addressList.sort((a, b) => idList.indexOf(a.id!).compareTo(idList.indexOf(b.id!)));
          _recentRecentList(addressList);
          _addressText(addressList.first.addressName);
          _currentAddress(addressList.first.id);

          // 현재 위치인 경우 업데이트
          if (addressList.first.id == kCurrentLocationId) {
            _getUpdateAddressWithCoordinate();
          }
        },
        error: (Exception e) {
          logger.e(e);
        },
      );

      _isLoading(false);
    }, error: (Exception e) async {
      // 최초 진입
      logger.i('HomeController getData() -> empty getUserAddressList');
      _currentAddress(kCurrentLocationId);
      await _repository.insertUserAddressEditIdList(kCurrentLocationId);
      await _repository.updateUserAddressRecentIdList(kCurrentLocationId);
      await _getUpdateAddressWithCoordinate();
      _isLoading(false);
    });
    //_showOnboardBottomSheet();
  }

  Future updateUserAddressList() async {
    // 사용자 주소 리스트
    var getUserAddressList =  await _repository.getUserAddressList();
    getUserAddressList.when(success: (addressList) async {

      // 최근 선택 주소 idList
      var getUserAddressRecentIdList =  await _repository.getUserAddressRecentIdList();
      getUserAddressRecentIdList.when(
        success: (idList) {
          print(idList);
          addressList.sort((a, b) => idList.indexOf(a.id!).compareTo(idList.indexOf(b.id!)));
          _recentRecentList(addressList);
          _addressText(addressList.first.addressName);
          _currentAddress(addressList.first.id);
        },
        error: (Exception e) {
          logger.e(e);
        },
      );
    }, error: (Exception e) {
      logger.e(e);
    });
  }
}
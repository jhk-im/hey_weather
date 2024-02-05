import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/shared_preferences_util.dart';
import 'package:hey_weather/getx/routes.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';
import 'package:hey_weather/repository/soruce/weather_repository.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  final WeatherRepository _repository = GetIt.I<WeatherRepository>();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxBool _isLocationPermission = false.obs;
  bool get isLocationPermission => _isLocationPermission.value;

  final RxBool _isOpenSettings = false.obs;
  bool get isOpenSettings => _isOpenSettings.value;

  final RxString _addressText = ''.obs;
  String get addressText => _addressText.value;

  final RxString _currentAddress = ''.obs;
  String get currentAddress => _currentAddress.value;

  final RxList<Address> _recentAddressList = <Address>[].obs;
  List<Address> get recentAddressList => _recentAddressList;

  var logger = Logger();

  @override
  void onInit() {
    _isLocationPermission(SharedPreferencesUtil().getBool(kLocationPermission));
    super.onInit();
    _getData();
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
      _checkLocationPermission();
    }
  }

  /*_showOnboardBottomSheet() {
    if (Get.context != null) {
      HeyBottomSheet.showOnBoardingBottomSheet(Get.context!);
    }
  }*/

  _checkLocationPermission() async {
    var status = await Permission.location.status;
    if (_isLocationPermission.value != status.isGranted) {
      _isLocationPermission(status.isGranted);
      SharedPreferencesUtil().setBool(kLocationPermission, status.isGranted);
      _getData();
    }
  }

  moveToAddress() async {
    var result = await Get.toNamed(Routes.routeAddress);

    if (result) {
      updateUserAddressList();
    }
  }

  resetData(String addressId) async {
    // 최근 선택 주소 리스트 업데이트
    await _repository.insertUserAddressRecentIdList(addressId, isSelect: true);
    updateUserAddressList();
  }

  Future _getUpdateAddressWithCoordinate({bool isAddressUpdate = false, List<Address>? addressList}) async {
    logger.i('HomeController getUpdateAddressWithCoordinate()');
    var getUpdateAddressWithCoordinate = await _repository.getUpdateAddressWithCoordinate();
    getUpdateAddressWithCoordinate.when(success: (address) async {
      if (addressList != null) { // 리스트 업데이트
        final oldAddress = addressList.firstWhere((element) => element.id == kCurrentLocationId);
        final index = addressList.indexOf(oldAddress);
        addressList.remove(oldAddress);
        addressList.insert(index, address);
        if (isAddressUpdate) {
          _addressText(address.addressName);
        }
        _recentAddressList(addressList);
      } else { // 최초 진입
        _addressText(address.addressName);
        _recentAddressList.add(address);
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
          // 현재 위치인 경우 업데이트
          if (addressList.first.id == kCurrentLocationId) {
            _currentAddress(kCurrentLocationId);
            _getUpdateAddressWithCoordinate(isAddressUpdate: true, addressList: addressList);
          } else {
            _addressText(addressList.first.addressName);
            _currentAddress(addressList.first.id);
            _getUpdateAddressWithCoordinate(addressList: addressList);
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
      await _repository.insertUserAddressRecentIdList(kCurrentLocationId);
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
          _recentAddressList(addressList);
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
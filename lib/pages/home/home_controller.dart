import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_bottom_sheet.dart';
import 'package:hey_weather/common/shared_preferences_util.dart';
import 'package:hey_weather/common/utils.dart';
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

  final RxBool _isAllTab = false.obs;
  bool get isAllTab => _isAllTab.value;

  final RxBool _isEditMode = false.obs;
  bool get isEditMode => _isEditMode.value;

  final RxString _addressText = ''.obs;
  String get addressText => _addressText.value;

  final RxString _currentAddress = ''.obs;
  String get currentAddress => _currentAddress.value;

  final RxList<Address> _recentAddressList = <Address>[].obs;
  List<Address> get recentAddressList => _recentAddressList;

  final RxList<String> _myWeatherList = <String>[].obs;
  List<String> get myWeatherList => _myWeatherList;

  // Scroll
  final ScrollController scrollController = ScrollController();
  final RxDouble _scrollY = 0.0.obs;
  double get scrollY => _scrollY.value;

  // Drag
  final RxBool _isDragMode = false.obs;
  bool get isDragMode => _isDragMode.value;

  final RxInt _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  final RxInt _selectIndex = 0.obs;
  int get selectIndex => _selectIndex.value;

  final RxDouble _selectHeight = 0.0.obs;
  double get selectHeight => _selectHeight.value;

  Map<String, double> weatherHeightMap = {
    kWeatherCardTime: 0,
    kWeatherCardWeek: 0,
    kWeatherCardDust: 0,
    kWeatherCardRain: 0,
    kWeatherCardHumidity: 0,
    kWeatherCardFeel: 0,
    kWeatherCardWind: 0,
    kWeatherCardSun: 0,
    kWeatherCardUltraviolet: 0,
  };

  // Weather
  final RxString _sunrise = ''.obs;
  String get sunrise => _sunrise.value;
  final RxString _sunset = ''.obs;
  String get sunset => _sunset.value;

  final RxInt _ultraviolet = 0.obs;
  int get ultraviolet => _ultraviolet.value;

  var _isOnBoard = false;

  var logger = Logger();

  @override
  void onInit() {
    _isOnBoard = SharedPreferencesUtil().getBool(kOnBoard) ?? false;
    _isLocationPermission(SharedPreferencesUtil().getBool(kLocationPermission));
    scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
    _getData();
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
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

  _scrollListener() {
    double scrollPosition = scrollController.position.pixels;
    _scrollY.value = scrollPosition;
  }

  _checkLocationPermission() async {
    var status = await Permission.location.status;
    if (_isLocationPermission.value != status.isGranted) {
      _isLocationPermission(status.isGranted);
      SharedPreferencesUtil().setBool(kLocationPermission, status.isGranted);
      _getData();
    }
  }

  _showOnboardBottomSheet() {
    if (Get.context != null && !_isOnBoard) {
      _isOnBoard = true;
      SharedPreferencesUtil().setBool(kOnBoard, true);
      HeyBottomSheet.showOnBoardingBottomSheet(
          Get.context!,
          onAdd: (idList) {
            updateUserMyWeather(idList, isUpdate: true);
          }
      );
    }
  }

  /// User Interaction
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

  tabToggle(bool isALL) {
    _isAllTab(isALL);
    if (_scrollY.value > 395) {
      scrollController.jumpTo(396);
    }
  }

  editToggle(bool isEdit) {
    _isEditMode(isEdit);
    if (isEdit) {
      updateScroll();
    }
  }

  updateScroll({bool isUpdate = false, double toScroll = 396}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (isUpdate) {
      await scrollController.animateTo(
        toScroll,
        duration: const Duration(seconds: 1),
        curve: Curves.ease,
      );
    } else {
      if (scrollY < 395) {
        scrollController.animateTo(
          toScroll,
          duration: const Duration(seconds: 1),
          curve: Curves.ease,
        );
      }
    }
  }

  setSelectIndex(int index, String id) {
    _selectIndex(index);
    _selectHeight(weatherHeightMap[id]);
  }

  setCurrentIndex(int index) {
    _currentIndex(index);
  }

  showAddWeather() async {
    if (Get.context != null) {
      HeyBottomSheet.showAddWeatherBottomSheet(
          Get.context!,
          _myWeatherList,
          ultraviolet: _ultraviolet.value,
          sunrise: _sunrise.value,
          sunset: _sunset.value,
          onConfirm: (idList) {
            List<String> updateList = List<String>.from(_myWeatherList);
            updateList.addAll(idList);
            updateUserMyWeather(updateList, isUpdate: true);
          }
      );
    }
  }

  /// Data
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
          logger.e('HomeController.getData.getUserAddressRecentIdList $e');
        },
      );
      _getUserMyWeatherIdList();
      _showOnboardBottomSheet();
      _isLoading(false);
    }, error: (Exception e) async {
      // 최초 진입
      logger.i('HomeController.getData -> empty getUserAddressList (init first)');
      _currentAddress(kCurrentLocationId);
      await _repository.insertUserAddressEditIdList(kCurrentLocationId);
      await _repository.insertUserAddressRecentIdList(kCurrentLocationId);
      await _getUpdateAddressWithCoordinate();
      _showOnboardBottomSheet();
      _isLoading(false);
    });
  }

  Future _getUpdateAddressWithCoordinate({bool isAddressUpdate = false, List<Address>? addressList}) async {
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

      _updateWeatherWidget(address);

    }, error: (Exception e) {
      logger.e('HomeController.getUpdateAddressWithCoordinate $e');
    });
  }

  _updateWeatherWidget(Address address) {
    _updateSunRiseSet(address);
    _updateObservatory(address);
  }

  _updateSunRiseSet(Address address) async {
    String addressId = address.id ?? '';
    double longitude = address.x ?? 0;
    double latitude = address.y ?? 0;
    // 일출 일몰
    var getSunRiseSet = await _repository.getSunRiseSetWithCoordinate(addressId, longitude, latitude);
    getSunRiseSet.when(success: (sunRiseSet) {
      logger.i('HomeController.getSunRiseSetWithCoordinate success -> $sunRiseSet');
      _sunrise(Utils.convertToTime(sunRiseSet.sunrise ?? '0500'));
      _sunset(Utils.convertToTime(sunRiseSet.sunset ?? '1900'));

    }, error: (e) {
      logger.e('HomeController.getSunRiseSetWithCoordinate error -> $e');
    });
  }

  _updateObservatory(Address address) async {
    // 관측소
    String depth1 = address.region1depthName ?? '';
    String depth2 = address.region2depthName ?? '';
    String addressId = address.id ?? '';
    var getObservatory = await _repository.getObservatoryWithAddress(depth1, depth2);
    getObservatory.when(success: (observatory) async {
      logger.i('HomeController.getObservatoryWithAddress success -> $observatory');

      // 자외선
      var getUltraviolet = await _repository.getUltraviolet(addressId, observatory.code.toString());
      getUltraviolet.when(success: (ultraviolet) {
        logger.i('HomeController.getUltraviolet success -> $ultraviolet');
        _ultraviolet(int.parse(ultraviolet.h0 ?? '0'));
      }, error: (e) {
        logger.e('HomeController.getUltraviolet error -> $e');
      });
    }, error: (e) {
      logger.e('HomeController.getObservatoryWithAddress error -> $e');
    });
  }

  _getUserMyWeatherIdList() async {
    // My Weather idList
    var getUserMyWeatherIdList = await _repository.getUserMyWeather();
    getUserMyWeatherIdList.when(
      success: (idList) {
        _myWeatherList(idList);
      },
      error: (Exception e) {
        logger.i('HomeController.getData.getUserMyWeatherIdList $e');
      },
    );
  }

  Future updateUserMyWeather(List<String> idList, {bool isUpdate = false}) async {
    await _repository.updateUserMyWeather(idList);
    if (idList.isEmpty) editToggle(false);
    if (isUpdate) {
      _getData();
    }
  }

  Future updateUserAddressList() async {
    // 사용자 주소 리스트
    var getUserAddressList =  await _repository.getUserAddressList();
    getUserAddressList.when(success: (addressList) async {

      // 최근 선택 주소 idList
      var getUserAddressRecentIdList =  await _repository.getUserAddressRecentIdList();
      getUserAddressRecentIdList.when(
        success: (idList) {
          addressList.sort((a, b) => idList.indexOf(a.id!).compareTo(idList.indexOf(b.id!)));
          _recentAddressList(addressList);
          _addressText(addressList.first.addressName);
          _currentAddress(addressList.first.id);
        },
        error: (Exception e) {
          logger.e('HomeController.updateUserAddressList $e');
        },
      );
    }, error: (Exception e) {
      logger.e('HomeController.updateUserAddressList $e');
    });
  }
}
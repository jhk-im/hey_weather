import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_bottom_sheet.dart';
import 'package:hey_weather/common/hey_dialog.dart';
import 'package:hey_weather/common/hey_snackbar.dart';
import 'package:hey_weather/common/shared_preferences_util.dart';
import 'package:hey_weather/common/utils.dart';
import 'package:hey_weather/getx/routes.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';
import 'package:hey_weather/repository/soruce/remote/model/search_address_response.dart';
import 'package:hey_weather/repository/soruce/weather_repository.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class AddressController extends GetxController with WidgetsBindingObserver {
  final WeatherRepository _repository = GetIt.I<WeatherRepository>();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxBool _isUpdated = false.obs;
  bool get isUpdated => _isUpdated.value;

  final RxBool _isEditMode = false.obs;
  bool get isEditMode => _isEditMode.value;

  int get editStatus => _editStatus.value;
  final RxInt _editStatus = 0.obs;

  final RxBool _isLocationPermission = false.obs;
  bool get isLocationPermission => _isLocationPermission.value;

  // 현재 위치
  final Rxn<Address> _currentAddress = Rxn<Address>();
  Address? get currentAddress => _currentAddress.value;

  final RxList<Address> _addressList = <Address>[].obs;
  List<Address> get addressList => _addressList;

  final RxList<SearchAddressResult> _searchAddressList =
      <SearchAddressResult>[].obs;
  List<SearchAddressResult> get searchAddressList => _searchAddressList;

  final RxString _searchAddressText = ''.obs;
  String get searchAddressText => _searchAddressText.value;

  final RxString _updateAddressText = ''.obs;
  String get updateAddressText => _updateAddressText.value;

  // input field
  TextEditingController textFieldController = TextEditingController();
  final _deBouncer = BehaviorSubject<String>();
  final focusNode = FocusNode();

  var logger = Logger();

  // Home Card
  final RxString _homeWeatherStatusText = ''.obs;
  String get homeWeatherStatusText => _homeWeatherStatusText.value;
  final RxString _homeWeatherIconName = ''.obs;
  String get homeWeatherIconName => _homeWeatherIconName.value;
  final RxInt _homeTemperature = 0.obs;
  int get homeTemperature => _homeTemperature.value;
  final RxInt _homeYesterdayTemperature = 0.obs;
  int get homeYesterdayTemperature => _homeYesterdayTemperature.value;
  final RxInt _homeRain = 0.obs;
  int get homeRain => _homeRain.value;
  final RxInt _homeRainPercent = 0.obs;
  int get homeRainPercent => _homeRainPercent.value;
  final RxString _homeRainTime = ''.obs;
  String get homeRainTime => _homeRainTime.value;

  // 일출 일몰
  final RxInt _timeSunrise = 0.obs;
  int get timeSunrise => _timeSunrise.value;
  final RxInt _timeSunset = 0.obs;
  int get timeSunset => _timeSunset.value;

  // 대기질
  final RxInt _fineDust = 0.obs;
  int get fineDust => _fineDust.value;
  final RxInt _ultraFineDust = 0.obs;
  int get ultraFineDust => _ultraFineDust.value;

  // 강수
  final RxString _rainStatusText = '없음'.obs;
  String get rainStatusText => _rainStatusText.value;

  @override
  void onInit() {
    _isLocationPermission(SharedPreferencesUtil().getBool(kLocationPermission));

    _deBouncer.debounceTime(const Duration(microseconds: 300)).listen((text) {
      if (text.length > 1) {
        _searchAddressText(text);
        _searchAddress(text);
      } else {
        _searchAddressList.clear();
      }
    });
    super.onInit();
    _getData();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    _deBouncer.close();
    textFieldController.dispose();
    focusNode.dispose();
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

  _checkLocationPermission() async {
    var status = await Permission.location.status;
    if (_isLocationPermission.value != status.isGranted) {
      _isLocationPermission(status.isGranted);
      SharedPreferencesUtil().setBool(kLocationPermission, status.isGranted);
      _getUpdateAddressWithCoordinate();
    }
  }

  /// User Interaction
  changeEditStatus(int status) {
    _editStatus(status);
  }

  textFieldListener(String text) {
    _deBouncer.add(text);
  }

  resetTextField() {
    textFieldController.text = '';
    focusNode.unfocus();
    _searchAddressList.clear();
  }

  _createSearchAddress(Address address, String searchText) {
    resetTextField();
    _updateAddressCard(address, searchText);
  }

  selectAddress(Address address) async {
    if (!isEditMode && address.id != null) {
      // 최근 선택 주소 리스트 업데이트
      await _repository.insertUserAddressRecentIdList(address.id!,
          isSelect: true);
      Get.offAllNamed(Routes.routeHome);
    }
  }

  removeAddress(Address address) async {
    if (address.id != null) {
      if (Get.context != null) {
        HeyDialog.showCommonDialog(
          Get.context!,
          title: 'dialog_delete_location'.tr,
          subtitle: '${address.region2depthName} ${address.region3depthName}',
          onOk: () async {
            _isUpdated(true);
            await _repository.deleteUserAddressWithId(address.id!);
            _addressList.remove(address);
          },
        );
      }
    }
  }

  editModeToggle() async {
    _isEditMode(!_isEditMode.value);

    if (!isEditMode) {
      _editStatus(3);

      _isUpdated(true);
      final idList = addressList.map((element) => element.id ?? '').toList();
      await _repository.updateUserAddressEditIdList(idList);
      final recent =
          addressList.where((e) => e.id != kCurrentLocationId).toList();
      recent.sort((a, b) => DateTime.parse(b.createDateTime ?? '')
          .compareTo(DateTime.parse(a.createDateTime ?? '')));
      addressList[addressList.indexOf(recent.first)].isRecent = true;

      await Future.delayed(const Duration(milliseconds: 500));
      _editStatus(0);
    } else {
      _editStatus(1);
      await Future.delayed(const Duration(milliseconds: 500));
      _editStatus(2);
    }
  }

  showCreateAddressBottomSheet(
      BuildContext context, SearchAddressResult address) async {
    Address newAddress = Address();
    newAddress.id = kCreateWidgetId;
    newAddress.addressName = address.addressName;

    var names = address.addressName?.split(' ');
    // newAddress.region1depthName = names != null && names.isNotEmpty ? names[0] : '서울';
    newAddress.region2depthName = names?[names.length - 2];
    newAddress.region3depthName = names?.last;

    newAddress.x = address.x ?? 0;
    newAddress.y = address.y ?? 0;

    var createAddress = await _updateCreateWeatherWidget(newAddress);
    if (context.mounted) {
      await _showBottomSheet(context, createAddress);
    }
  }

  _showBottomSheet(BuildContext context, Address address) async {
    HeyBottomSheet.showCreateAddressBottomSheet(
      context,
      address: address,
      searchText: '${address.region2depthName} ${address.region3depthName}',
      onCreateAddress: (address, searchText) {
        Get.back();
        _createSearchAddress(address, searchText);
      },
    );
  }

  /// Data
  Future _getUpdateAddressWithCoordinate() async {
    //logger.i('AddressController getUpdateAddressWithCoordinate()');
    var getUpdateAddressWithCoordinate =
        await _repository.getUpdateAddressWithCoordinate(kCurrentLocationId);
    getUpdateAddressWithCoordinate.when(success: (address) async {
      _isUpdated(true);
      await _updateCurrentWeatherWidget(address);
    }, error: (Exception e) {
      logger.e(e);
    });
  }

  Future _getData() async {
    // 사용자 주소 리스트
    var getUserAddressList = await _repository.getUserAddressList();
    getUserAddressList.when(success: (addressList) async {
      var currentAddress = addressList
          .firstWhereOrNull((element) => element.id == kCurrentLocationId);
      if (currentAddress != null) {
        await _updateCurrentWeatherWidget(currentAddress);
      }
      final sortList =
          addressList.where((e) => e.id != kCurrentLocationId).toList();
      final recent =
          addressList.where((e) => e.id != kCurrentLocationId).toList();

      recent.sort((a, b) => DateTime.parse(b.createDateTime ?? '')
          .compareTo(DateTime.parse(a.createDateTime ?? '')));

      // 편집 주소 idList
      var getUserAddressEditIdList =
          await _repository.getUserAddressEditIdList();
      getUserAddressEditIdList.when(
        success: (idList) {
          sortList.sort(
              (a, b) => idList.indexOf(a.id!).compareTo(idList.indexOf(b.id!)));
          if (sortList.isNotEmpty) {
            sortList[sortList.indexOf(recent.first)].isRecent = true;
            _addressList(sortList);
            _updateCustomWeatherWidgetList(sortList);
          }
        },
        error: (Exception e) {
          logger.e(e);
        },
      );
    }, error: (Exception e) {
      logger.e(e);
    });
  }

  Future<Address> _updateCreateWeatherWidget(Address address) async {
    _isLoading(true);
    var address1 = await _updateSunRiseSet(address);
    var address2 = await _updateFineDust(address1);
    var address3 = await _updateUltraShortTerm(address2);
    var address4 = await _updateShortTerm(address3);
    var address5 = await _updateYesterdayShortTerm(address4);
    _isLoading(false);
    return address5;
  }

  _updateCustomWeatherWidgetList(List<Address> sortList) async {
    List<Address> updateList = [];
    for (var address in sortList) {
      var address1 = await _updateSunRiseSet(address);
      var address2 = await _updateFineDust(address1);
      var address3 = await _updateUltraShortTerm(address2);
      var address4 = await _updateShortTerm(address3);
      updateList.add(address4);
    }
    _addressList(updateList);
  }

  _updateCurrentWeatherWidget(Address address) async {
    _isLoading(true);
    var address1 = await _updateSunRiseSet(address);
    var address2 = await _updateFineDust(address1);
    var address3 = await _updateUltraShortTerm(address2);
    var address4 = await _updateShortTerm(address3);
    _currentAddress(address4);
    _isLoading(false);
  }

  Future<Address> _updateSunRiseSet(Address address) async {
    String addressId = address.id ?? '';
    double longitude = address.x ?? 0;
    double latitude = address.y ?? 0;
    // 일출 일몰
    var getSunRiseSet = await _repository.getSunRiseSetWithCoordinate(
        addressId, longitude, latitude);
    getSunRiseSet.when(success: (sunRiseSet) {
      // logger.i('HomeController.getSunRiseSetWithCoordinate success');
      var sunrise = sunRiseSet.sunrise ?? '0500';
      var sunset = sunRiseSet.sunset ?? '1900';
      address.timeSunrise = int.parse(sunrise);
      address.timeSunset = int.parse(sunset);
    }, error: (e) {
      logger.e('HomeController.getSunRiseSetWithCoordinate error -> $e');
    });
    return address;
  }

  Future<Address> _updateFineDust(Address address) async {
    String addressId = address.id ?? '';
    String depth1 = address.region1depthName ?? '';
    var getFineDust = await _repository.getFineDustWithCity(addressId, depth1);
    getFineDust.when(success: (fineDust) async {
      //logger.i('AddressController.getFineDust success');

      try {
        address.fineDust = int.parse((fineDust.pm10Value ?? '0'));
      } catch (e) {
        address.fineDust = 0;
      }

      try {
        address.ultraFineDust = int.parse((fineDust.pm25Value ?? '0'));
      } catch (e) {
        address.ultraFineDust = 0;
      }
    }, error: (e) {
      logger.e('AddressController.getFineDust error -> $e');
    });

    return address;
  }

  Future<Address> _updateUltraShortTerm(Address address) async {
    double longitude = address.x ?? 0;
    double latitude = address.y ?? 0;
    String addressId = address.id ?? '';
    var getUltraShortTerm =
        await _repository.getUltraShortTermList(addressId, longitude, latitude);
    getUltraShortTerm.when(success: (ultraShortTermList) async {
      //logger.i('AddressController.getUltraShortTermList success');

      for (var item in ultraShortTermList) {
        String category = item.category ?? '';
        double value = double.parse(item.obsrValue ?? '0');
        switch (category) {
          case kWeatherCategoryTemperature:
            address.temperature = value.round();
          case kWeatherCategoryRain:
            if (value < 1 && value > 0) {
              address.rain = 1;
            } else {
              address.rain = value.round();
            }
          case kWeatherCategoryRainStatus:
            address.rainStatusText =
                item.weatherCategory?.codeValues?[value.round()];
        }
      }
    }, error: (e) {
      logger.e('HomeController.getUltraShortTermList error -> $e');
    });
    return address;
  }

  Future<Address> _updateShortTerm(Address address) async {
    double longitude = address.x ?? 0;
    double latitude = address.y ?? 0;
    String addressId = address.id ?? '';

    var getUltraShortTermSixTime = await _repository.getUltraShortTermSixTime(
        addressId, longitude, latitude);
    getUltraShortTermSixTime.when(success: (ultraSixTime) async {
      //logger.i('AddressController.getUltraShortTermSixTime success');

      // 기온
      var temperatureList = ultraSixTime
          .where((element) => element.category == kWeatherCategoryTemperature)
          .toList();
      for (var element in temperatureList) {
        element.weatherCategory?.name = '기온(1시간)';
        element.category = kWeatherCategoryTemperatureShort;
        var newBaseTime = element.baseTime?.replaceAll('30', '00');
        element.baseTime = newBaseTime;
      }
      // 하늘 상태
      var skyList = ultraSixTime
          .where((element) => element.category == kWeatherCategorySky)
          .toList();
      for (var element in skyList) {
        var newBaseTime = element.baseTime?.replaceAll('30', '00');
        element.baseTime = newBaseTime;
      }

      // 현재 날씨 상태
      String time = temperatureList[0].fcstTime ?? '0000';
      int currentTime = int.parse(time);
      int skyIndex = int.parse(skyList[0].fcstValue ?? '0');
      String skyStatus =
          skyList[0].weatherCategory?.codeValues?[skyIndex] ?? '';
      int iconIndex = Utils.getIconIndex(
          rainStatus: _rainStatusText.value,
          skyStatus: skyStatus,
          currentTime: currentTime,
          sunrise: address.timeSunrise ?? 0,
          sunset: address.timeSunset ?? 0);
      address.weatherIconName = kWeatherIconList[iconIndex];
      address.weatherStatusText = kWeatherStatus[address.weatherIconName];
    }, error: (e) {
      logger.e('HomeController.getUltraShortTermSixTime error -> $e');
    });

    return address;
  }

  Future<Address> _updateYesterdayShortTerm(Address address) async {
    double longitude = address.x ?? 0;
    double latitude = address.y ?? 0;
    String addressId = address.id ?? '';

    var getYesterdayShortTerm = await _repository.getYesterdayShortTermList(
        addressId, longitude, latitude);
    getYesterdayShortTerm.when(success: (shortTermList) async {
      //logger.i('AddressController.getYesterdayShortTerm success');
      var currentTime = Utils.getCurrentTimeInHHFormat();
      var yesterday = shortTermList.firstWhereOrNull((element) =>
          element.category == kWeatherCategoryTemperatureShort &&
          element.fcstTime == currentTime);
      if (yesterday != null) {
        address.yesterdayTemperature = int.parse(yesterday.fcstValue ?? '0');
      }
    }, error: (e) {
      logger.e('AddressController.getYesterdayShortTerm error -> $e');
    });
    return address;
  }

  Future _searchAddress(String query) async {
    var getCurrentAddress = await _repository.getSearchAddress(query);
    getCurrentAddress.when(success: (searchAddress) async {
      logger.i('searchAddress() -> $searchAddress');
      _searchAddressList(searchAddress);
    }, error: (Exception e) {
      logger.e(e);
    });
  }

  Future _updateAddressCard(Address address, String searchText) async {
    String uuid = const Uuid().v4();

    // final newAddress = Address();
    // newAddress.addressName = Utils().containsSearchText(address.addressName, searchText);
    // newAddress.x = double.parse(address.x!);
    // newAddress.y = double.parse(address.y!);
    // newAddress.id = uuid;
    // newAddress.createDateTime = DateTime.now().toLocal().toString();
    // await _repository.updateUserAddressWithId(newAddress);
    address.addressName =
        Utils().containsSearchText(address.addressName, searchText);
    address.id = uuid;
    address.createDateTime = DateTime.now().toLocal().toString();

    print('address -> $address');

    await _repository.updateUserAddressWithId(address);
    await _repository.insertUserAddressEditIdList(uuid);
    await _repository.insertUserAddressRecentIdList(uuid);

    _isUpdated(true);

    _updateAddressText(searchText);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (Get.context != null) {
        HeySnackBar.show(
          Get.context!,
          'toast_added_location'.tr,
          isCheckIcon: true,
        );

        // _getData();
        for (var element in addressList) {
          element.isRecent = false;
        }
        address.isRecent = true;
        addressList.insert(0, address);
      }
    });
  }
}

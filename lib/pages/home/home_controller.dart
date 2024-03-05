import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_bottom_sheet.dart';
import 'package:hey_weather/common/shared_preferences_util.dart';
import 'package:hey_weather/common/utils.dart';
import 'package:hey_weather/getx/routes.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';
import 'package:hey_weather/repository/soruce/remote/model/mid_term_land.dart';
import 'package:hey_weather/repository/soruce/remote/model/mid_term_temperature.dart';
import 'package:hey_weather/repository/soruce/remote/model/short_term.dart';
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

  final RxString _currentAddressId = ''.obs;
  String get currentAddressId => _currentAddressId.value;

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

  var _isOnBoard = false;

  var logger = Logger();

  // Weather
  final RxString _homeWeatherStatus = ''.obs;
  String get homeWeatherStatus => _homeWeatherStatus.value;
  final RxString _homeWeatherIconName = ''.obs;
  String get homeWeatherIconName => _homeWeatherIconName.value;
  final RxString _homeRainTime = ''.obs;
  String get homeRainTime => _homeRainTime.value;
  final RxInt _homeRainPercent = 0.obs;
  int get homeRainPercent => _homeRainPercent.value;

  final RxInt _ultraShortTemperature = 0.obs;
  int get ultraShortTemperature => _ultraShortTemperature.value;
  final RxInt _yesterdayTemperature = 0.obs;
  int get yesterdayTemperature => _yesterdayTemperature.value;
  final RxInt _ultraShortHumidity = 0.obs;
  int get ultraShortHumidity => _ultraShortHumidity.value;
  final RxInt _ultraShortRain = 0.obs;
  int get ultraShortRain => _ultraShortRain.value;
  final RxString _ultraShortRainStatus = '없음'.obs;
  String get ultraShortRainStatus => _ultraShortRainStatus.value;
  final RxDouble _ultraShortWindSpeed = 0.0.obs;
  double get ultraShortWindSpeed => _ultraShortWindSpeed.value;
  final RxInt _ultraShortWindDirection = 0.obs;
  int get ultraShortWindDirection => _ultraShortWindDirection.value;

  final RxList<ShortTerm> _skyStatusList = <ShortTerm>[].obs;
  List<ShortTerm> get skyStatusList => _skyStatusList;
  final RxList<ShortTerm> _temperatureList = <ShortTerm>[].obs;
  List<ShortTerm> get temperatureList => _temperatureList;
  final RxList<ShortTerm> _rainStatusList = <ShortTerm>[].obs;
  List<ShortTerm> get rainStatusList => _rainStatusList;
  final RxList<ShortTerm> _rainPercentList = <ShortTerm>[].obs;
  List<ShortTerm> get rainPercentList => _rainPercentList;

  final RxInt _apparentTemperatureMin = 0.obs;
  int get apparentTemperatureMin => _apparentTemperatureMin.value;
  final RxInt _apparentTemperatureMax = 0.obs;
  int get apparentTemperatureMax => _apparentTemperatureMax.value;

  final RxInt _rainPercentage = 0.obs;
  int get rainPercentage => _rainPercentage.value;

  final RxString _sunrise = ''.obs;
  String get sunrise => _sunrise.value;
  final RxString _sunset = ''.obs;
  String get sunset => _sunset.value;
  final RxInt _sunriseTime = 0.obs;
  int get sunriseTime => _sunriseTime.value;
  final RxInt _sunsetTime = 0.obs;
  int get sunsetTime => _sunsetTime.value;

  final RxInt _ultraviolet = 0.obs;
  int get ultraviolet => _ultraviolet.value;

  final RxInt _fineDust = 0.obs;
  int get fineDust => _fineDust.value;
  final RxInt _ultraFineDust = 0.obs;
  int get ultraFineDust => _ultraFineDust.value;

  final Rx<MidTermTemperature> _midTermTemperature = MidTermTemperature().obs;
  MidTermTemperature get midTermTemperature => _midTermTemperature.value;
  final Rx<MidTermLand> _midTermLand = MidTermLand().obs;
  MidTermLand get midTermLand => _midTermLand.value;

  @override
  void onInit() {
    _isOnBoard = SharedPreferencesUtil().getBool(kOnBoard) ?? false;
    _isLocationPermission(SharedPreferencesUtil().getBool(kLocationPermission));
    scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
    getData();
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
      getData();
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
          windSpeed: _ultraShortWindSpeed.value,
          windDirection: _ultraShortWindDirection.value,
          todayHumidity: _ultraShortHumidity.value,
          rain: _ultraShortRain.value,
          feelMax: _apparentTemperatureMax.value,
          feelMin: _apparentTemperatureMin.value,
          temperatureList: _temperatureList,
          skyStatusList: _skyStatusList,
          rainStatusList: _rainStatusList,
          rainPercentList: _rainPercentList,
          rainStatus: _ultraShortRainStatus.value,
          rainPercentage: _rainPercentage.value,
          ultraviolet: _ultraviolet.value,
          sunrise: _sunrise.value,
          sunset: _sunset.value,
          fineDust: _fineDust.value,
          ultraFineDust: _ultraFineDust.value,
          currentTemperature: _ultraShortTemperature.value,
          onConfirm: (idList) {
            List<String> updateList = List<String>.from(_myWeatherList);
            updateList.addAll(idList);
            updateUserMyWeather(updateList, isUpdate: true);
          }
      );
    }
  }

  /// Data
  Future getData() async {
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
            _currentAddressId(kCurrentLocationId);
            _getUpdateAddressWithCoordinate(isAddressUpdate: true, addressList: addressList);
          } else {
            _addressText(addressList.first.addressName);
            _currentAddressId(addressList.first.id);
            _getUpdateAddressWithCoordinate(addressList: addressList);
          }
        },
        error: (Exception e) {
          logger.e('HomeController.getData.getUserAddressRecentIdList $e');
        },
      );
      _getUserMyWeatherIdList();
      _showOnboardBottomSheet();

    }, error: (Exception e) async {
      // 최초 진입
      logger.i('HomeController.getData -> empty getUserAddressList (init first)');
      _currentAddressId(kCurrentLocationId);
      await _repository.insertUserAddressEditIdList(kCurrentLocationId);
      await _repository.insertUserAddressRecentIdList(kCurrentLocationId);
      await _getUpdateAddressWithCoordinate();
      _showOnboardBottomSheet();
    });
  }

  Future _getUpdateAddressWithCoordinate({bool isAddressUpdate = false, List<Address>? addressList}) async {
    logger.d('getUpdateAddressWithCoordinate() currentAddressId -> $currentAddressId');
    var getUpdateAddressWithCoordinate = await _repository.getUpdateAddressWithCoordinate(currentAddressId);
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

  _updateWeatherWidget(Address address) async {
    _isLoading(true);
    await _updateSunRiseSet(address);
    await _updateObservatory(address);
    await _updateFineDust(address);
    await _updateUltraShortTerm(address);
    await _updateShortTerm(address);
    await _updateMidTerm(address);
    _isLoading(false);
  }

  _updateUltraShortTerm(Address address) async {
    double longitude = address.x ?? 0;
    double latitude = address.y ?? 0;
    String addressId = address.id ?? '';
    var getUltraShortTerm = await _repository.getUltraShortTermList(addressId, longitude, latitude);
    getUltraShortTerm.when(success: (ultraShortTermList) async {
      logger.i('HomeController.getUltraShortTermList success');

      for (var item in ultraShortTermList) {
        String category = item.category ?? '';
        double value = double.parse(item.obsrValue ?? '0');
        switch (category) {
          case kWeatherCategoryTemperature:
            _ultraShortTemperature(value.round());
          case kWeatherCategoryHumidity:
            _ultraShortHumidity(value.round());
          case kWeatherCategoryRain:
            _ultraShortRain(value.round());
          case kWeatherCategoryRainStatus:
            _ultraShortRainStatus(item.weatherCategory?.codeValues?[value.round()]);
          case kWeatherCategoryWindSpeed:
            _ultraShortWindSpeed(value);
          case kWeatherCategoryWindDirection:
            _ultraShortWindDirection(value.round());
        }
      }

    }, error: (e) {
      logger.e('HomeController.getUltraShortTermList error -> $e');
    });
  }

  _updateShortTerm(Address address) async {
    double longitude = address.x ?? 0;
    double latitude = address.y ?? 0;
    String addressId = address.id ?? '';

    var getUltraShortTermSixTime = await _repository.getUltraShortTermSixTime(addressId, longitude, latitude);
    getUltraShortTermSixTime.when(success: (ultraSixTime) async {
      logger.i('HomeController.getUltraShortTermSixTime success');

      // 기온
      var temperatureFirstList = ultraSixTime.where((element) => element.category == kWeatherCategoryTemperature).toList();
      for (var element in temperatureFirstList) {
        element.weatherCategory?.name = '기온(1시간)';
        element.category = kWeatherCategoryTemperatureShort;
        var newBaseTime = element.baseTime?.replaceAll('30', '00');
        element.baseTime = newBaseTime;
      }
      // 하늘상태
      var skyFirstList = ultraSixTime.where((element) => element.category == kWeatherCategorySky).toList();
      for (var element in skyFirstList) {
        var newBaseTime = element.baseTime?.replaceAll('30', '00');
        element.baseTime = newBaseTime;
      }
      // 강수형태
      var rainStatusFirstList = ultraSixTime.where((element) => element.category == kWeatherCategoryRainStatus).toList();
      for (var element in rainStatusFirstList) {
        var newBaseTime = element.baseTime?.replaceAll('30', '00');
        element.baseTime = newBaseTime;
      }

      var getShortTermList = await _repository.getShortTermList(addressId, longitude, latitude);
      getShortTermList.when(success: (shortTermList) async {
        logger.i('HomeController.getShortTermList success');

        DateTime dateTime = DateTime.now();
        DateTime currentDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour + 5);
        var sevenHoursLater = currentDateTime.add(const Duration(hours: 7));

        var shortTermListSixTime = shortTermList.where((item) {
          var forecastDateTime = DateTime.parse("${item.fcstDate} ${item.fcstTime.toString().padLeft(4, '0')}");
          return forecastDateTime.isAfter(currentDateTime) && forecastDateTime.isBefore(sevenHoursLater);
        }).toList();

        // 기온
        var temperatureNextList = shortTermListSixTime.where((element) => element.category == kWeatherCategoryTemperatureShort).toList();
        var temperatureList = temperatureFirstList + temperatureNextList;
        // 하늘상태
        var skyNextList = shortTermListSixTime.where((element) => element.category == kWeatherCategorySky).toList();
        var skyList = skyFirstList + skyNextList;
        // 강수형태
        var rainStatusNextList = shortTermListSixTime.where((element) => element.category == kWeatherCategoryRainStatus).toList();
        var rainStatusList = rainStatusFirstList + rainStatusNextList;
        // 강수확률
        var rainPercentList = shortTermList.where((element) => element.category == kWeatherCategoryRainPercent).toList();

        _temperatureList(temperatureList);
        _skyStatusList(skyList);
        _rainStatusList(rainStatusList);
        _rainPercentList(rainPercentList);
        _rainPercentage(int.parse(rainPercentList[0].fcstValue ?? '0'));

        var rainTempPercentList = rainPercentList.sublist(1, rainPercentList.length);
        var maxRainValue = rainTempPercentList.reduce((value, element) => int.parse(value.fcstValue ?? '0') > int.parse(element.fcstValue ?? '0') ? value : element);
        ShortTerm? maxFcstValueObject = rainTempPercentList.firstWhereOrNull((element) => element.fcstValue == maxRainValue.fcstValue);
        if (maxFcstValueObject != null) {
          _homeRainTime(Utils.convertToTimeFormat(maxFcstValueObject.fcstTime ?? '0000'));
          _homeRainPercent(int.parse(maxFcstValueObject.fcstValue ?? '0'));
        }

        int min = SharedPreferencesUtil().getInt(kTodayMinFeel);
        int max = SharedPreferencesUtil().getInt(kTodayMaxFeel);
        _apparentTemperatureMin(min);
        _apparentTemperatureMax(max);

        // 현재 날씨 상태
        String time = temperatureList[0].fcstTime ?? '0000';
        int currentTime = int.parse(time);
        int rainIndex = int.parse(rainStatusList[0].fcstValue ?? '0');
        String rainStatus = rainStatusList[0].weatherCategory?.codeValues?[rainIndex] ?? '없음';
        int skyIndex = int.parse(skyList[0].fcstValue ?? '0');
        String skyStatus = skyList[0].weatherCategory?.codeValues?[skyIndex] ?? '';
        int iconIndex = Utils.getIconIndex(rainStatus: rainStatus, skyStatus: skyStatus, currentTime: currentTime, sunrise: _sunriseTime.value, sunset: _sunsetTime.value);
        _homeWeatherIconName(kWeatherIconList[iconIndex]);
        _homeWeatherStatus(kWeatherStatus[_homeWeatherIconName.value]);
      }, error: (e) {
        logger.e('HomeController.getShortTermList error -> $e');
      });

      var getYesterdayShortTerm = await _repository.getYesterdayShortTermList(addressId, longitude, latitude);
      getYesterdayShortTerm.when(success: (shortTermList) async {
        logger.i('HomeController.getYesterdayShortTerm success');
        var currentTime = Utils.getCurrentTimeInHHFormat();
        var yesterday = shortTermList.firstWhereOrNull((element) => element.category == kWeatherCategoryTemperatureShort && element.fcstTime == currentTime);
        if (yesterday != null) {
          _yesterdayTemperature(int.parse(yesterday.fcstValue ?? '0'));
        }
      }, error: (e) {
        logger.e('HomeController.getYesterdayShortTerm error -> $e');
      });

    }, error: (e) {
      logger.e('HomeController.getUltraShortTermSixTime error -> $e');
    });
  }

  _updateObservatory(Address address) async {
    // 관측소
    String depth1 = address.region1depthName ?? '';
    String depth2 = address.region2depthName ?? '';
    String addressId = address.id ?? '';
    var getObservatory = await _repository.getObservatoryWithAddress(depth1, depth2);
    getObservatory.when(success: (observatory) async {
      logger.i('HomeController.getObservatoryWithAddress success');

      // 자외선
      var getUltraviolet = await _repository.getUltraviolet(addressId, observatory.code.toString());
      getUltraviolet.when(success: (ultraviolet) {
        logger.i('HomeController.getUltraviolet success');
        _ultraviolet(int.parse(ultraviolet.h0 ?? '0'));
      }, error: (e) {
        logger.e('HomeController.getUltraviolet error -> $e');
      });
    }, error: (e) {
      logger.e('HomeController.getObservatoryWithAddress error -> $e');
    });
  }

  _updateSunRiseSet(Address address) async {
    String addressId = address.id ?? '';
    double longitude = address.x ?? 0;
    double latitude = address.y ?? 0;
    // 일출 일몰
    var getSunRiseSet = await _repository.getSunRiseSetWithCoordinate(addressId, longitude, latitude);
    getSunRiseSet.when(success: (sunRiseSet) {
      logger.i('HomeController.getSunRiseSetWithCoordinate success');
      var sunrise = sunRiseSet.sunrise ?? '0500';
      var sunset = sunRiseSet.sunset ?? '1900';
      _sunrise(Utils.convertToTime(sunrise));
      _sunset(Utils.convertToTime(sunset));
      _sunriseTime(int.parse(sunrise));
      _sunsetTime(int.parse(sunset));
    }, error: (e) {
      logger.e('HomeController.getSunRiseSetWithCoordinate error -> $e');
    });
  }

  _updateFineDust(Address address) async {
    String addressId = address.id ?? '';
    String depth1 = address.region1depthName ?? '';
    var getFineDust = await _repository.getFineDustWithCity(addressId, depth1);
    getFineDust.when(success: (fineDust) async {
      logger.i('HomeController.getFineDust success');

      try {
        _fineDust(int.parse((fineDust.pm10Value ?? '0')));
      } catch (e) {
        _fineDust(0);
      }

      try {
        _ultraFineDust(int.parse((fineDust.pm25Value ?? '0')));
      } catch (e) {
        _ultraFineDust(0);
      }
    }, error: (e) {
      logger.e('HomeController.getFineDust error -> $e');
    });
  }

  _updateMidTerm(Address address) async {
    String addressId = address.id ?? '';
    // midCode
    String depth1 = address.region1depthName ?? '';
    String depth2 = address.region2depthName ?? '';

    // 중기 예보 지점 코드
    var getMidCode = await _repository.getMidCode(depth1, depth2);
    getMidCode.when(success: (midCode) async {
      logger.i('HomeController.getMidCode success -> $midCode');
      String regId = midCode.code ?? '';

      var getMidTermTemperature = await _repository.getMidTermTemperature(addressId, regId);
      getMidTermTemperature.when(success: (midTermTemperature) {
        logger.i('HomeController.getMidTermTemperature success -> $midTermTemperature');
        _midTermTemperature(midTermTemperature);
      }, error: (e) {
        logger.e('HomeController.midTermTemperature error -> $e');
      });

      // 중기 육상 예보
      var getMidTermLand = await _repository.getMidTermLand(addressId, depth1, depth2);
      getMidTermLand.when(success: (midTermLand) {
        logger.i('HomeController.getMidTermLand success -> $midTermLand');
        _midTermLand(midTermLand);
      }, error: (e) {
        logger.e('HomeController.getMidTermLand error -> $e');
      });
    }, error: (e) {
      logger.e('HomeController.getMidCode error -> $e');
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
      getData();
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
          _currentAddressId(addressList.first.id);
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
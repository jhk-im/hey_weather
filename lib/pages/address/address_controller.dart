import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_snackbar.dart';
import 'package:hey_weather/common/shared_preferences_util.dart';
import 'package:hey_weather/common/utils.dart';
import 'package:hey_weather/getx/routes.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';
import 'package:hey_weather/repository/soruce/local/model/search_address.dart';
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

  final RxBool _isLocationPermission = false.obs;
  bool get isLocationPermission => _isLocationPermission.value;

  final Rxn<Address> _currentAddress = Rxn<Address>();
  Address? get currentAddress => _currentAddress.value;

  final RxList<Address> _addressList = <Address>[].obs;
  List<Address> get addressList => _addressList;

  final RxList<SearchAddress> _searchAddressList = <SearchAddress>[].obs;
  List<SearchAddress> get searchAddressList => _searchAddressList;

  final RxString _searchAddressText = ''.obs;
  String get searchAddressText => _searchAddressText.value;

  final RxString _updateAddressText = ''.obs;
  String get updateAddressText => _updateAddressText.value;

  // input field
  TextEditingController textFieldController = TextEditingController();
  final _deBouncer = BehaviorSubject<String>();
  final focusNode = FocusNode();

  var logger = Logger();

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
  textFieldListener(String text) {
    _deBouncer.add(text);
  }

  resetTextField() {
    textFieldController.text = '';
    focusNode.unfocus();
    _searchAddressList.clear();
  }

  createSearchAddress(SearchAddress address, String searchText) {
    resetTextField();
    _updateAddressCard(address, searchText);
  }

  selectAddress(Address address) async {
    if (!isEditMode && address.id != null) {
      // 최근 선택 주소 리스트 업데이트
      await _repository.insertUserAddressRecentIdList(address.id!, isSelect: true);
      Get.offAllNamed(Routes.routeHome);
    }
  }

  removeAddress(Address address) async {
    if (address.id != null) {
      _isUpdated(true);
      await _repository.deleteUserAddressWithId(address.id!);
      _addressList.remove(address);
    }
  }

  editModeToggle() async {
    _isEditMode(!_isEditMode.value);

    if (!isEditMode) {
      _isUpdated(true);
      final idList = addressList.map((element) => element.id ?? '').toList();
      await _repository.updateUserAddressEditIdList(idList);

      final recent = addressList.where((e) => e.id != kCurrentLocationId).toList();
      recent.sort((a, b) => DateTime.parse(b.createDateTime ?? '').compareTo(DateTime.parse(a.createDateTime ?? '')));
      addressList[addressList.indexOf(recent.first)].isRecent = true;
    }
  }

  /// Data
  Future _getUpdateAddressWithCoordinate() async {
    logger.i('AddressController getUpdateAddressWithCoordinate()');
    var getUpdateAddressWithCoordinate = await _repository.getUpdateAddressWithCoordinate(currentAddress?.id ?? kCurrentLocationId);
    getUpdateAddressWithCoordinate.when(success: (address) async {
      _currentAddress(address);
      _isUpdated(true);
    }, error: (Exception e) {
      logger.e(e);
    });
  }

  Future _getData() async {
    _isLoading(true);

    // 사용자 주소 리스트
    var getUserAddressList =  await _repository.getUserAddressList();
    getUserAddressList.when(success: (addressList) async {
      var currentAddress = addressList.firstWhereOrNull((element) => element.id == kCurrentLocationId);
      if (currentAddress != null) {
        _currentAddress(currentAddress);
      }
      final sortList = addressList.where((e) => e.id != kCurrentLocationId).toList();
      final recent = addressList.where((e) => e.id != kCurrentLocationId).toList();

      recent.sort((a, b) => DateTime.parse(b.createDateTime ?? '').compareTo(DateTime.parse(a.createDateTime ?? '')));

      // 편집 주소 리스트
      var getUserAddressEditIdList =  await _repository.getUserAddressEditIdList();
      getUserAddressEditIdList.when(
        success: (idList) {
          sortList.sort((a, b) => idList.indexOf(a.id!).compareTo(idList.indexOf(b.id!)));
          if (sortList.isNotEmpty) {
            sortList[sortList.indexOf(recent.first)].isRecent = true;
            _addressList(sortList);
          }
        },
        error: (Exception e) {
          logger.e(e);
        },
      );
    }, error: (Exception e) {
      logger.e(e);
    });


    _isLoading(false);
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

  Future _updateAddressCard(SearchAddress address, String searchText) async {
    String uuid =  const Uuid().v4();

    final newAddress = Address();
    newAddress.addressName = Utils().containsSearchText(address.addressName, searchText);
    newAddress.x = double.parse(address.x!);
    newAddress.y = double.parse(address.y!);
    newAddress.id = uuid;
    newAddress.createDateTime = DateTime.now().toLocal().toString();

    await _repository.updateUserAddressWithId(newAddress);
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

        _getData();
      }
    });
  }
}
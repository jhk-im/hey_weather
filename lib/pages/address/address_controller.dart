import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_snackbar.dart';
import 'package:hey_weather/common/shared_preferences_util.dart';
import 'package:hey_weather/getx/routes.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';
import 'package:hey_weather/repository/soruce/remote/model/search_address.dart';
import 'package:hey_weather/repository/soruce/weather_repository.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class AddressController extends GetxController {
  final WeatherRepository _repository = GetIt.I<WeatherRepository>();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxBool _isLocationGranted = false.obs;
  bool get isLocationGranted => _isLocationGranted.value;

  final Rxn<Address> _currentAddress = Rxn<Address>();
  Address? get currentAddress => _currentAddress.value;

  final RxList<Address> _addressList = <Address>[].obs;
  List<Address> get addressList => _addressList;

  final RxList<SearchAddress> _searchAddressList = <SearchAddress>[].obs;
  List<SearchAddress> get searchAddressList => _searchAddressList;

  final RxString _searchAddressText = ''.obs;
  String get searchAddressText => _searchAddressText.value;

  // input field
  TextEditingController textFieldController = TextEditingController();
  final _deBouncer = BehaviorSubject<String>();
  final focusNode = FocusNode();
  textFieldListener(String text) {
    _deBouncer.add(text);
  }

  resetTextField() {
    textFieldController.text = '';
    focusNode.unfocus();
    _searchAddressList.clear();
  }

  createSearchAddress(SearchAddress address) {
    resetTextField();
    _updateAddressCard(address);
  }

  selectAddress(Address address) async {
    if (address.id != null) {
      await SharedPreferencesUtil().setString(kCurrentAddressId, address.id!);
      Get.offAllNamed(Routes.routeHome);
    }
  }

  var logger = Logger();

  @override
  void onInit() {
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
  }

  @override
  void onClose() {
    _deBouncer.close();
    textFieldController.dispose();
    focusNode.dispose();
    super.onClose();
  }

  _checkPermissionStatus() async {
    var status = await Permission.location.status;
    _isLocationGranted(status.isGranted);
  }

  Future _getData() async {
    _isLoading(true);

    // 위치 권한 확인
    await _checkPermissionStatus();

    // 로컬 리스트
    var getAddressList =  await _repository.getAddressList();
    getAddressList.when(success: (addressList) async {

      var currentAddress = addressList.firstWhereOrNull((element) => element.id == kCurrentAddressId);
      if (currentAddress != null) {
        _currentAddress(currentAddress);
      }
      final sortList = addressList.where((e) => e.id != kCurrentAddressId).toList();

      // 내가 추가한 주소 리스트
      var getAddressSortIdList =  await _repository.getAddressSortIdList();
      getAddressSortIdList.when(
        success: (idList) {
          print(idList);
          print(sortList);
          sortList.sort((a, b) => idList.indexOf(b.id!).compareTo(idList.indexOf(a.id!)));
          _addressList(sortList);
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

  Future _updateAddressCard(SearchAddress address) async {
    String uuid =  const Uuid().v4();

    final newAddress = Address();
    newAddress.addressName = address.addressName;
    newAddress.x = double.parse(address.x!);
    newAddress.y = double.parse(address.y!);
    newAddress.id = uuid;

    await _repository.updateLocalAddressWithId(newAddress);

    final idList = addressList.map((e) => e.id!).toList();
    idList.add(uuid);

    await _repository.updateLocalAddressIdList(idList);

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
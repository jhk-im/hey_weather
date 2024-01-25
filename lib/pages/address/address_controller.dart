import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';
import 'package:hey_weather/repository/soruce/remote/model/search_address.dart';
import 'package:hey_weather/repository/soruce/weather_repository.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

class AddressController extends GetxController {
  final WeatherRepository _repository = GetIt.I<WeatherRepository>();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

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
  selectSearchAddress(SearchAddress address) {
    resetTextField();
  }

  resetTextField() {
    textFieldController.text = '';
    focusNode.unfocus();
    _searchAddressList.clear();
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


  Future _getData() async {
    _isLoading(true);

    var getAddressList =  await _repository.getAddressList();
    getAddressList.when(success: (addressList) async {
      _addressList(addressList);
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
}
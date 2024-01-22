import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hey_weather/common/hey_dialog.dart';
import 'package:hey_weather/repository/soruce/weather_repository.dart';

class HomeController extends GetxController {
  final WeatherRepository _repository = GetIt.I<WeatherRepository>();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxString _addressText = ''.obs;
  String get addressText => _addressText.value;

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

    var getAddress = await _repository.getAddressWithCoordinate();
    getAddress.when(success: (address) async {
      print('getData() -> $address');
      String depth1 = address.region1depthName ?? '';
      String depth2 = address.region2depthName ?? '';
      String depth3 = address.region3depthName ?? '';
      _addressText('$depth1 $depth2 $depth3');
    }, error: (Exception e) {
      print(e);
    });



    Future.delayed(const Duration(seconds: 1), () {
      _isLoading(false);
      showOnboardBottomSheet();
    });
  }
}
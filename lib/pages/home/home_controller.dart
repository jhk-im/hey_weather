import 'package:get/get.dart';
import 'package:hey_weather/common/hey_dialog.dart';

class HomeController extends GetxController {

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  showOnboardBottomSheet() {
    HeyDialog.showOnBoardingBottomSheet(Get.context!);
  }


  Future<void> getData() async {
    _isLoading(true);
    Future.delayed(const Duration(seconds: 1), () {
      _isLoading(false);
      showOnboardBottomSheet();
    });
  }
}
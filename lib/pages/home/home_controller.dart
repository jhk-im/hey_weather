import 'package:get/get.dart';

class HomeController extends GetxController {

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    _isLoading(true);
    Future.delayed(const Duration(seconds: 1), () {
      _isLoading(false);
    });
  }
}
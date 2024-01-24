import 'package:connectivity/connectivity.dart';

class Utils {
  static Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false; // No Internet Connection
    } else {
      return true; // Connected to the Internet
    }
  }
}
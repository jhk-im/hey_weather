import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static SharedPreferencesUtil? _instance;
  late SharedPreferences _prefs;

  factory SharedPreferencesUtil() {
    _instance ??= SharedPreferencesUtil._();
    return _instance!;
  }

  SharedPreferencesUtil._();

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }
}
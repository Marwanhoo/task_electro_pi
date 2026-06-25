import 'package:shared_preferences/shared_preferences.dart';

class AppCache {
  static late SharedPreferences preferences;

  static Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static Future<void> setString({
    required String key,
    required String value,
  }) async {
    await preferences.setString(key, value);
  }

  static String? getString({required String key}) {
    return preferences.getString(key);
  }

  static Future<void> setBool({
    required String key,
    required bool value,
  }) async {
    await preferences.setBool(key, value);
  }

  static bool? getBool({required String key}) {
    return preferences.getBool(key);
  }

  static Future<bool> remove({required String key}) async {
    return preferences.remove(key);
  }

  static Future<bool> clear() async {
    return preferences.clear();
  }
}

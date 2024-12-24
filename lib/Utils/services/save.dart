import 'package:shared_preferences/shared_preferences.dart';

class SaveService {
  static Future<dynamic> retrieve(String indexname) async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(indexname)) {
      return null;
    }
    return prefs.getString(indexname)!;
  }

  static Future<bool?> retrieveBool(String indexname) async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(indexname)) {
      return null;
    }
    return prefs.getBool(indexname)!;
  }

  static Future<void> save(String indexname, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(indexname, value);
  }

  static Future<void> saveBool(String indexname, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(indexname, value);
  }

  static Future<void> clear(String indexname) async {
    save(indexname, "");
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class LocaleRepository {
  static const String _key = 'selected_locale';
  final SharedPreferences prefs;

  LocaleRepository({required this.prefs}); // ✅ Constructor uses "prefs"

  Future<void> saveLocaleCode(String code) async {
    await prefs.setString(_key, code);
  }

  Future<String?> getSavedLocaleCode() async {
    return prefs.getString(_key);
  }
}

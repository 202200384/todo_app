import 'package:shared_preferences/shared_preferences.dart';

class settingService {

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkMode') ?? false;
  }

  Future<void> setDarkMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('LanguageCode') ?? 'en';
  }
  Future<void> setLanguage(String languageCode) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('LanguageCode',languageCode);
  }
}

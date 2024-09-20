import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfigProvider extends ChangeNotifier {
  String appLanguage = 'en';
  ThemeMode appTheme = ThemeMode.light;

  AppConfigProvider({required ThemeMode initialTheme, required String initialLanguage}){
    _loadSettings();
  }

  void changeLanguage(String newLanguage) async{
    if (appLanguage == newLanguage) {
      return;
    }
    appLanguage = newLanguage;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', appLanguage,);
  }

  void changeTheme(ThemeMode newMode) async{
    if (appTheme == newMode) {
      return;
    }
    appTheme = newMode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', appTheme == ThemeMode.dark);
  }

  bool isDarkMode() {
    return appTheme == ThemeMode.dark;

  }
  Future<void> _loadSettings() async{
    final prefs = await SharedPreferences.getInstance();

    if(prefs.getBool('isDarkMode')!=[]){
      appTheme = prefs.getBool('isDarkMode')! ? ThemeMode.dark : ThemeMode.light;
    }
    appLanguage = prefs.getString('languageCode') ?? 'en';
    notifyListeners();
  }
}

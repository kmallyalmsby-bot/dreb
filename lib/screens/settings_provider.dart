import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _isDark = false;
  Locale _locale = const Locale('ar');

  bool get isDark => _isDark;
  Locale get locale => _locale;

  SettingsProvider() {
    _loadFromPrefs();
  }

  void toggleTheme(bool value) async {
    _isDark = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', value);
  }

  void changeLanguage(String langCode) async {
    _locale = Locale(langCode);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', langCode);
  }

  _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('isDark') ?? false;
    String lang = prefs.getString('languageCode') ?? 'ar';
    _locale = Locale(lang);
    notifyListeners();
  }
}
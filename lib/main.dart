import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';

// 1. مدير الإعدادات (للثيم واللغة)
class SettingsProvider with ChangeNotifier {
  bool _isDark = false;
  Locale _locale = const Locale('ar'); // اللغة الافتراضية

  bool get isDark => _isDark;
  Locale get locale => _locale;

  SettingsProvider() {
    _loadFromPrefs();
  }

  // تغيير الثيم وحفظه محلياً
  void toggleTheme(bool value) async {
    _isDark = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', value);
  }

  // تغيير اللغة وحفظها محلياً
  void changeLanguage(String langCode) async {
    _locale = Locale(langCode);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', langCode);
  }

  // تحميل الإعدادات عند فتح التطبيق
  _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('isDark') ?? false;
    String lang = prefs.getString('languageCode') ?? 'ar';
    _locale = Locale(lang);
    notifyListeners();
  }
}

void main() {
  runApp(
    // تغليف التطبيق بالـ Provider
    ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
      child: const DarbApp(),
    ),
  );
}

class DarbApp extends StatelessWidget {
  const DarbApp({super.key});

  @override
  Widget build(BuildContext context) {
    // الاستماع لتغييرات الإعدادات
    final settings = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'درب للرحلات',
      
      // إعدادات اللغة
      locale: settings.locale,
      
      // إعدادات الثيم
      themeMode: settings.isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        fontFamily: 'Tajawal', 
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE6A440),
          primary: const Color(0xFFE6A440),
          brightness: Brightness.light,
        ),
      ),

      // ثيم الألوان الغامق
      darkTheme: ThemeData(
        fontFamily: 'Tajawal',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE6A440),
          primary: const Color(0xFFE6A440),
          brightness: Brightness.dark,
        ),
      ),

      home: const SplashScreen(), 
    );
  }
}
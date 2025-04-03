import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService {
  // Singleton instance
  static final LocalizationService _instance = LocalizationService._internal();
  
  factory LocalizationService() {
    return _instance;
  }
  
  LocalizationService._internal();
  
  // Current locale
  Locale _currentLocale = const Locale('en');
  
  Locale get currentLocale => _currentLocale;
  
  // Initialize the service
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode') ?? 'en';
    _currentLocale = Locale(languageCode);
  }
  
  // Change the app locale
  Future<void> changeLocale(BuildContext context, String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
    
    _currentLocale = Locale(languageCode);
    
    // This would be used if we implement the generated localization delegate
    // await S.load(_currentLocale);
  }
  
  // Get available languages
  List<Map<String, dynamic>> get availableLanguages => [
    {'name': 'English', 'languageCode': 'en'},
    {'name': 'Tamil', 'languageCode': 'ta'},
    {'name': 'Sinhala', 'languageCode': 'si'},
  ];
  
  // Get language name from code
  String getLanguageName(String languageCode) {
    final language = availableLanguages.firstWhere(
      (element) => element['languageCode'] == languageCode,
      orElse: () => {'name': 'English', 'languageCode': 'en'},
    );
    
    return language['name'];
  }
}

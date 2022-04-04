import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final changeTheme = ChangeNotifierProvider.autoDispose((ref) {
  return ChangeThemeState();
});

class ChangeThemeState extends ChangeNotifier {
  bool darkMode = false;
  SharedPreferences? _prefs;

  /*enableDarkMode() async {
    darkMode = true;
    _prefs = await SharedPreferences.getInstance();
    _prefs!.setBool('dark', darkMode);
    notifyListeners();
  }

  enableLightMode() async {
    darkMode = false;
    _prefs = await SharedPreferences.getInstance();
    _prefs!.setBool('dark', darkMode);
    notifyListeners();
  }*/

  changeTheme(bool value) async {
    darkMode = value;
    _prefs = await SharedPreferences.getInstance();
    _prefs!.setBool('dark', darkMode);
    notifyListeners();
  }

  getSavedTheme() async {
    _prefs = await SharedPreferences.getInstance();
    darkMode = _prefs!.getBool('dark') ?? false;
    notifyListeners();
  }
}

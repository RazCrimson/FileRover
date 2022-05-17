import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _showHiddenFiles = false, _darkMode = false;
  Color _appColor = const Color(0xFF0277BD);
  late final Future initialPreferenceLoad = refreshPreferences();

  Color get appColor => _appColor;

  bool get darkMode => _darkMode;

  bool get showHiddenFiles => _showHiddenFiles;

  set appColor(Color color) {
    _appColor = color;
    notifyListeners();
  }

  set darkMode(bool isDarkMode) {
    _darkMode = isDarkMode;
    notifyListeners();
  }

  set showHiddenFiles(bool showFiles) {
    _showHiddenFiles = showFiles;
    notifyListeners();
  }

  Future<void> refreshPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _darkMode = prefs.getBool("darkMode") ?? _darkMode;
    _appColor = Color(prefs.getInt("appColor") ?? _appColor.value);
    _showHiddenFiles = prefs.getBool("showHiddenFiles") ?? _showHiddenFiles;
    await writePreferences();
    notifyListeners();
  }

  Future<void> writePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("darkMode", _darkMode);
    await prefs.setInt("appColor", _appColor.value);
    await prefs.setBool("showHiddenFiles", _showHiddenFiles);
  }
}

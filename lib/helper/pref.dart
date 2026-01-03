import 'package:bill_n_stock/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Pref {
  static Future<void> saveStringValue(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String> getStringValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  static Future<void> saveIntValue(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  static Future<int> getIntValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }

  static Future<void> saveBoolValue(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool> getBoolValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static Future<void> removeValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> saveUserJsonValue(
    String key,
    Map<String, dynamic> value,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = jsonEncode(UserModel.fromJson(value));
    await prefs.setString(key, user);
  }

  static Future<UserModel> getUserModelValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> userMap = jsonDecode(prefs.getString(key) ?? "{}");
    return UserModel.fromJson(userMap);
  }

  Future<void> saveThemePreference(ThemeMode themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', themeMode.toString());
  }

  Future<ThemeMode> loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? themeString = prefs.getString('theme');
    if (themeString == ThemeMode.dark.toString()) {
      return ThemeMode.dark;
    }
    return ThemeMode.light;
  }
}

const loaderKey = ValueKey("loading_dialog");
bool isLoaderVisible = false;

/// An extension on [BuildContext] to utilize the power of [MediaQuery]
/// for responsive design
extension CustomSizer on BuildContext {
  // Provides a horizontally measured size respective to `width` and `viewportWidth`
  double getWidth(double designWidth, {double viewportWidth = 360}) =>
      MediaQuery.of(this).size.width * (designWidth / viewportWidth);

  // Provides a vertically measured size respective to `height` and `viewportHeight`
  double getHeigth(double designHeight, {double viewportHeight = 915}) =>
      MediaQuery.of(this).size.height * (designHeight / viewportHeight);

  // double getSize(double designWidth, double designHeight, {double viewportWidth = 360, double viewportHeight = 915,}) => MediaQuery.of(this).size

  // Provides width of the whole viewport
  double get deviceScreenWidth => MediaQuery.of(this).size.width;

  // Provides width of the height viewport
  double get deviceScreenHeigth => MediaQuery.of(this).size.height;

  // Provides width of the whole viewport
  double getFontSize(
    double fontSize, {
    double viewportHeight = 915,
    double viewportWidth = 360,
  }) =>
      (((MediaQuery.of(this).size.height * fontSize) / viewportHeight) +
          (MediaQuery.of(this).size.width * fontSize) / viewportWidth) /
      2;
}

enum PreferenceKey { isLogin, userData, userDetail }

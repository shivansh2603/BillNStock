import 'dart:developer';

import 'package:bill_n_stock/api/ApiManager.dart';
import 'package:flutter/material.dart';
import 'package:bill_n_stock/helper/Util.dart';
import 'package:bill_n_stock/api/ApiServices.dart';
import 'package:bill_n_stock/api/ApiResponseStatus.dart';
import 'package:bill_n_stock/home/home_screen.dart';
import 'package:bill_n_stock/helper/pref.dart';

class LoginState extends ChangeNotifier {
  bool isLoading = false;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool validate() {
    if (usernameController.text.trim().isEmpty) {
      Util.snackBarNew("Username required");
      return false;
    }
    if (passwordController.text.trim().isEmpty) {
      Util.snackBarNew("Password required");
      return false;
    }
    return true;
  }

  Future<void> signIn(BuildContext context) async {
    log("🚀 signIn() called");

    if (!validate()) {
      log("❌ Validation failed");
      return;
    }

    log("✅ Validation passed");

    isLoading = true;
    notifyListeners();

    final params = {
      "username": usernameController.text.trim(),
      "password": passwordController.text.trim(),
    };

    final result = await ApiServices.instance.makePostRequest(
      params,
      UrlEndPoint.login,
      context,
    );

    isLoading = false;

    switch (result) {
      case Success(value: final data):
        if (data["status"] == "ERROR") {
          Util.snackBarNew(data["responseMessage"] ?? "Login failed");
          return;
        }
        Pref.saveBoolValue(PreferenceKey.isLogin.toString(), true);
        Pref.saveUserJsonValue(PreferenceKey.userData.toString(), data["data"]);

        Util.snackBarNew("Login successful");

        if (!context.mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (_) => false,
        );

        break;

      case Failure(exception: final e):
        Util.snackBarNew(e.toString());
        break;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

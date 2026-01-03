import 'dart:developer';

import 'package:bill_n_stock/helper/Util.dart';
import 'package:bill_n_stock/api/ApiManager.dart';
import 'package:bill_n_stock/api/ApiResponseStatus.dart';
import 'package:bill_n_stock/api/ApiServices.dart';
import 'package:flutter/material.dart';

class CreateAccountState extends ChangeNotifier {
  bool isLoading = false;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool validate() {
    if (usernameController.text.trim().isEmpty) {
      Util.snackBarNew("Username required");
      return false;
    }

    if (contactNumberController.text.trim().isEmpty) {
      Util.snackBarNew("Mobile number required");
      return false;
    }

    if (passwordController.text.trim().isEmpty) {
      Util.snackBarNew("Password required");
      return false;
    }

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      Util.snackBarNew("Passwords do not match");
      return false;
    }

    return true;
  }

  Future<void> createAccount(BuildContext context) async {
    log("🚀 createAccount() called");

    if (!validate()) {
      log("❌ Validation failed");
      return;
    }

    isLoading = true;
    notifyListeners();

    final params = {
      "username": usernameController.text.trim(),
      "contactNumber": contactNumberController.text.trim(),
      "password": passwordController.text.trim(),
    };

    final result = await ApiServices.instance.makePostRequest(
      params,
      UrlEndPoint.register,
      context,
    );

    isLoading = false;

    switch (result) {
      case Success(value: final data):
        Util.snackBarNew(data["responseMessage"]);
        Navigator.pop(context); // back to login
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
    contactNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

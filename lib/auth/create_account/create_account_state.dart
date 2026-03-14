import 'dart:async';
import 'dart:developer';

import 'package:bill_n_stock/helper/Util.dart';
import 'package:bill_n_stock/api/ApiManager.dart';
import 'package:bill_n_stock/api/ApiResponseStatus.dart';
import 'package:bill_n_stock/api/ApiServices.dart';
import 'package:flutter/material.dart';

class CreateAccountState extends ChangeNotifier {
  BuildContext? _context;

  bool isLoading = false;
  bool showPassword = false;
  bool showConfirmPassword = false;
  Timer? _usernameDebounce;
  String? usernameError;
  bool isUsernameAvailable = true;
  Timer? _contactDebounce;
  String? contactError;
  bool isContactAvailable = true;

  final RegExp _usernameRegex = RegExp(r'^[a-zA-Z0-9_]{4,}$');

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  CreateAccountState() {
    usernameController.addListener(_onUsernameChanged);
    contactNumberController.addListener(_onContactChanged);
  }

  void setContext(BuildContext context) {
    _context = context;
  }

  void togglePassword() {
    showPassword = !showPassword;
    notifyListeners();
  }

  void toggleConfirmPassword() {
    showConfirmPassword = !showConfirmPassword;
    notifyListeners();
  }

  void _onUsernameChanged() {
    final username = usernameController.text.trim();

    if (username.contains(' ')) {
      usernameError = "Spaces are not allowed";
      isUsernameAvailable = false;
      notifyListeners();
      return;
    }
    if (!_usernameRegex.hasMatch(username)) {
      usernameError = "Min 4 chars. Only letters, numbers & underscore allowed";
      isUsernameAvailable = false;
      notifyListeners();
      return;
    }

    usernameError = null;

    _usernameDebounce?.cancel();
    _usernameDebounce = Timer(const Duration(milliseconds: 600), () {
      checkUsername(username, _context!);
    });
  }

  void _onContactChanged() {
    final contact = contactNumberController.text.trim();

    // Less than 10 digits → reset state
    if (contact.length < 10) {
      contactError = null;
      isContactAvailable = false;
      notifyListeners();
      return;
    }

    // Exactly 10 digits → validate
    _contactDebounce?.cancel();
    _contactDebounce = Timer(const Duration(milliseconds: 600), () {
      checkContactNumber(contact, _context!);
    });
  }

  bool get showUsernameAvailable =>
      usernameError == null &&
      isUsernameAvailable &&
      usernameController.text.trim().length >= 2;

  bool get showContactAvailable =>
      contactError == null &&
      isContactAvailable &&
      contactNumberController.text.length == 10;

  bool validate() {
    final contact = contactNumberController.text.trim();
    if (!isUsernameAvailable) {
      Util.snackBarNew("Username already exists");
      return false;
    }

    if (usernameController.text.trim().isEmpty) {
      Util.snackBarNew("Username required");
      return false;
    }

    if (contactNumberController.text.trim().isEmpty) {
      Util.snackBarNew("Mobile number required");
      return false;
    }

    if (contact.isEmpty) {
      Util.snackBarNew("Mobile number required");
      return false;
    }

    if (contact.length != 10) {
      Util.snackBarNew("Enter valid 10-digit mobile number");
      return false;
    }

    if (!isContactAvailable) {
      Util.snackBarNew("Mobile number already registered");
      return false;
    }

    if (passwordController.text.trim().isEmpty) {
      Util.snackBarNew("Password required");
      return false;
    }

    if (passwordController.text.contains(' ')) {
      Util.snackBarNew("Password cannot contain spaces");
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Util.snackBarNew("Passwords do not match");
      return false;
    }

    return true;
  }

  Future<void> checkUsername(String username, BuildContext context) async {
    final result = await ApiServices.instance.validateUsername(
      username,
      context,
    );

    switch (result) {
      case Success(value: final data):
        final exists = data["data"] == true;

        if (exists) {
          usernameError = "Username already exists";
          isUsernameAvailable = false;
        } else {
          usernameError = null;
          isUsernameAvailable = true;
        }
        break;

      case Failure():
        usernameError = "Unable to validate username";
        isUsernameAvailable = false;
        break;
    }

    notifyListeners();
  }

  Future<void> checkContactNumber(
    String contactNumber,
    BuildContext context,
  ) async {
    final result = await ApiServices.instance.validateContactNumber(
      contactNumber,
      context,
    );

    switch (result) {
      case Success(value: final data):
        final exists = data["data"] == true;

        if (exists) {
          contactError = "Mobile number already registered";
          isContactAvailable = false;
        } else {
          contactError = null;
          isContactAvailable = true;
        }
        break;

      case Failure():
        contactError = "Unable to validate mobile number";
        isContactAvailable = false;
        break;
    }

    notifyListeners();
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

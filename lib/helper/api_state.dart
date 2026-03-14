import 'package:flutter/material.dart';
import 'package:bill_n_stock/helper/pref.dart';
import 'package:bill_n_stock/auth/login/login.dart';
import 'package:bill_n_stock/presentation/home_screen.dart';

class AppStart extends StatefulWidget {
  const AppStart({super.key});

  @override
  State<AppStart> createState() => _AppStartState();
}

class _AppStartState extends State<AppStart> {
  bool? isLoggedIn;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final loggedIn = await Pref.getBoolValue(PreferenceKey.isLogin.toString());

    if (!mounted) return;

    setState(() {
      isLoggedIn = loggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ⏳ Loader while checking
    if (isLoggedIn == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 🚀 Decide screen
    return isLoggedIn! ? const HomeScreen() : const SignInPage();
  }
}

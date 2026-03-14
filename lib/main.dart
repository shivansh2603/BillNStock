import 'package:bill_n_stock/helper/api_state.dart';
import 'package:bill_n_stock/helper/commom/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configLoading(); // 🔥 REQUIRED
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Roboto',
      ),
      home: const AppStart(),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..backgroundColor = Colors.white
    ..indicatorColor = Colors.black
    ..textColor = Colors.black
    ..displayDuration = const Duration(milliseconds: 2000)
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorWidget = SizedBox(
      width: 120,
      height: 90,
      child: Lottie.asset(Assets.loader),
    )
    ..textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    )
    ..textPadding = const EdgeInsets.all(0)
    ..contentPadding = const EdgeInsets.only(bottom: 8)
    ..maskType = EasyLoadingMaskType.clear
    ..userInteractions = false
    ..dismissOnTap = false;
}

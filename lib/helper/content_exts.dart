import 'package:flutter/material.dart';

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
  double getFontSize(double fontSize,
          {double viewportHeight = 915, double viewportWidth = 360}) =>
      (((MediaQuery.of(this).size.height * fontSize) / viewportHeight) +
          (MediaQuery.of(this).size.width * fontSize) / viewportWidth) /
      2;
}

extension PADialogs on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  Future<void> showError(String errorMessage) async {
    if (errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          action: SnackBarAction(
            textColor: isDarkMode ? Colors.white : Colors.black,
            label: "Dismiss",
            onPressed: ScaffoldMessenger.of(this).hideCurrentSnackBar,
          ),
          backgroundColor: Theme.of(this).colorScheme.errorContainer,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

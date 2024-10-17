import 'package:flutter/material.dart';

enum SnackBarLevel {
  error,
  warning,
  success,
  info,
}

class SnackBarPage {
  final String title;
  final SnackBarLevel level;

  SnackBarPage({required this.title, required this.level});

  SnackBar build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalMargin = screenWidth * 0.3;

    return SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(title),
      showCloseIcon: true,
      backgroundColor: level == SnackBarLevel.error
          ? Colors.red
          : level == SnackBarLevel.warning
          ? Colors.orange
          : level == SnackBarLevel.success
          ? Colors.green
          : Colors.blue,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
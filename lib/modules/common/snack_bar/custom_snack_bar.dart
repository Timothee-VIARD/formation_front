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
    return SnackBar(
      duration: const Duration(seconds: 3),
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

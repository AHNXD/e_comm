import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomSnackBar {
  static void showMessage(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.w),
          ),
          margin: EdgeInsets.symmetric(horizontal: 0.1.w),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

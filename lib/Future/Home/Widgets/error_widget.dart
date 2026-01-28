import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart'; // Ensure AppColors is imported

class MyErrorWidget extends StatelessWidget {
  const MyErrorWidget({
    super.key,
    required this.msg,
    required this.onPressed,
  });

  final String msg;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Hug content vertically
          children: [
            // 1. Error Icon Circle
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_off_rounded, // or Icons.error_outline_rounded
                size: 40.sp,
                color: Colors.red[300],
              ),
            ),

            SizedBox(height: 2.h),

            // 2. Error Message
            Text(
              msg.tr(context).isEmpty ? msg : msg.tr(context),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
                height: 1.5, // Better line height for readability
              ),
            ),

            SizedBox(height: 2.h),

            // 3. Try Again Button
            OutlinedButton.icon(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor:
                    AppColors.buttonCategoryColor, // Text/Icon color
                side: BorderSide(
                    color: AppColors.buttonCategoryColor), // Border color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: Icon(Icons.refresh_rounded, size: 14.sp),
              label: Text(
                'try_again'.tr(context),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:zein_store/Utils/colors.dart'; // Ensure colors imported

class MyButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final bool isOutlined;
  final IconData? icon;
  final double? height;
  final double? fontSize;

  const MyButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppColors.buttonCategoryColor,
    this.isOutlined = false,
    this.icon,
    this.height,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 6.h,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.transparent : color,
          foregroundColor: isOutlined ? color : Colors.white,
          elevation: isOutlined ? 0 : 4,
          shadowColor: isOutlined ? null : color.withOpacity(0.4),
          side: isOutlined
              ? BorderSide(color: color, width: 1.5)
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Smoother radius
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Hug content
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16.sp),
              SizedBox(width: 2.w),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: fontSize ?? 11.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

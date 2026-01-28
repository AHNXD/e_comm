import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:zein_store/Utils/colors.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final double? size;
  final Color? color;
  final double? strokeWidth;

  const CustomCircularProgressIndicator({
    super.key,
    this.size,
    this.color,
    this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size ?? 25.sp, // Responsive default size
        width: size ?? 25.sp,
        child: CircularProgressIndicator(
          color: color ?? AppColors.primaryColors,
          // Adds a soft background track for a premium look
          backgroundColor: (color ?? AppColors.primaryColors).withOpacity(0.15),
          strokeWidth: strokeWidth ?? 3.5,
          // Rounded ends look much cleaner than the default flat edges
          strokeCap: StrokeCap.round,
        ),
      ),
    );
  }
}

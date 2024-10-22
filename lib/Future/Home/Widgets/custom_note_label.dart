import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../Utils/colors.dart';

class CustomNoteLabel extends StatelessWidget {
  const CustomNoteLabel({
    super.key,
    required this.noteText,
  });
  final String noteText;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
      padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 1.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.navBarColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 1.5.w,
          ),
          const Icon(
            Icons.gpp_maybe_outlined,
            color: AppColors.primaryColors,
            size: 27,
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              noteText,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

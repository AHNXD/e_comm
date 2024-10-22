import 'package:e_comm/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GrediantButtonWidget extends StatelessWidget {
  const GrediantButtonWidget(
      {super.key,
      required this.onPressed,
      required this.buttonText,
      this.fontWeight,
      this.size,
      this.hieght});
  final Function onPressed;
  final String buttonText;
  final FontWeight? fontWeight;
  final double? size;
  final double? hieght;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.w),
          gradient: const LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: AppColors.linearPrimaryColor)),
      child: MaterialButton(
        height: hieght,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.w)),
        // color: buttonColor,
        onPressed: () {
          onPressed();
        },
        child: Text(
          buttonText,
          style: TextStyle(
              color: Colors.white, fontSize: size!.sp, fontWeight: fontWeight),
        ),
      ),
    );
  }
}

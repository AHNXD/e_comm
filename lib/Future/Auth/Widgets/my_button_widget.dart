import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MyButtonWidget extends StatelessWidget {
  const MyButtonWidget(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.verticalHieght,
      required this.horizontalWidth, required this.color});
  final String text;
  final void Function() onPressed;
  final double verticalHieght;
  final double horizontalWidth;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: verticalHieght, horizontal: horizontalWidth),
      child: MaterialButton(
        color: color,
        height: 6.h,
        minWidth: double.infinity,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 12.sp),
        ),
      ),
    );
  }
}

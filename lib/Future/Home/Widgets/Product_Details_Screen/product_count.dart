import 'package:zein_store/Utils/colors.dart';
import 'package:zein_store/Utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class ProductCount extends StatefulWidget {
  const ProductCount({super.key});

  @override
  State<ProductCount> createState() => _ProductCountState();
}

class _ProductCountState extends State<ProductCount> {
  int number = 0;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      // margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      // padding: EdgeInsets.only(right: 1.w),
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      width: 27.w,
      height: 4.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(4.w)),
        color: Colors.white,
      ),
      duration: const Duration(seconds: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: SvgPicture.asset(
              AppImagesAssets.plus,
            ),
            onPressed: () {
              setState(() {
                number++;
              });
            },
          ),
          Text(
            number.toString(),
            textAlign: TextAlign.start,
            style: TextStyle(
                color: AppColors.textButtonColors,
                fontSize: 10.sp,
                fontWeight: FontWeight.w400),
          ),
          IconButton(
            icon: SvgPicture.asset(AppImagesAssets.minus),
            onPressed: () {
              setState(() {
                if (number > 0) {
                  number--;
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

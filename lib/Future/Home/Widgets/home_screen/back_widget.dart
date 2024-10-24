// ignore_for_file: deprecated_member_use

import 'package:e_comm/Future/Home/Pages/navbar_screen.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:e_comm/Utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class BackWidget extends StatelessWidget {
  const BackWidget(
      {super.key,
      required this.text,
      required this.iconColor,
      required this.textColor,
      required this.hasStyle,
      required this.hasBackButton,
      required this.canPop});
  final String text;
  final Color iconColor;
  final Color textColor;
  final bool hasStyle;
  final bool hasBackButton;
  final bool canPop;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      excludeHeaderSemantics: true,
      automaticallyImplyLeading: true,
      forceMaterialTransparency: true,
      leading: hasBackButton
          ? IconButton(
              style: hasStyle
                  ? ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => AppColors.buttonCategoryColor),
                    )
                  : null,
              onPressed: () {
                Navigator.pop(context, MaterialPageRoute(
                  builder: (builder) {
                    return const NavBarPage();
                  },
                ));
              },
              icon: SvgPicture.asset(
                AppImagesAssets.back,
                color: iconColor,
                height: 4.h,
              ),
              color: iconColor,
              iconSize: 25.sp,
            )
          : null,
      centerTitle: true,
      title: Text(
        text,
        style: TextStyle(
            color: textColor, fontSize: 15.sp, fontWeight: FontWeight.w500),
      ),
    );
    // Padding(
    //   padding: EdgeInsets.only(top: 4.h),
    //   child: Row(
    //     children: [
    //       if (hasBackButton)
    //         IconButton(
    //           style: hasStyle
    //               ? ButtonStyle(
    //                   backgroundColor: MaterialStateColor.resolveWith(
    //                       (states) => AppColors.buttonCategoryColor),
    //                 )
    //               : null,
    //           onPressed: () {
    //             Navigator.pop(context);
    //           },
    //           icon: SvgPicture.asset(
    //             AppImagesAssets.back,
    //             color: iconColor,
    //             height: 4.h,
    //           ),
    //           color: iconColor,
    //           iconSize: 25.sp,
    //         ),
    //       SizedBox(
    //         width: 1.w,
    //       ),
    //       Text(
    //         text,
    //         style: TextStyle(
    //             color: textColor, fontSize: 15.sp, fontWeight: FontWeight.w500),
    //       )
    //     ],
    //   ),
    // );
  }
}

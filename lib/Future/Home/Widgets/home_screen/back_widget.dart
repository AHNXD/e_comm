// ignore_for_file: deprecated_member_use

import 'package:zein_store/Future/Home/Pages/navbar_screen.dart';
import 'package:zein_store/Utils/colors.dart';
import 'package:zein_store/Utils/images.dart';
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
  }
}

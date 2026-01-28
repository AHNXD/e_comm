import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:zein_store/Utils/colors.dart';

class BackWidget extends StatelessWidget {
  const BackWidget({
    super.key,
    required this.text,
    required this.iconColor,
    required this.textColor,
    this.hasStyle = false,
    this.hasBackButton = true,
    this.canPop = true,
  });

  final String text;
  final Color iconColor;
  final Color textColor;
  final bool hasStyle;
  final bool hasBackButton;
  final bool canPop;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: (hasBackButton && canPop)
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: hasStyle
                      ? AppColors.buttonCategoryColor.withOpacity(0.1)
                      : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.zero, // Centers the icon better
                ),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: iconColor,
                  size: 16.sp,
                ),
              ),
            )
          : null,
      title: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

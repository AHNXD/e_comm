import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/constants.dart';
import 'package:e_comm/main.dart';

import '/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../Pages/search_product_screen.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: IconButton(
                onPressed: () {
                  scaffoldKey.currentState!.openDrawer();
                },
                icon: const Icon(Icons.menu)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "hello_msg".tr(context),
                style: TextStyle(color: Colors.black38, fontSize: 9.sp),
              ),
              Text(
                companyName,
                style: TextStyle(
                    color: AppColors.textTitleAppBarColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (builder) {
                  return const SearchProductScreen();
                }));
              },
            ),
          ),
        ],
      ),
    );
  }
}

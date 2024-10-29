// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/constants.dart';
import 'package:e_comm/main.dart';

import '../../Pages/search_product_screen.dart';
import '/Utils/colors.dart';

class AppBarWidget extends StatelessWidget {
  final bool isHome;
  final String title;
  const AppBarWidget({super.key, this.isHome = true, this.title = companyName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
          color: AppColors.primaryColors,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isHome
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: IconButton(
                      onPressed: () {
                        scaffoldKey.currentState!.openDrawer();
                      },
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                      )),
                )
              : const SizedBox(
                  // height: 32,
                  ),
          isHome
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "hello_msg".tr(context),
                      style: TextStyle(color: Colors.black, fontSize: 9.sp),
                    ),
                    Expanded(
                      child: Text(
                        companyName,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp),
                      ),
                    )
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(),
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp),
                    ),
                    const SizedBox()
                  ],
                ),
          isHome
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) {
                        return const SearchProductScreen();
                      }));
                    },
                  ),
                )
              : const SizedBox(
                  // height: 32,
                  ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';
import 'package:zein_store/Utils/constants.dart';
import 'package:zein_store/main.dart';
import '../../Pages/search_product_screen.dart';

class AppBarWidget extends StatelessWidget {
  final bool isHome;
  final String title;

  const AppBarWidget({super.key, this.isHome = true, this.title = companyName});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Add top margin to separate from status bar slightly if needed
      margin: EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h),
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColors,
        borderRadius: BorderRadius.circular(
            20), // Fully rounded corners looks more modern
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColors.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // --- Left Side (Menu or Spacer) ---
          SizedBox(
            width: 40,
            child: isHome
                ? IconButton(
                    onPressed: () => scaffoldKey.currentState!.openDrawer(),
                    icon: const Icon(Icons.menu_rounded, color: Colors.white),
                    tooltip: 'Menu',
                  )
                : null, // Empty for symmetry if not home
          ),

          // --- Center (Title/Greeting) ---
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Hug content
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isHome)
                  Text(
                    "hello_msg".tr(context),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8), // Softer white
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp, // Slightly smaller for elegance
                      letterSpacing: 0.5),
                ),
              ],
            ),
          ),

          // --- Right Side (Search or Spacer) ---
          SizedBox(
            width: 40,
            child: isHome
                ? IconButton(
                    icon: const Icon(Icons.search_rounded, color: Colors.white),
                    tooltip: 'Search',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return const SearchProductScreen();
                      }));
                    },
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

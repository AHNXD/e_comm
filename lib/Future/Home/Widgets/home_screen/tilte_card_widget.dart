import 'package:zein_store/Future/Home/Pages/product_screen.dart';
import 'package:zein_store/Future/Home/models/catigories_model.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TitleCardWidget extends StatelessWidget {
  const TitleCardWidget({super.key, required this.cData});
  final CatigoriesData cData;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            cData.name!,
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp),
          ),
          TextButton(
              child: Text(
                "see_all".tr(context),
                style: TextStyle(
                    color: AppColors.seeAllTextButtonColor, fontSize: 12.sp),
              ),
              onPressed: () {
                if (cData.id != 0) {
                  // context
                  //     .read<GetPorductByIdCubit>()
                  //     .getProductsByCategory(cData.id!);
                  Navigator.push(context, MaterialPageRoute(builder: (builder) {
                    return ProductScreen(
                      isNotHome: false,
                      cData: cData,
                    );
                  }));
                }
              })
        ],
      ),
    );
  }
}

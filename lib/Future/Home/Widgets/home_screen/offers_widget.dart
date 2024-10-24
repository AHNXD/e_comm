import 'package:e_comm/Apis/Urls.dart';
import 'package:e_comm/Future/Home/Pages/product_details.dart';
import 'package:e_comm/Future/Home/models/product_model.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../cached_network_image.dart';

class OffersWidget extends StatelessWidget {
  const OffersWidget({super.key, required this.data});
  final MainProduct data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DetailPage(
            product: data,
          );
        }));
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.w),
            color: AppColors.navBarColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyCachedNetworkImage(
              width: 45.w,
              height: 20.h,
              imageUrl: data.files!.first.path == null
                  ? data.files!.first.name!
                  : Urls.storageCategories + data.files!.first.name!,
            ),
            SizedBox(
              height: 1.h,
            ),
            Text(data.name!,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textButtonColors,
                  fontSize: 13.sp,
                )),
            SizedBox(
              height: 1.h,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      "${data.sellingPrice} ${"sp".tr(context)}",
                      style: TextStyle(
                          color: AppColors.textButtonColors,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w900,
                          decoration: TextDecoration.lineThrough),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "${data.offers!.priceAfterOffer} ${"sp".tr(context)}",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.red),
                      child: Text(
                        "${(1 - (double.tryParse(data.offers!.priceAfterOffer!)! / double.tryParse(data.offers!.priceAfterOffer!)!)) * 100}%",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

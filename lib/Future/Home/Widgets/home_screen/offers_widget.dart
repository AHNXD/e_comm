import 'package:e_comm/Apis/Urls.dart';
import 'package:e_comm/Future/Home/models/offers_catigories_model.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../cached_network_image.dart';

class OffersWidget extends StatelessWidget {
  const OffersWidget({super.key, required this.data});
  final OffersCatigoriesData data;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            width: 45.w, height: 20.h,
            imageUrl: data.category!.files!.first.path == null
                ? data.category!.files!.first.name!
                : Urls.storageCategories + data.category!.files!.first.name!,
            // height: 10.h,
          ),
          SizedBox(
            width: 4.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "What do you wating for",
                style: TextStyle(color: Colors.black, fontSize: 8.sp),
              ),
              Text(
                "30% off on your\n First Purchase",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}

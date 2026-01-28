import 'package:zein_store/Future/Home/models/product_model.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../Apis/Urls.dart';
import '../cached_network_image.dart';

class OrderTileWidget extends StatelessWidget {
  final MainProduct product;
  final String? size;
  final String? price;
  final int? qty;

  const OrderTileWidget({
    super.key,
    required this.qty,
    required this.product,
    required this.size,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.sp),
      // Note: Decoration is handled by the parent in the previous screen,
      // but we add a transparent color here to ensure touch events capture correctly
      color: Colors.transparent,
      child: Row(
        children: [
          // --- 1. Product Image ---
          Container(
            height: 8.h,
            width: 8.h, // Square aspect ratio
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F7), // Light grey bg for image
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: MyCachedNetworkImage(
                  imageUrl: product.files![0].path != null
                      ? Urls.storageProducts + product.files![0].name!
                      : product.files![0].name!,
                  height: 12.h,
                  width: 40.w,
                ),
              ),
            ),
          ),

          SizedBox(width: 3.w),

          // --- 2. Details Column ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Product Name
                Text(
                  product.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.2),
                ),

                SizedBox(height: 0.8.h),

                // Size Tag (if exists)
                if (size != null && size != "NULL" && size!.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "${'size'.tr(context)}: $size",
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                // Price
                Text(
                  "$price ${"sp".tr(context)}",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryColors,
                  ),
                ),
              ],
            ),
          ),

          // --- 3. Quantity Badge ---
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
            decoration: BoxDecoration(
              color: AppColors.primaryColors.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "x $qty",
              style: TextStyle(
                color: AppColors.primaryColors,
                fontWeight: FontWeight.bold,
                fontSize: 10.sp,
              ),
            ),
          )
        ],
      ),
    );
  }
}

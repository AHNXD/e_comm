import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../../Utils/colors.dart';

class MyCachedNetworkImage extends StatelessWidget {
  const MyCachedNetworkImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
  });
  final String imageUrl;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        placeholder: (context, url) => Center(
              child: Shimmer.fromColors(
                baseColor: AppColors.borderColor,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  height: 10.h,
                  width: width,
                  decoration: BoxDecoration(
                      border:
                          Border.all(width: 1, color: AppColors.borderColor),
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5.w)),
                ),
              ),
            ),
        imageBuilder: (context, imageProvider) => Container(
              margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
              decoration: BoxDecoration(
                  // color: Colors.white,
                  // border: Border.all(width: 1, color: AppColors.borderColor),
                  borderRadius: BorderRadius.circular(5.w),
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.fill)),
              height: 10.h,
              width: width,
            ),
        fadeInDuration: const Duration(milliseconds: 4),
        fadeOutDuration: const Duration(milliseconds: 4),
        imageUrl: imageUrl,
        errorWidget: (context, url, error) => Container(
            margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
            height: 10.h,
            width: width,
            decoration: BoxDecoration(
              // border: Border.all(width: 1, color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(5.w),
              boxShadow: const [
                BoxShadow(
                    color: AppColors.borderColor,
                    blurRadius: 3,
                    offset: Offset(1, 5))
              ],
              color: Colors.white,
            ),
            child: const Icon(
              Icons.error,
              color: Colors.red,
            )));
  }
}

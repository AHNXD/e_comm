import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import '../../../Utils/colors.dart'; // Keep your imports

class MyCachedNetworkImage extends StatelessWidget {
  const MyCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.margin,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      placeholder: (context, url) => Center(
        child: Shimmer.fromColors(
          baseColor: AppColors.borderColor,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: margin ?? EdgeInsets.symmetric(horizontal: 4.w),
            height: height,
            width: width,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: AppColors.borderColor),
              color: Colors.grey,
              borderRadius: borderRadius ?? BorderRadius.circular(5.w),
            ),
          ),
        ),
      ),
      // --- The Image Builder ---
      imageBuilder: (context, imageProvider) => Container(
        // Use the passed margin, or no margin by default
        margin: margin ?? EdgeInsets.zero,
        height: height,
        width: width,
        decoration: BoxDecoration(
          // Use the passed radius, or 0 by default
          borderRadius: borderRadius ?? BorderRadius.zero,
          image: DecorationImage(
            image: imageProvider,
            fit: fit, // Use the passed fit
          ),
        ),
      ),
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 300),
      imageUrl: imageUrl,
      // --- Error Widget ---
      errorWidget: (context, url, error) => Container(
        margin: margin ?? EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(5.w),
          boxShadow: const [
            BoxShadow(
                color: AppColors.borderColor,
                blurRadius: 3,
                offset: Offset(1, 5))
          ],
          color: Colors.white,
        ),
        child: const Icon(Icons.error, color: Colors.red),
      ),
    );
  }
}

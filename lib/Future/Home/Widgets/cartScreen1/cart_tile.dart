import 'package:zein_store/Future/Home/Pages/product_details.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';
import 'package:zein_store/Utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sizer/sizer.dart';
import '../../../../Apis/Urls.dart';
import '../../models/product_model.dart';
import '../cached_network_image.dart';
import 'qauntity_button.dart';

class CartTile extends StatelessWidget {
  final MainProduct product;
  final Function() onRemove;
  final Function() deleteProduct;
  final Function() onAdd;

  const CartTile({
    super.key,
    required this.product,
    required this.onRemove,
    required this.onAdd,
    required this.deleteProduct,
  });

  @override
  Widget build(BuildContext context) {
    bool isOffer = product.isOffer ?? false;

    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => DetailPage(product: product)));
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Product Image ---
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    color: const Color(
                        0xFFF5F5F7), // Light grey background for image
                    height: 100, // Fixed size
                    width: 100,
                    child: (product.files != null && product.files!.isNotEmpty)
                        ? MyCachedNetworkImage(
                            imageUrl: product.files![0].path != null
                                ? Urls.storageProducts + product.files![0].name!
                                : product.files![0].name!,
                            width: 12.h,
                            height: 30.w,
                          )
                        : Icon(Icons.image_not_supported,
                            color: Colors.grey[300]),
                  ),
                ),
                // Discount Badge on Image
                if (isOffer)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Text(
                        "SAVE".tr(context), // Or calculation
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 7.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(width: 3.w),

            // --- 2. Details Column ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Delete Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name ?? "Unknown Product",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textTitleAppBarColor,
                              height: 1.2),
                        ),
                      ),
                      // Delete Icon (Small and subtle)
                      InkWell(
                        onTap: deleteProduct,
                        child: Icon(Ionicons.trash_outline,
                            color: Colors.red[300], size: 18),
                      )
                    ],
                  ),

                  SizedBox(height: 0.5.h),

                  // Size Tag
                  if (product.selectedSize != null &&
                      product.selectedSize!.isNotEmpty &&
                      product.selectedSize != "NULL")
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "${'size'.tr(context)}: ${product.selectedSize}",
                        style:
                            TextStyle(fontSize: 8.sp, color: Colors.grey[600]),
                      ),
                    ),

                  SizedBox(height: 1.h),

                  // Price Row
                  Row(
                    children: [
                      if (isOffer) ...[
                        Text(
                          product.unit == "USD"
                              ? (double.tryParse(product.sellingPrice!)! *
                                      product.userQuantity)
                                  .toString()
                              : formatter.format(
                                  double.tryParse(product.sellingPrice!)! *
                                      product.userQuantity),
                          style: TextStyle(
                            color: Colors.grey[400],
                            decoration: TextDecoration.lineThrough,
                            fontSize: 9.sp,
                          ),
                        ),
                        SizedBox(width: 2.w),
                      ],
                      Text(
                        "${product.unit == "USD" ? (double.tryParse(isOffer ? product.offers!.priceAfterOffer! : product.sellingPrice!)! * product.userQuantity).toString() : formatter.format(double.tryParse(isOffer ? product.offers!.priceAfterOffer! : product.sellingPrice!)! * product.userQuantity)} ${product.unit!.tr(context)}",
                        style: TextStyle(
                          color: isOffer
                              ? const Color(0xFFDD2476)
                              : AppColors.textButtonColors,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- 3. Quantity Column (Right Side) ---
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                    height: 35), // Push down slightly to align with bottom
                QauntityButton(
                  product: product,
                  onAdd: onAdd,
                  onRemove: onRemove,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

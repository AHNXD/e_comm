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
import 'proudact_daitles_cart.dart';
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
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (builder) {
          return DetailPage(product: product);
        }));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
        padding: EdgeInsets.all(1.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: AppColors.primaryColors[400]!,
                blurRadius: 15,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyCachedNetworkImage(
                  height: 10.h,
                  width: 35.w,
                  imageUrl: product.files![0].path != null
                      ? Urls.storageProducts + product.files![0].name!
                      : product.files![0].name!,
                ),
                Expanded(
                  child: PrudoctDaitlesCart(
                    product: product,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.5.h),
            if (product.isOffer! == false)
              Text(
                "${formatter.format(double.tryParse(product.sellingPrice!)! * product.userQuantity)} ${"sp".tr(context)}",
                style: TextStyle(
                    color: AppColors.textButtonColors,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900),
              ),
            if (product.isOffer!)
              Column(
                children: [
                  Text(
                    "${formatter.format(double.parse(product.sellingPrice!).toInt())} ${"sp".tr(context)}",
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
                    "${formatter.format(double.tryParse(product.offers!.priceAfterOffer!)! * product.userQuantity)} ${"sp".tr(context)}",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            SizedBox(height: 1.5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                QauntityButton(
                  onRemove: onRemove,
                  product: product,
                  onAdd: onAdd,
                ),
                IconButton(
                  onPressed: deleteProduct,
                  icon: const Icon(
                    Ionicons.trash_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

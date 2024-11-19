import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/functions.dart';

import '../../Cubits/cartCubit/cart.bloc.dart';
import '../custom_snak_bar.dart';
import '/Future/Home/Cubits/favoriteCubit/favorite_cubit.dart';
import '/Apis/Urls.dart';
import '/Future/Home/Pages/product_details.dart';
import '/Future/Home/models/product_model.dart';
import '/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../cached_network_image.dart';

class ProductCardWidget extends StatefulWidget {
  const ProductCardWidget({
    super.key,
    required this.isHomeScreen,
    required this.product,
    this.addToCartPaddingButton,
  });
  final bool isHomeScreen;
  final MainProduct product;
  final double? addToCartPaddingButton;

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DetailPage(
            product: widget.product,
          );
        }));
      },
      child: Container(
        width: 65.w,
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: widget.product.isOffer!
                  ? Colors.red
                  : AppColors.primaryColors[400]!,
              blurRadius: 15,
              blurStyle: BlurStyle.solid,
              offset: const Offset(0, 4))
        ], borderRadius: BorderRadius.circular(5.w), color: Colors.white),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<FavoriteCubit, FavoriteState>(
                    builder: (context, state) {
                      return IconButton(
                          onPressed: () async {
                            widget.product.isFavorite = await context
                                .read<FavoriteCubit>()
                                .addAndDelFavoriteProducts(
                                  widget.product.id!,
                                );
                            setState(() {
                              massege(
                                  context,
                                  widget.product.isFavorite
                                      ? "added_fav".tr(context)
                                      : "removed_fav".tr(context),
                                  Colors.green);
                            });
                          },
                          icon: Icon(
                            widget.product.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            color: widget.product.isFavorite
                                ? AppColors.textTitleAppBarColor
                                : Colors.black,
                          ));
                    },
                  ),
                  widget.product.isOffer!
                      ? CircleAvatar(
                          radius: 15.sp,
                          backgroundColor: Colors.red,
                          child: Text(
                            "${(1 - (double.tryParse(widget.product.offers!.priceAfterOffer!)! / double.tryParse(widget.product.offers!.priceAfterOffer!)!)) * 100}%",
                            style: TextStyle(
                                fontSize: 9.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : const Spacer()
                ],
              ),
            ),
            if (widget.product.files != null)
              MyCachedNetworkImage(
                height: 12.h,
                width: 40.w,
                imageUrl: widget.product.files![0].path != null
                    ? Urls.storageProducts + widget.product.files![0].name!
                    : widget.product.files![0].name!,
                // height: 10.h,
              ),
            Text(widget.product.name!,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textButtonColors,
                  fontSize: 13.sp,
                )),
            const Spacer(),
            if (widget.product.isOffer! == false)
              Center(
                child: Text(
                  "${widget.product.sellingPrice} ${"sp".tr(context)}",
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                      color: AppColors.textButtonColors,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900),
                ),
              ),
            if (widget.product.isOffer!)
              Column(
                children: [
                  Text(
                    "${widget.product.sellingPrice} ${"sp".tr(context)}",
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        color: AppColors.textButtonColors,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w900,
                        decoration: TextDecoration.lineThrough),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Center(
                    child: Text(
                      "${widget.product.offers!.priceAfterOffer} ${"sp".tr(context)}",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: widget.addToCartPaddingButton ?? 10.w,
                  vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonCategoryColor,
                    minimumSize: Size(double.infinity, 6.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                  ),
                  onPressed: () {
                    if (widget.product.sizes != null &&
                        widget.product.sizes!.isNotEmpty) {
                      CustomSnackBar.showMessage(
                          context, "select_size".tr(context), Colors.red);
                    } else {
                      context
                          .read<CartCubit>()
                          .addToCart(widget.product, widget.isHomeScreen);
                    }
                  },
                  child: Text(
                    "add_to_cart".tr(context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

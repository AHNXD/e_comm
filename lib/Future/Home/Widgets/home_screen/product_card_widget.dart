import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/functions.dart';

import '../../Cubits/cartCubit/cart.bloc.dart';
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
  // int number = 0;
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showMessage(
      String message, Color color) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2.w)),
            margin: EdgeInsets.symmetric(horizontal: 0.1.w),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          duration: const Duration(seconds: 3)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return DetailPage(
            product: widget.product,
          );
        }));
      },
      child: Container(
        width: 65.w,
        margin: EdgeInsets.symmetric(horizontal: 0.4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.w),
            color: const Color.fromARGB(84, 168, 240, 249)),
        child: Column(
          children: [
            BlocBuilder<FavoriteCubit, FavoriteState>(
              builder: (context, state) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
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
                      )),
                );
              },
            ),
            if (widget.product.files != null)
              MyCachedNetworkImage(
                height: 25.h,
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
            // if (widget.product.weightMeasurement != null)
            //   Text(
            //       "${widget.product.wight} ${widget.product.weightMeasurement!.name}",
            //       style: TextStyle(
            //         color: Colors.black54,
            //         fontSize: 8.sp,
            //       )),
            SizedBox(
              height: 1.h,
            ),
            if (widget.product.newSellingPrice != null)
              Text(
                "${widget.product.newSellingPrice} ${"sp".tr(context)}",
                style: TextStyle(
                    color: AppColors.textButtonColors,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w900),
              ),

            // if (widget.product.newSellingPrice != null)
            //   SizedBox(
            //     height: 5.h,
            //     child: Stack(
            //       children: [
            //         Padding(
            //           padding:
            //               EdgeInsets.only(right: 17.w, top: 2.6.h, left: 4.w),
            //           child: Text(
            //             "${widget.product.newSellingPrice} ${"sp".tr(context)}",
            //             style: TextStyle(
            //                 color: AppColors.textButtonColors,
            //                 fontSize: 9.sp,
            //                 fontWeight: FontWeight.w900),
            //           ),
            //         ),
            //         Positioned(
            //           bottom: 2.h,
            //           left: 18.w,
            //           child: Text(
            //             "${widget.product.sellingPrice} ${"sp".tr(context)}",
            //             style: TextStyle(
            //                 decoration: TextDecoration.lineThrough,
            //                 color: AppColors.textButtonColors,
            //                 fontSize: 6.sp,
            //                 fontWeight: FontWeight.w600),
            //           ),
            //         ),
            //       ],
            //     ),
            //   )
            // else
            //   Text(
            //     "${widget.product.sellingPrice} ${"sp".tr(context)}",
            //     style: TextStyle(
            //         color: AppColors.textButtonColors,
            //         fontSize: 9.sp,
            //         fontWeight: FontWeight.w900),
            //   ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.addToCartPaddingButton ?? 10.w,
              ),
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
                      showMessage("select_size".tr(context), Colors.red);
                    } else {
                      context.read<CartCubit>().addToCart(widget.product);
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
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //       horizontal: widget.addToCartPaddingButton ?? 10.w),
            //   child: TextButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: AppColors.buttonCategoryColor,
            //       minimumSize: const Size(double.infinity, 55),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(25),
            //       ),
            //     ),
            //     onPressed: () {
            //       context.read<CartCubit>().addToCart(widget.product);
            //     },
            //     child: Text(
            //       "add_to_cart".tr(context),
            //       textAlign: TextAlign.center,
            //       style: const TextStyle(
            //         fontSize: 14,
            //         fontWeight: FontWeight.w600,
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

import 'package:e_comm/Utils/app_localizations.dart';
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

class FavCardProduct extends StatefulWidget {
  const FavCardProduct({
    super.key,
    required this.isHomeScreen,
    required this.product,
  });
  final bool isHomeScreen;
  final MainProduct product;

  @override
  State<FavCardProduct> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<FavCardProduct> {
  // int number = 0;

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
        width: 70.w,
        margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.w), color: Colors.white),
        child: Column(
          children: [
            BlocBuilder<FavoriteCubit, FavoriteState>(
              builder: (context, state) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      onPressed: () {
                        context.read<FavoriteCubit>().addAndDelFavoriteProducts(
                              widget.product.id!,
                            );

                        context.read<FavoriteCubit>().getProductsFavorite();
                      },
                      icon: const Icon(Icons.favorite,
                          color: AppColors.textTitleAppBarColor)),
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
                  fontSize: 15.sp,
                )),
            SizedBox(
              height: 1.h,
            ),
            Text(
              "${widget.product.sellingPrice} ${"sp".tr(context)}",
              style: TextStyle(
                  color: AppColors.textButtonColors,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w900),
            ),
            const SizedBox(
              height: 10,
            ),
            Material(
              color: AppColors.primaryColors,
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                onTap: () {
                  context.read<CartCubit>().addToCart(widget.product);
                },
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.37,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    "add_to_cart".tr(context),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
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

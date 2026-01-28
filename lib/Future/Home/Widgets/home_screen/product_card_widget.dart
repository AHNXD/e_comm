import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/functions.dart';
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
    required this.screen,
    this.addToCartPaddingButton,
  });

  final bool isHomeScreen;
  final MainProduct product;
  final double? addToCartPaddingButton;
  final String screen;

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  @override
  Widget build(BuildContext context) {
    // 1. Calculate Discount
    String discountPercent = "";
    bool hasDiscount = false;
    if (widget.product.isOffer == true &&
        widget.product.offers?.priceDiscount != null &&
        widget.product.sellingPrice != null) {
      try {
        double discount = double.parse(widget.product.offers!.priceDiscount!);
        double original = double.parse(widget.product.sellingPrice!);
        discountPercent = ((discount / original) * 100).toStringAsFixed(0);
        hasDiscount = true;
      } catch (e) {
        discountPercent = "0";
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DetailPage(product: widget.product);
        }));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), // More rounded modern look
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE0E0E0).withOpacity(0.5),
              blurRadius: 5,
              spreadRadius: 0,
              offset: const Offset(0, 4), // Soft drop shadow
            )
          ],
        ),
        child: Column(
          children: [
            // --- TOP SECTION: Image + Badges ---
            Stack(
              children: [
                // 1. Background placeholder for image
                Container(
                  height: 18.h, // Fixed height for image area
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F7), // Apple-style light grey bg
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: (widget.product.files != null &&
                            widget.product.files!.isNotEmpty)
                        ? Hero(
                            tag: widget.product.id.toString(),
                            child: MyCachedNetworkImage(
                              imageUrl: widget.product.files![0].path != null
                                  ? Urls.storageProducts +
                                      widget.product.files![0].name!
                                  : widget.product.files![0].name!,
                              height: 1.h,
                              width: 1.w,
                            ),
                          )
                        : Icon(Icons.image_not_supported,
                            color: Colors.grey[300], size: 40),
                  ),
                ),

                // 2. Discount Badge (Top Left)
                if (hasDiscount)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF512F), Color(0xFFDD2476)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        "$discountPercent%",
                        style: TextStyle(
                          fontSize: 7.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                // 3. Favorite Button (Top Right)
                Positioned(
                  top: 8,
                  right: 8,
                  child: BlocBuilder<FavoriteCubit, FavoriteState>(
                    builder: (context, state) {
                      return InkWell(
                        onTap: () async {
                          widget.product.isFav = await context
                              .read<FavoriteCubit>()
                              .addAndDelFavoriteProducts(widget.product.id!);
                          setState(() {
                            massege(
                                context,
                                widget.product.isFav!
                                    ? "added_fav".tr(context)
                                    : "removed_fav".tr(context),
                                Colors.green);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 5,
                              )
                            ],
                          ),
                          child: Icon(
                            widget.product.isFav!
                                ? Icons.favorite
                                : Icons.favorite_border_rounded,
                            color: widget.product.isFav!
                                ? const Color(0xFFFF512F)
                                : Colors.grey[400],
                            size: 16.sp,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // --- BOTTOM SECTION: Info & Action ---
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text Details
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Company / Brand
                        Text(
                          widget.product.companyName?.toUpperCase() ?? "",
                          style: TextStyle(
                            fontSize: 7.sp,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Product Name
                        Text(
                          widget.product.name!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: const Color(0xFF2D2D2D),
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),

                    // Price and Button Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Price Column
                        Expanded(child: _buildPriceSection(context)),

                        // Add to Cart Button (Small & Iconic)
                        _buildAddToCartButton(context),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSection(BuildContext context) {
    if (widget.product.isOffer == true) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${formatter.format(double.parse(widget.product.sellingPrice!).toInt())} ${"sp".tr(context)}",
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 8.sp,
              decoration: TextDecoration.lineThrough,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "${formatter.format(double.parse(widget.product.offers!.priceAfterOffer!).toInt())} ${"sp".tr(context)}",
            style: TextStyle(
              color: const Color(0xFFDD2476),
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      );
    } else {
      return Text(
        "${formatter.format(double.parse(widget.product.sellingPrice!).toInt())} ${"sp".tr(context)}",
        style: TextStyle(
          color: const Color(0xFF2D2D2D), // Dark Grey
          fontSize: 12.sp,
          fontWeight: FontWeight.w900,
        ),
      );
    }
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        bool isInCart =
            context.read<CartCubit>().pcw.any((p) => p.id == widget.product.id);

        return InkWell(
          onTap: () {
            if (widget.product.sizes != null &&
                widget.product.sizes!.isNotEmpty) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DetailPage(product: widget.product);
              }));
              CustomSnackBar.showMessage(
                  context, "select_size".tr(context), Colors.orange);
            } else {
              context
                  .read<CartCubit>()
                  .addToCart(p: widget.product, screen: widget.screen);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(isInCart ? 8 : 10),
            decoration: BoxDecoration(
              color: isInCart
                  ? Colors.green.shade50
                  : AppColors.buttonCategoryColor, // Or your primary color
              borderRadius: BorderRadius.circular(12),
              border:
                  isInCart ? Border.all(color: Colors.green, width: 1.5) : null,
              boxShadow: isInCart
                  ? []
                  : [
                      BoxShadow(
                        color: AppColors.buttonCategoryColor.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
            ),
            child: isInCart
                ? Icon(Icons.check, color: Colors.green, size: 14.sp)
                : Icon(Icons.add_shopping_cart_rounded,
                    color: Colors.white, size: 14.sp),
          ),
        );
      },
    );
  }
}

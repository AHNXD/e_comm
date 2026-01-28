import 'package:carousel_slider/carousel_slider.dart';
import 'package:zein_store/Apis/Urls.dart';
import 'package:zein_store/Future/Home/Blocs/get_favorite/get_favorite_bloc.dart';
import 'package:zein_store/Future/Home/models/product_model.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';
import 'package:zein_store/Utils/functions.dart';
import 'package:zein_store/Utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:ui'; // For ImageFilter

import '../Cubits/cartCubit/cart.bloc.dart';
import '../Cubits/favoriteCubit/favorite_cubit.dart';
import '../Widgets/custom_snak_bar.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
    required this.product,
  });
  final MainProduct product;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _currentImageIndex = 0;
  int? selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    // 1. Determine if offer exists
    bool isOffer = widget.product.isOffer ?? false;
    double price = double.tryParse(widget.product.sellingPrice!) ?? 0;
    double offerPrice = 0;
    String discountPercent = "0";

    if (isOffer) {
      offerPrice =
          double.tryParse(widget.product.offers!.priceAfterOffer!) ?? 0;
      discountPercent =
          ((double.tryParse(widget.product.offers!.priceDiscount!)! / price) *
                  100)
              .toStringAsFixed(0);
    }

    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is AddToCartState) {
          CustomSnackBar.showMessage(
              context, 'add_product_done'.tr(context), Colors.green);
        } else if (state is AlreadyInCartState) {
          CustomSnackBar.showMessage(
              context, 'product_in_cart'.tr(context), Colors.grey);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // --- 1. Top Image Carousel ---
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 50.h, // Takes top half
              child: _buildImageCarousel(),
            ),

            // --- 2. Floating Header Buttons (Back & Fav) ---
            Positioned(
              top: 6.h,
              left: 4.w,
              right: 4.w,
              child: _buildHeaderButtons(),
            ),

            // --- 3. Product Details Sheet ---
            Positioned.fill(
              top: 42.h, // Overlaps image slightly
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(35)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    )
                  ],
                ),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                      6.w, 4.h, 6.w, 15.h), // Bottom padding for FAB
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Handle Bar (Visual cue)
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // Brand & Rating Row (Optional placeholder)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.product.companyName?.toUpperCase() ?? "BRAND",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontSize: 10.sp,
                          ),
                        ),
                        if (isOffer)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "$discountPercent%",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 9.sp,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 1.h),

                    // Product Name
                    Text(
                      widget.product.name!,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // Price Section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isOffer
                              ? "${formatter.format(offerPrice.toInt())} ${"sp".tr(context)}"
                              : "${formatter.format(price.toInt())} ${"sp".tr(context)}",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w900,
                            color: AppColors
                                .buttonCategoryColor, // Or primary color
                          ),
                        ),
                        if (isOffer) ...[
                          SizedBox(width: 3.w),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              "${formatter.format(price.toInt())} ${"sp".tr(context)}",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ]
                      ],
                    ),

                    Divider(height: 4.h, thickness: 1, color: Colors.grey[100]),

                    // Size Selector
                    if (widget.product.sizes != null &&
                        widget.product.sizes!.isNotEmpty) ...[
                      Text(
                        'sizes'.tr(context),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      SizedBox(
                        height: 50,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.product.sizes!.length,
                          separatorBuilder: (_, __) => SizedBox(width: 3.w),
                          itemBuilder: (context, index) {
                            bool isSelected = selectedIndex == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.buttonCategoryColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.buttonCategoryColor
                                        : Colors.grey[300]!,
                                    width: 1.5,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: AppColors.buttonCategoryColor
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          )
                                        ]
                                      : [],
                                ),
                                child: Text(
                                  widget.product.sizes![index],
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 3.h),
                    ],

                    // Description
                    Text(
                      "description".tr(
                          context), // Ensure you have this key or hardcode "Description"
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      widget.product.descrption!,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[600],
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // --- 4. Sticky Bottom Action Bar ---
        bottomNavigationBar: Container(
          padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 4.h),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            )
          ]),
          child: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              bool isInCart = context
                  .read<CartCubit>()
                  .pcw
                  .any((p) => p.id == widget.product.id);

              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isInCart ? Colors.green : AppColors.buttonCategoryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  shadowColor:
                      (isInCart ? Colors.green : AppColors.buttonCategoryColor)
                          .withOpacity(0.4),
                ),
                onPressed: () {
                  if (widget.product.sizes != null &&
                      widget.product.sizes!.isNotEmpty) {
                    if (selectedIndex == -1) {
                      CustomSnackBar.showMessage(
                          context, "select_size".tr(context), Colors.red);
                    } else {
                      widget.product.selectedSize =
                          widget.product.sizes![selectedIndex!];
                      context.read<CartCubit>().addToCart(
                          p: widget.product, screen: "product", size: true);
                    }
                  } else {
                    context
                        .read<CartCubit>()
                        .addToCart(p: widget.product, screen: "product");
                    setState(() {});
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                        isInCart
                            ? Icons.check_circle
                            : Icons.shopping_bag_rounded,
                        size: 18.sp),
                    SizedBox(width: 3.w),
                    Text(
                      isInCart
                          ? "item_in_cart".tr(context)
                          : "add_to_cart".tr(context),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildImageCarousel() {
    // Check if files exist
    bool hasImages =
        widget.product.files != null && widget.product.files!.isNotEmpty;

    return Stack(
      children: [
        // The Carousel
        Container(
          color: const Color(0xFFF5F5F7), // Background for transparent images
          child: CarouselSlider(
            items: hasImages
                ? widget.product.files!.map((file) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FullScreenImageViewer(file: file),
                          ),
                        );
                      },
                      child: Center(
                        child: Hero(
                          tag: widget.product.id
                              .toString(), // Add Hero transition if Home has same tag
                          child: Image.network(
                            file.path != null
                                ? Urls.storageProducts + file.name!
                                : file.name!,
                            fit: BoxFit
                                .contain, // Contain ensures the whole product is seen
                            width: 100.w,
                          ),
                        ),
                      ),
                    );
                  }).toList()
                : [
                    Center(
                      child: Image.asset(AppImagesAssets.logo, width: 50.w),
                    )
                  ],
            options: CarouselOptions(
              height: 50.h,
              viewportFraction: 1.0,
              enableInfiniteScroll: hasImages,
              autoPlay: hasImages,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
            ),
          ),
        ),

        // Dots Indicator (Floating at bottom of image area)
        if (hasImages && widget.product.files!.length > 1)
          Positioned(
            bottom: 10.h, // Position above the white sheet overlap
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.product.files!.asMap().entries.map((entry) {
                return Container(
                  width: _currentImageIndex == entry.key ? 20.0 : 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentImageIndex == entry.key
                        ? AppColors.buttonCategoryColor
                        : Colors.grey.withOpacity(0.4),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildHeaderButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Button
        _glassButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.pop(context),
        ),

        // Favorite Button
        BlocBuilder<GetFavoriteBloc, GetFavoriteState>(
          builder: (context, state) {
            bool isFav = widget.product.isFav ?? false;
            return _glassButton(
              icon: isFav ? Icons.favorite : Icons.favorite_border_rounded,
              color: isFav ? Colors.red : Colors.black87,
              onTap: () async {
                widget.product.isFav = await context
                    .read<FavoriteCubit>()
                    .addAndDelFavoriteProducts(widget.product.id!);
                setState(() {});
                massege(
                    context,
                    widget.product.isFav!
                        ? "added_fav".tr(context)
                        : "removed_fav".tr(context),
                    Colors.green);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _glassButton(
      {required IconData icon,
      required VoidCallback onTap,
      Color color = Colors.black87}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
            ),
            child: Icon(icon, color: color, size: 18.sp),
          ),
        ),
      ),
    );
  }
}

// Full Screen Viewer (Kept as requested)
class FullScreenImageViewer extends StatelessWidget {
  final Files file;

  const FullScreenImageViewer({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(
            file.path != null ? Urls.storageProducts + file.name! : file.name!,
          ),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
        ),
      ),
    );
  }
}

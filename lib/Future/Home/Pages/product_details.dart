import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_comm/Apis/Urls.dart';
import 'package:e_comm/Future/Home/models/product_model.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:e_comm/Utils/functions.dart';
import 'package:e_comm/Utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

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
  int? selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: AppColors.primaryColors,
        body: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            detailItemsHeader(),
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 150,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        ),
                      ),
                    ),
                  ),
                  CarouselSlider(
                    items: widget.product.files != null
                        ? widget.product.files!.map((file) {
                            return SizedBox(child: detailImage(file));
                          }).toList()
                        : [
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: AppColors.primaryColors[400]!,
                                        blurRadius: 15,
                                        offset: const Offset(0, 8))
                                  ],
                                  borderRadius: BorderRadius.circular(250),
                                ),
                                child: CircleAvatar(
                                    radius: 25.w,
                                    backgroundImage:
                                        const AssetImage(AppImagesAssets.logo)),
                              ),
                            )
                          ],
                    options: CarouselOptions(
                        height: 300,
                        autoPlay: true,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 500),
                        initialPage: 0,
                        enableInfiniteScroll: false),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // For name
                            Center(
                              child: Text(
                                widget.product.name!,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 34),
                              ),
                            ),
                            // For price
                            if (widget.product.isOffer! == false)
                              Center(
                                child: Text(
                                  '${widget.product.sellingPrice} ${"sp".tr(context)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: AppColors.primaryColors),
                                ),
                              ),
                            if (widget.product.isOffer!)
                              Column(
                                children: [
                                  Center(
                                    child: Text(
                                      '${widget.product.sellingPrice} ${"sp".tr(context)}',
                                      style: const TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: AppColors.primaryColors),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${widget.product.offers!.priceAfterOffer} ${"sp".tr(context)}",
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      CircleAvatar(
                                        radius: 18.sp,
                                        backgroundColor: Colors.red,
                                        child: Text(
                                          "${(1 - (double.tryParse(widget.product.offers!.priceAfterOffer!)! / double.tryParse(widget.product.offers!.priceAfterOffer!)!)) * 100}%",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 27,
                  ),

                  Text(
                    widget.product.descrption!,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  // For add to cart button
                  const SizedBox(
                    height: 25,
                  ),
                  if (widget.product.sizes != null &&
                      widget.product.sizes!.isNotEmpty)
                    Row(
                      children: [
                        const Text(
                          'Sizes: ',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.product.sizes!.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                      // widget.product.selectedSize =
                                      //     widget.product.sizes![index];
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: selectedIndex == index
                                          ? AppColors.primaryColors
                                          : Colors.grey.shade200,
                                      child: Text(
                                        widget.product.sizes![index],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: selectedIndex == index
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonCategoryColor,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      if (widget.product.sizes != null &&
                          widget.product.sizes!.isNotEmpty) {
                        if (selectedIndex == -1) {
                          CustomSnackBar.showMessage(
                              context, "select_size".tr(context), Colors.red);
                        } else {
                          context.read<CartCubit>().addToCartWithSize(
                              widget.product,
                              widget.product.sizes![selectedIndex!]);
                        }
                      } else {
                        context
                            .read<CartCubit>()
                            .addToCart(widget.product, false);
                      }
                    },
                    child: Text(
                      "add_to_cart".tr(context),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget detailImage(Files file) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: AppColors.primaryColors[400]!,
                blurRadius: 15,
                offset: const Offset(0, 8))
          ],
          borderRadius: BorderRadius.circular(250),
        ),
        child: CircleAvatar(
            radius: 25.w,
            backgroundImage: NetworkImage(
              file.path != null
                  ? Urls.storageProducts + file.name!
                  : file.name!,
            )),
      ),
    );
  }

  Padding detailItemsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          // For back button
          Material(
            color: Colors.white.withOpacity(0.21),
            borderRadius: BorderRadius.circular(10),
            child: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
              // onPressed: () => setState(() {
              //   Navigator.pushReplacement(context,
              //       MaterialPageRoute(builder: (builder) {
              //     return const NavBarPage();
              //   }));
              // }),
              color: Colors.white,
            ),
          ),
          const Spacer(),
          // For detail food
          Text(
            "product_detail_screen_title".tr(context),
            style: const TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const Spacer(),

          InkWell(
            onTap: () async {
              bool result = await context
                  .read<FavoriteCubit>()
                  .addAndDelFavoriteProducts(widget.product.id!);
              setState(() {
                widget.product.isFavorite = result;
              });
              massege(
                  context,
                  result ? "added_fav".tr(context) : "removed_fav".tr(context),
                  Colors.green);
            },
            child: Material(
              color: Colors.white.withOpacity(0.21),
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  child: Icon(
                    widget.product.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    color: widget.product.isFavorite
                        ? AppColors.textTitleAppBarColor
                        : Colors.black,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
// design is completed

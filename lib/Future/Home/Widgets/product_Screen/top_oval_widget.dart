import 'package:e_comm/Future/Home/Widgets/home_screen/back_widget.dart';
import 'package:e_comm/Future/Home/Widgets/home_screen/categories_button_widget.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../Cubits/get_min_max_cubit/get_min_max_cubit.dart';
import '../../Cubits/searchProductByCatId/search_product_by_category_id_cubit.dart';

class TopOvalWidget extends StatefulWidget {
  const TopOvalWidget({
    super.key,
    required this.firstText,
    required this.parentId,
    required this.isNotHome,
  });
  final String firstText;
  final int parentId;
  final bool isNotHome;

  @override
  State<TopOvalWidget> createState() => _TopOvalWidgetState();
}

class _TopOvalWidgetState extends State<TopOvalWidget> {
  late TextEditingController searchController;
  late TextEditingController minPriceController;
  late TextEditingController maxPriceController;

  int currentStep = 0;

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController();
    minPriceController = TextEditingController();
    maxPriceController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    minPriceController.dispose();
    maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    double selectHeight(screenHeight) {
      if (screenWidth > 280 && screenWidth < 450) {
        return screenHeight * 0.46;
      } else if (screenWidth >= 450 && screenWidth < 600) {
        return screenHeight * 0.6;
      } else if (screenWidth >= 600 && screenWidth < 900) {
        return screenHeight * 0.7;
      }
      return screenHeight * 0.9;
    }

    return ClipPath(
      clipBehavior: Clip.hardEdge,
      clipper: CoustomClipPath(),
      child: Container(
        margin: EdgeInsets.zero,
        color: AppColors.offersContainerColor,
        height: selectHeight(screenHeight),
        child: Column(
          children: [
            BackWidget(
              canPop: widget.isNotHome,
              hasBackButton: true,
              hasStyle: false,
              iconColor: Colors.white,
              textColor: Colors.white,
              text: "products".tr(context),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => currentStep = 0),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        currentStep == 0 ? AppColors.navBarColor : Colors.white,
                  ),
                  child: const Text('Search'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => setState(() => currentStep = 1),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: currentStep == 1
                          ? AppColors.navBarColor
                          : Colors.white),
                  child: const Text('Filter'),
                ),
              ],
            ),
            if (currentStep == 0)
              ShearchProductField(
                controller: searchController,
                widget: widget,
              ),
            if (currentStep == 1)
              FilterProductWdiget(
                minPriceController: minPriceController,
                maxPriceController: maxPriceController,
                cateogryId: widget.parentId,
              ),

            // Categories section
            SizedBox(
              height: 8.h,
              child: CategoriesButtonWidget(
                parentId: widget.parentId,
                firstText: widget.firstText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShearchProductField extends StatelessWidget {
  const ShearchProductField({
    super.key,
    required this.controller,
    required this.widget,
  });

  final TextEditingController controller;
  final TopOvalWidget widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.3.h),
      child: TextFormField(
        controller: controller,
        onChanged: (value) {
          value = controller.text;
        },
        onFieldSubmitted: (value) {
          context
              .read<SearchProductByCategoryIdCubit>()
              .searchProductsByCategories(value, widget.parentId);
        },
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
            hintText: "search_product_hint".tr(context),
            hintStyle: const TextStyle(
              color: Colors.black54,
            ),
            filled: true,
            suffixIcon: IconButton(
              onPressed: () {
                controller.clear();
                context
                    .read<SearchProductByCategoryIdCubit>()
                    .searchProductsByCategories('', widget.parentId);
              },
              icon: const Icon(
                textDirection: TextDirection.ltr,
                Icons.close,
                color: AppColors.buttonCategoryColor,
              ),
            ),
            prefixIcon: IconButton(
              onPressed: () {
                context
                    .read<SearchProductByCategoryIdCubit>()
                    .searchProductsByCategories(
                        controller.text, widget.parentId);
              },
              icon: const Icon(
                textDirection: TextDirection.ltr,
                Icons.search,
                color: AppColors.buttonCategoryColor,
              ),
            ),
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(6.w))),
      ),
    );
  }
}

class FilterProductWdiget extends StatelessWidget {
  const FilterProductWdiget({
    super.key,
    required this.minPriceController,
    required this.maxPriceController,
    required this.cateogryId,
  });

  final TextEditingController minPriceController;
  final TextEditingController maxPriceController;
  final int cateogryId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetMinMaxCubit, GetMinMaxState>(
        builder: (context, state) {
      String minP = context.read<GetMinMaxCubit>().minPrice ?? "";
      String maxP = context.read<GetMinMaxCubit>().maxPrice ?? "";
      minPriceController.text = minP;
      maxPriceController.text = maxP;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: minPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'min_price'.tr(context),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.w),
                  ),
                ),
                style: TextStyle(fontSize: 10.sp),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: maxPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'max_price'.tr(context),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.w),
                  ),
                ),
                style: TextStyle(fontSize: 10.sp),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  double? minPrice = double.tryParse(minPriceController.text);
                  double? maxPrice = double.tryParse(maxPriceController.text);
                  if (minPrice != null && maxPrice != null) {
                    if (minPrice <= maxPrice) {
                      context
                          .read<SearchProductByCategoryIdCubit>()
                          .filterProductByPrice(minPrice, maxPrice, cateogryId);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                              "invalid_price_range".tr(context),
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red),
                      );
                    }
                  } else if (minPrice != null && maxPrice == null) {
                    context
                        .read<SearchProductByCategoryIdCubit>()
                        .filterProductByPrice(
                            minPrice, double.parse(maxP), cateogryId);
                  } else if (minPrice == null && maxPrice != null) {
                    context
                        .read<SearchProductByCategoryIdCubit>()
                        .filterProductByPrice(
                            double.tryParse(minP), maxPrice, cateogryId);
                  } else {
                    context
                        .read<SearchProductByCategoryIdCubit>()
                        .filterProductByPrice(double.tryParse(minP),
                            double.parse(maxP), cateogryId);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.w),
                  ),
                ),
                child: Text(
                  "apply".tr(context),
                  style: TextStyle(fontSize: 10.sp),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class CoustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height + 4.h;
    final Path path = Path();
    double heightOffset = height * 0.25;
    path.lineTo(0, height - heightOffset);
    path.quadraticBezierTo(
      width * 0.5,
      height,
      width,
      height - heightOffset,
    );
    path.lineTo(width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CoustomDownClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;
    final Path path = Path();

    path.lineTo(0, height);
    path.quadraticBezierTo(
      width * 0.5,
      height - 11.h,
      width,
      height,
    );
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

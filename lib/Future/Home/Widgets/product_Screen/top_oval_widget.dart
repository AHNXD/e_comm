import 'package:e_comm/Future/Auth/Widgets/text_field_widget.dart';
import 'package:e_comm/Future/Home/Blocs/search_filter_products/search_filter_poducts_bloc.dart';
import 'package:e_comm/Future/Home/Cubits/mange_search_filter_products/mange_search_filter_products_cubit.dart';
import 'package:e_comm/Future/Home/Widgets/home_screen/back_widget.dart';
import 'package:e_comm/Future/Home/Widgets/home_screen/categories_button_widget.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../Blocs/get_products_by_cat_id/get_products_by_cat_id_bloc.dart';
import '../../Cubits/get_min_max_cubit/get_min_max_cubit.dart';

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
        return screenHeight * 0.48;
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
                  onPressed: () {
                    setState(() => currentStep = 0);
                    if (context
                        .read<MangeSearchFilterProductsCubit>()
                        .isFilterProducts) {
                      searchController.clear();
                      resetSearch(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        currentStep == 0 ? AppColors.navBarColor : Colors.white,
                  ),
                  child: Text('search'.tr(context)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() => currentStep = 1);
                    if (context
                        .read<MangeSearchFilterProductsCubit>()
                        .isSearchProducts) {
                      resetFilter(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: currentStep == 1
                          ? AppColors.navBarColor
                          : Colors.white),
                  child: Text('filter'.tr(context)),
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
                categoryId: widget.parentId,
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

  void resetFilter(BuildContext context) {
    context.read<SearchFilterPoductsBloc>().add(ResetSearchFilterToInit());
    context.read<GetProductsByCatIdBloc>().add(ResetPagination());
    context
        .read<GetProductsByCatIdBloc>()
        .add(GetAllPoductsByCatIdEvent(categoryID: widget.parentId));
    context.read<MangeSearchFilterProductsCubit>().isSearchProducts = false;
  }

  void resetSearch(BuildContext context) {
    context.read<SearchFilterPoductsBloc>().add(ResetSearchFilterToInit());
    context.read<GetProductsByCatIdBloc>().add(ResetPagination());
    context
        .read<GetProductsByCatIdBloc>()
        .add(GetAllPoductsByCatIdEvent(categoryID: widget.parentId));
    context.read<MangeSearchFilterProductsCubit>().isFilterProducts = false;
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
          if (value.isNotEmpty && value.trim() != "") {
            startSearch(context, value);
          }
          // context
          //     .read<SearchProductByCategoryIdCubit>()
          //     .searchProductsByCategories(value, widget.parentId);
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
                if (controller.text.isNotEmpty &&
                    controller.text.trim() != "") {
                  controller.clear();
                  resetSearch(context);
                }
              },
              icon: const Icon(
                textDirection: TextDirection.ltr,
                Icons.close,
                color: AppColors.buttonCategoryColor,
              ),
            ),
            prefixIcon: IconButton(
              onPressed: () {
                if (controller.text.isNotEmpty &&
                    controller.text.trim() != "") {
                  startSearch(context, controller.text);
                }
                // context
                //     .read<SearchProductByCategoryIdCubit>()
                //     .searchProductsByCategories(
                //         controller.text, widget.parentId);
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

  void startSearch(BuildContext context, String value) {
    context.read<SearchFilterPoductsBloc>().add(ResetSearchFilter());
    context
        .read<SearchFilterPoductsBloc>()
        .add(SearchProductsByCatId(widget.parentId, searchText: value));
    context.read<MangeSearchFilterProductsCubit>().isSearchProducts = true;
    context.read<MangeSearchFilterProductsCubit>().searchText = value;
  }

  void resetSearch(BuildContext context) {
    context.read<SearchFilterPoductsBloc>().add(ResetSearchFilterToInit());
    context.read<GetProductsByCatIdBloc>().add(ResetPagination());
    context
        .read<GetProductsByCatIdBloc>()
        .add(GetAllPoductsByCatIdEvent(categoryID: widget.parentId));
    context.read<MangeSearchFilterProductsCubit>().isSearchProducts = false;
  }
}

class FilterProductWdiget extends StatelessWidget {
  const FilterProductWdiget({
    super.key,
    required this.minPriceController,
    required this.maxPriceController,
    required this.categoryId,
  });

  final TextEditingController minPriceController;
  final TextEditingController maxPriceController;
  final int categoryId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetMinMaxCubit, GetMinMaxState>(
        builder: (context, state) {
      String minP = context.read<GetMinMaxCubit>().minPrice ?? "";
      String maxP = context.read<GetMinMaxCubit>().maxPrice ?? "";
      minPriceController.text = minP;
      maxPriceController.text = maxP;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(32)),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFieldWidget(
                  text: 'min_price'.tr(context),
                  isPassword: false,
                  controller: minPriceController,
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                flex: 3,
                child: TextFieldWidget(
                  text: 'max_price'.tr(context),
                  isPassword: false,
                  controller: maxPriceController,
                  keyboardType: TextInputType.number,
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
                        startFilter(context, minPrice, maxPrice);
                        // context
                        //     .read<SearchProductByCategoryIdCubit>()
                        //     .filterProductByPrice(
                        //         minPrice, maxPrice, cateogryId);
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
                      startFilter(context, minPrice, double.tryParse(maxP)!);
                      // context
                      //     .read<SearchProductByCategoryIdCubit>()
                      //     .filterProductByPrice(
                      //         minPrice, double.parse(maxP), cateogryId);
                    } else if (minPrice == null && maxPrice != null) {
                      startFilter(context, double.tryParse(minP)!, maxPrice);
                      // context
                      //     .read<SearchProductByCategoryIdCubit>()
                      //     .filterProductByPrice(
                      //         double.tryParse(minP), maxPrice, cateogryId);
                    } else {
                      startFilter(context, double.tryParse(minP)!,
                          double.tryParse(maxP)!);
                      // context
                      //     .read<SearchProductByCategoryIdCubit>()
                      //     .filterProductByPrice(double.tryParse(minP),
                      //         double.parse(maxP), cateogryId);
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
        ),
      );
    });
  }

  void startFilter(BuildContext context, double minPrice, double maxPrice) {
    context.read<SearchFilterPoductsBloc>().add(ResetSearchFilter());
    context
        .read<SearchFilterPoductsBloc>()
        .add(FilterProductsByCatId(categoryId, min: minPrice, max: maxPrice));
    context.read<MangeSearchFilterProductsCubit>().isFilterProducts = true;
    context.read<MangeSearchFilterProductsCubit>().min = minPrice;
    context.read<MangeSearchFilterProductsCubit>().max = maxPrice;
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

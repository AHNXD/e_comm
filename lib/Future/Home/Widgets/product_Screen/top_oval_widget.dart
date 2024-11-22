import 'package:e_comm/Future/Home/Blocs/search_filter_products/search_filter_poducts_bloc.dart';
import 'package:e_comm/Future/Home/Cubits/cancel_filter/cancel_filter_button_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/mange_search_filter_products/mange_search_filter_products_cubit.dart';
import 'package:e_comm/Future/Home/Widgets/home_screen/back_widget.dart';
import 'package:e_comm/Future/Home/Widgets/home_screen/categories_button_widget.dart';
import 'package:e_comm/Future/Home/models/catigories_model.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../Blocs/get_products_by_cat_id/get_products_by_cat_id_bloc.dart';
import 'filter_product_field.dart';
import 'search_product_field.dart';

class TopOvalWidget extends StatefulWidget {
  const TopOvalWidget(
      {super.key,
      required this.firstText,
      required this.parentId,
      required this.isNotHome,
      required this.children});
  final String firstText;
  final int parentId;
  final bool isNotHome;
  final List<CatigoriesData> children;

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
    // final screenSize = MediaQuery.of(context).size;
    // final screenHeight = screenSize.height;
    // final screenWidth = screenSize.width;

    // double selectHeight(screenHeight) {
    //   if (screenWidth > 280 && screenWidth < 450) {
    //     return screenHeight * 0.48;
    //   } else if (screenWidth >= 450 && screenWidth < 600) {
    //     return screenHeight * 0.6;
    //   } else if (screenWidth >= 600 && screenWidth < 900) {
    //     return screenHeight * 0.7;
    //   }
    //   return screenHeight * 0.9;
    // }

    return Container(
      color: AppColors.offersContainerColor,
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
                  context.read<CancelFilterButtonCubit>().setIsFilter();
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
            FilterProductField(
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
                children: widget.children),
          ),
        ],
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
// class CoustomClipPath extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     double width = size.width;
//     double height = size.height + 4.h;
//     final Path path = Path();
//     double heightOffset = height * 0.25;
//     path.lineTo(0, height - heightOffset);
//     path.quadraticBezierTo(
//       width * 0.5,
//       height,
//       width,
//       height - heightOffset,
//     );
//     path.lineTo(width, 0);

//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }

// class CoustomDownClipPath extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     double width = size.width;
//     double height = size.height;
//     final Path path = Path();

//     path.lineTo(0, height);
//     path.quadraticBezierTo(
//       width * 0.5,
//       height - 11.h,
//       width,
//       height,
//     );
//     path.lineTo(width, 0);
//     path.close();

//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }

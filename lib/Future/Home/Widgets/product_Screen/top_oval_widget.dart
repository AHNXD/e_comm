import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:zein_store/Future/Home/Blocs/get_products_by_cat_id/get_products_by_cat_id_bloc.dart';
import 'package:zein_store/Future/Home/Blocs/search_filter_products/search_filter_poducts_bloc.dart';
import 'package:zein_store/Future/Home/Cubits/cancel_filter/cancel_filter_button_cubit.dart';
import 'package:zein_store/Future/Home/Cubits/mange_search_filter_products/mange_search_filter_products_cubit.dart';
import 'package:zein_store/Future/Home/Widgets/home_screen/back_widget.dart';
import 'package:zein_store/Future/Home/Widgets/home_screen/categories_button_widget.dart';
import 'package:zein_store/Future/Home/models/catigories_model.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';

import 'filter_product_field.dart';
import 'search_product_field.dart';

class TopOvalWidget extends StatefulWidget {
  const TopOvalWidget({
    super.key,
    required this.firstText,
    required this.parentId,
    required this.isNotHome,
    required this.children,
  });

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
    return Container(
      padding: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColors, // Using primary color for header background
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Back Button & Title
            BackWidget(
              canPop: widget.isNotHome,
              hasBackButton: true,
              hasStyle: false,
              iconColor: Colors.white,
              textColor: Colors.white,
              text: "products".tr(context),
            ),
            
            SizedBox(height: 1.h),

            // Toggle Buttons (Search / Filter)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  _buildToggleButton(0, 'search'.tr(context)),
                  _buildToggleButton(1, 'filter'.tr(context)),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Input Fields
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: currentStep == 0
                  ? ShearchProductField(controller: searchController, widget: widget)
                  : FilterProductField(
                      minPriceController: minPriceController,
                      maxPriceController: maxPriceController,
                      categoryId: widget.parentId,
                    ),
            ),

            SizedBox(height: 2.h),

            // Horizontal Categories List
            SizedBox(
              height: 5.h, // Fixed height for pills
              child: CategoriesButtonWidget(
                parentId: widget.parentId,
                firstText: widget.firstText,
                children: widget.children,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(int index, String text) {
    bool isSelected = currentStep == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => currentStep = index);
          if (index == 0) {
            // Switched to Search
            if (context.read<MangeSearchFilterProductsCubit>().isFilterProducts) {
              searchController.clear();
              resetSearch(context);
            }
          } else {
            // Switched to Filter
            if (context.read<MangeSearchFilterProductsCubit>().isSearchProducts) {
              resetFilter(context);
            }
            context.read<CancelFilterButtonCubit>().setIsFilter();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black12, blurRadius: 4)] : [],
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? AppColors.primaryColors : Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 10.sp,
            ),
          ),
        ),
      ),
    );
  }

  void resetFilter(BuildContext context) {
    context.read<SearchFilterPoductsBloc>().add(ResetSearchFilterToInit());
    context.read<GetProductsByCatIdBloc>().add(ResetPagination());
    context.read<GetProductsByCatIdBloc>().add(GetAllPoductsByCatIdEvent(categoryID: widget.parentId));
    context.read<MangeSearchFilterProductsCubit>().isSearchProducts = false;
  }

  void resetSearch(BuildContext context) {
    context.read<SearchFilterPoductsBloc>().add(ResetSearchFilterToInit());
    context.read<GetProductsByCatIdBloc>().add(ResetPagination());
    context.read<GetProductsByCatIdBloc>().add(GetAllPoductsByCatIdEvent(categoryID: widget.parentId));
    context.read<MangeSearchFilterProductsCubit>().isFilterProducts = false;
  }
}
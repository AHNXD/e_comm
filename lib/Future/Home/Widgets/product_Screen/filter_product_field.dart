import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:zein_store/Future/Home/Widgets/custom_snak_bar.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';
import '../../Blocs/get_products_by_cat_id/get_products_by_cat_id_bloc.dart';
import '../../Blocs/search_filter_products/search_filter_poducts_bloc.dart';
import '../../Cubits/cancel_filter/cancel_filter_button_cubit.dart';
import '../../Cubits/get_min_max_cubit/get_min_max_cubit.dart';
import '../../Cubits/mange_search_filter_products/mange_search_filter_products_cubit.dart';

class FilterProductField extends StatelessWidget {
  const FilterProductField({
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
        
        // Only set text if empty to avoid overwriting user input
        if (minPriceController.text.isEmpty) minPriceController.text = minP;
        if (maxPriceController.text.isEmpty) maxPriceController.text = maxP;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildPriceInput(context, 'min_price'.tr(context), minPriceController),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("-", style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                ),
                Expanded(
                  flex: 3,
                  child: _buildPriceInput(context, 'max_price'.tr(context), maxPriceController),
                ),
                SizedBox(width: 2.w),
                BlocBuilder<CancelFilterButtonCubit, CancelFilterButtonState>(
                  builder: (context, state) {
                    bool isFiltering = state is! CancelFilterButtonIsNotFillter;
                    return ElevatedButton(
                      onPressed: () => filterOnPressed(context, maxP, minP),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonCategoryColor, // Or secondary color
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        elevation: 0,
                      ),
                      child: Text(
                        isFiltering ? "cancel".tr(context) : "apply".tr(context),
                        style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPriceInput(BuildContext context, String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        context.read<CancelFilterButtonCubit>().setIsFilter();
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 10.sp, color: Colors.grey[400]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        isDense: true,
      ),
    );
  }

  void filterOnPressed(BuildContext context, String maxP, String minP) {
    // Logic remains same
    if (context.read<CancelFilterButtonCubit>().isFilter) {
      double? minPrice = double.tryParse(minPriceController.text);
      double? maxPrice = double.tryParse(maxPriceController.text);
      
      // Default to API min/max if null
      double finalMin = minPrice ?? double.tryParse(minP) ?? 0;
      double finalMax = maxPrice ?? double.tryParse(maxP) ?? 999999;

      if (finalMin <= finalMax) {
        startFilter(context, finalMin, finalMax);
        context.read<CancelFilterButtonCubit>().setCancelFilter();
      } else {
        CustomSnackBar.showMessage(context, "invalid_price_range".tr(context), Colors.red);
      }
    } else {
      cancelFilter(context);
      minPriceController.text = minP;
      maxPriceController.text = maxP;
    }
  }

  void startFilter(BuildContext context, double minPrice, double maxPrice) {
    context.read<SearchFilterPoductsBloc>().add(ResetSearchFilter());
    context.read<SearchFilterPoductsBloc>().add(FilterProductsByCatId(categoryId, min: minPrice, max: maxPrice));
    context.read<MangeSearchFilterProductsCubit>().isFilterProducts = true;
    context.read<MangeSearchFilterProductsCubit>().min = minPrice;
    context.read<MangeSearchFilterProductsCubit>().max = maxPrice;
  }

  void cancelFilter(BuildContext context) {
    context.read<SearchFilterPoductsBloc>().add(ResetSearchFilterToInit());
    context.read<GetProductsByCatIdBloc>().add(ResetPagination());
    context.read<GetProductsByCatIdBloc>().add(GetAllPoductsByCatIdEvent(categoryID: categoryId));
    context.read<MangeSearchFilterProductsCubit>().isSearchProducts = false;
    context.read<MangeSearchFilterProductsCubit>().isFilterProducts = false;
    context.read<CancelFilterButtonCubit>().setIsFilter();
  }
}
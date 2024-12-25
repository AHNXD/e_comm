import 'package:e_comm/Future/Home/Widgets/custom_snak_bar.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../Auth/Widgets/text_field_widget.dart';
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
                  onChange: (value) {
                    if (value != null && minPriceController.text.isNotEmpty) {
                      context.read<CancelFilterButtonCubit>().setIsFilter();
                    }
                  },
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
                  onChange: (value) {
                    if (value != null && maxPriceController.text.isNotEmpty) {
                      context.read<CancelFilterButtonCubit>().setIsFilter();
                    }
                  },
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
                    FilterOnPressed(context, maxP, minP);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.w),
                    ),
                  ),
                  child: BlocBuilder<CancelFilterButtonCubit,
                      CancelFilterButtonState>(
                    builder: (context, state) {
                      if (state is CancelFilterButtonIsNotFillter) {
                        return Text(
                          "cancel".tr(context),
                          style: TextStyle(fontSize: 10.sp),
                        );
                      }
                      return Text(
                        "apply".tr(context),
                        style: TextStyle(fontSize: 10.sp),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void FilterOnPressed(BuildContext context, String maxP, String minP) {
    if (context.read<CancelFilterButtonCubit>().isFilter) {
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
          CustomSnackBar.showMessage(
              context, "invalid_price_range".tr(context), Colors.red);
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
        startFilter(context, double.tryParse(minP)!, double.tryParse(maxP)!);
        // context
        //     .read<SearchProductByCategoryIdCubit>()
        //     .filterProductByPrice(double.tryParse(minP),
        //         double.parse(maxP), cateogryId);
      }
      context.read<CancelFilterButtonCubit>().setCancelFilter();
    } else if (!context.read<CancelFilterButtonCubit>().isFilter) {
      cancelFilter(context);
      minPriceController.text = minP;
      maxPriceController.text = maxP;
    }
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

  void cancelFilter(BuildContext context) {
    context.read<SearchFilterPoductsBloc>().add(ResetSearchFilterToInit());
    context.read<GetProductsByCatIdBloc>().add(ResetPagination());
    context
        .read<GetProductsByCatIdBloc>()
        .add(GetAllPoductsByCatIdEvent(categoryID: categoryId));
    context.read<MangeSearchFilterProductsCubit>().isSearchProducts = false;
    context.read<MangeSearchFilterProductsCubit>().isFilterProducts = false;
    context.read<CancelFilterButtonCubit>().setIsFilter();
  }
}

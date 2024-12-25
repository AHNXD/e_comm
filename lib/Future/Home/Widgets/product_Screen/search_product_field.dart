import 'package:e_comm/Utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../Utils/colors.dart';
import '../../Blocs/get_products_by_cat_id/get_products_by_cat_id_bloc.dart';
import '../../Blocs/search_filter_products/search_filter_poducts_bloc.dart';
import '../../Cubits/mange_search_filter_products/mange_search_filter_products_cubit.dart';
import 'top_oval_widget.dart';

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

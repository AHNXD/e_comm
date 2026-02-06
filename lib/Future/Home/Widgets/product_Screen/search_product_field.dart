import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: TextFormField(
        controller: controller,
        textInputAction: TextInputAction.search,
        onFieldSubmitted: (value) {
          if (value.isNotEmpty && value.trim() != "") {
            startSearch(context, value);
          }
        },
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: "search_product_hint".tr(context),
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 11.sp),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          prefixIcon:
              const Icon(Icons.search_rounded, color: AppColors.primaryColors),
          suffixIcon: IconButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                controller.clear();
                resetSearch(context);
              }
            },
            icon: const Icon(Icons.close_rounded, color: Colors.grey),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
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

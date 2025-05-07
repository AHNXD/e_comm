import 'package:zein_store/Future/Home/Blocs/get_products_by_cat_id/get_products_by_cat_id_bloc.dart';
import 'package:zein_store/Future/Home/Blocs/search_filter_products/search_filter_poducts_bloc.dart';
import 'package:zein_store/Future/Home/Cubits/mange_search_filter_products/mange_search_filter_products_cubit.dart';
import 'package:zein_store/Future/Home/Widgets/custom_lazy_load_grid_view.dart';
import 'package:zein_store/Future/Home/Widgets/error_widget.dart';
import 'package:zein_store/Future/Home/Widgets/home_screen/product_card_widget.dart';

import 'package:zein_store/Utils/app_localizations.dart';

import '../Widgets/custom_circular_progress_indicator.dart';

import '../models/catigories_model.dart';
import '/Future/Home/Widgets/product_Screen/top_oval_widget.dart';
import '/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
// import 'package:syncfusion_flutter_sliders/sliders.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen(
      {super.key, required this.cData, required this.isNotHome});
  // final int clickIndex;
  final CatigoriesData cData;
  final bool isNotHome;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late ScrollController scrollController;
  @override
  void initState() {
    scrollController = ScrollController();

    // context.read<GetProductsByCatIdBloc>().add(ResetPagination());
    // context
    //     .read<GetProductsByCatIdBloc>()
    //     .add(GetAllPoductsByCatIdEvent(categoryID: widget.cData.id!));
    // context.read<MangeSearchFilterProductsCubit>().isSearchProducts = false;
    // context.read<MangeSearchFilterProductsCubit>().isFilterProducts = false;
    // context.read<GetMinMaxCubit>().getMinMax(widget.cData.id);
    // context.read<SearchFilterPoductsBloc>().add(ResetSearchFilterToInit());

    scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    final currentScroll = scrollController.offset;
    final maxScroll = scrollController.position.maxScrollExtent;
    final bool isSearch =
        context.read<MangeSearchFilterProductsCubit>().isSearchProducts;
    final bool isFilter =
        context.read<MangeSearchFilterProductsCubit>().isFilterProducts;

    if (currentScroll >= (maxScroll * 0.9)) {
      if (!isSearch && !isFilter) {
        context
            .read<GetProductsByCatIdBloc>()
            .add(GetAllPoductsByCatIdEvent(categoryID: widget.cData.id!));
      } else if (isSearch && !isFilter) {
        final searchText =
            context.read<MangeSearchFilterProductsCubit>().searchText;
        context.read<SearchFilterPoductsBloc>().add(
            SearchProductsByCatId(widget.cData.id!, searchText: searchText!));
      }
      if (isFilter && !isSearch) {
        final min = context.read<MangeSearchFilterProductsCubit>().min;
        final max = context.read<MangeSearchFilterProductsCubit>().max;
        context
            .read<SearchFilterPoductsBloc>()
            .add(FilterProductsByCatId(widget.cData.id!, min: min!, max: max!));
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          TopOvalWidget(
              isNotHome: widget.isNotHome,
              firstText: widget.cData.name!,
              parentId: widget.cData.id!,
              children: widget.cData.children ?? []),
          Expanded(
            child: ListView(
              controller: scrollController,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: [
                BlocBuilder<SearchFilterPoductsBloc, SearchFilterPoductsState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case SearchFilterProductsStatus.loading:
                        return const Center(
                            child: CustomCircularProgressIndicator());
                      case SearchFilterProductsStatus.error:
                        return MyErrorWidget(
                            msg: state.errorMsg, onPressed: () {});
                      case SearchFilterProductsStatus.success:
                        if (state.products.isEmpty) {
                          return Center(
                            child: Text(
                              "there_are_no_results_found".tr(context),
                            ),
                          );
                        }
                        return CustomLazyLoadGridView(
                            items: state.products,
                            hasReachedMax: state.hasReachedMax,
                            itemBuilder: (context, product) =>
                                ProductCardWidget(
                                    isHomeScreen: false,
                                    product: product,
                                    addToCartPaddingButton: 3.w,
                                    screen: "cat"));
                      case SearchFilterProductsStatus.init:
                        return CategoriesGrid(categoryId: widget.cData.id!);
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({
    super.key,
    required this.categoryId,
  });

  final int categoryId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetProductsByCatIdBloc, GetProductsByCatIdState>(
      builder: (context, state) {
        switch (state.status) {
          case GetProductsByCatIdStatus.loading:
            return const Center(
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CustomCircularProgressIndicator()),
            );
          case GetProductsByCatIdStatus.success:
            return CustomLazyLoadGridView(
                items: state.products,
                hasReachedMax: state.hasReachedMax,
                itemBuilder: (context, product) => ProductCardWidget(
                    isHomeScreen: false,
                    product: product,
                    addToCartPaddingButton: 3.w,
                    screen: "cat"));
          case GetProductsByCatIdStatus.error:
            return MyErrorWidget(
                msg: state.errorMsg,
                onPressed: () {
                  context.read<GetProductsByCatIdBloc>().add(ResetPagination());
                  context
                      .read<GetProductsByCatIdBloc>()
                      .add(GetAllPoductsByCatIdEvent(categoryID: categoryId));
                });
        }
      },
    );
  }
}

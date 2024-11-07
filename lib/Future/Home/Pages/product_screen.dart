import 'package:e_comm/Future/Home/Blocs/get_products_by_cat_id/get_products_by_cat_id_bloc.dart';
import 'package:e_comm/Future/Home/Blocs/search_filter_products/search_filter_poducts_bloc.dart';
import 'package:e_comm/Future/Home/Cubits/get_min_max_cubit/get_min_max_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/mange_search_filter_products/mange_search_filter_products_cubit.dart';
import 'package:e_comm/Future/Home/Widgets/custom_lazy_load_grid_view.dart';
import 'package:e_comm/Future/Home/Widgets/error_widget.dart';
import 'package:e_comm/Future/Home/Widgets/home_screen/product_card_widget.dart';

import 'package:e_comm/Utils/app_localizations.dart';
import '../Cubits/cartCubit/cart.bloc.dart';
import '../Widgets/scroll_top_button.dart';
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
    //context.read<GetPorductByIdCubit>().getProductsByCategory(widget.cData.id!);
    context.read<GetProductsByCatIdBloc>().add(ResetPagination());
    context
        .read<GetProductsByCatIdBloc>()
        .add(GetAllPoductsByCatIdEvent(categoryID: widget.cData.id!));
    context.read<GetMinMaxCubit>().getMinMax(widget.cData.id);
    context.read<SearchFilterPoductsBloc>().add(ResetSearchFilterToInit());
    context.read<MangeSearchFilterProductsCubit>().isSearchProducts = false;
    context.read<MangeSearchFilterProductsCubit>().isFilterProducts = false;
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

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showMessage(
      String message, Color color) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2.w)),
            margin: EdgeInsets.symmetric(horizontal: 0.1.w),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          duration: const Duration(seconds: 3)),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is AddToCartState) {
          showMessage('add_product_done'.tr(context), Colors.green);
        } else if (state is AlreadyInCartState) {
          showMessage('product_in_cart'.tr(context), Colors.grey);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton:
            ScrollToTopButton(scrollController: scrollController),
        body: SingleChildScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              TopOvalWidget(
                isNotHome: widget.isNotHome,
                firstText: widget.cData.name!,
                parentId: widget.cData.id!,
              ),
              BlocBuilder<SearchFilterPoductsBloc, SearchFilterPoductsState>(
                builder: (context, state) {
                  switch (state.status) {
                    case SearchFilterProductsStatus.loading:
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.buttonCategoryColor,
                        ),
                      );
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
                          itemBuilder: (context, product) => ProductCardWidget(
                                isHomeScreen: false,
                                product: product,
                                addToCartPaddingButton: 3.w,
                              ));
                    case SearchFilterProductsStatus.init:
                      return CategoriesGrid(categoryId: widget.cData.id!);
                  }
                },
              )
              // BlocBuilder<SearchProductByCategoryIdCubit,
              //     SearchProductByCategoryIdState>(
              //   builder: (context, state) {
              //     if (state is SearchProductByCategoryIdError) {
              //       return MyErrorWidget(
              //           msg: state.message, onPressed: () {});
              //     } else if (state is SearchProductByCategoryIdLoading) {
              //       return const Center(
              //         child: CircularProgressIndicator(
              //           color: AppColors.buttonCategoryColor,
              //         ),
              //       );
              //     } else if (state is SearchProductByCategoryIdNotFound) {
              //       return Center(
              //         child: Text(
              //           "there_are_no_results_found".tr(context),
              //         ),
              //       );
              //     } else if (state is SearchProductByCategoryIdSuccess) {
              //       return CustomGridVeiw(
              //         products: state.products,
              //         physics: const NeverScrollableScrollPhysics(),
              //         shrinkWrap: true,
              //       );
              //     } else {
              //       return CategoriesGrid(categoryId: widget.cData.id!);
              //     }
              //   },
              // )
            ],
          ),
        ),
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
                child: CircularProgressIndicator(
                  color: AppColors.buttonCategoryColor,
                ),
              ),
            );
          case GetProductsByCatIdStatus.success:
            return CustomLazyLoadGridView(
                items: state.products,
                hasReachedMax: state.hasReachedMax,
                itemBuilder: (context, product) => ProductCardWidget(
                      isHomeScreen: false,
                      product: product,
                      addToCartPaddingButton: 3.w,
                    ));
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
    // return BlocBuilder<GetPorductByIdCubit, GetPorductByIdState>(
    //   builder: (context, state) {
    //     if (state is GetPorductByIdError) {
    //       return MyErrorWidget(
    //           msg: state.msg,
    //           onPressed: () {
    //             context
    //                 .read<G>()
    //                 .getProductsByCategory(categoryId);
    //           });
    //     } else if (state is GetPorductByIdLoading) {
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     } else if (state is GetPorductByIdSuccess) {
    //       return CustomGridVeiw(
    //         products: state.products,
    //         physics: const NeverScrollableScrollPhysics(),
    //         shrinkWrap: true,
    //       );
    //     }
    //     return const SizedBox();
    //   },
    // );
  }
}

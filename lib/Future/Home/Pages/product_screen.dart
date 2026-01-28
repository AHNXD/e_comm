import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:zein_store/Future/Home/Blocs/get_products_by_cat_id/get_products_by_cat_id_bloc.dart';
import 'package:zein_store/Future/Home/Blocs/search_filter_products/search_filter_poducts_bloc.dart';
import 'package:zein_store/Future/Home/Cubits/mange_search_filter_products/mange_search_filter_products_cubit.dart';
import 'package:zein_store/Future/Home/Widgets/custom_lazy_load_grid_view.dart';
import 'package:zein_store/Future/Home/Widgets/error_widget.dart';
import 'package:zein_store/Future/Home/Widgets/home_screen/product_card_widget.dart';
import 'package:zein_store/Future/Home/Widgets/product_Screen/top_oval_widget.dart';
import 'package:zein_store/Future/Home/models/catigories_model.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';
import '../Widgets/custom_circular_progress_indicator.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({
    super.key,
    required this.cData,
    required this.isNotHome,
  });

  final CatigoriesData cData;
  final bool isNotHome;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.hasClients) {
      final currentScroll = scrollController.offset;
      final maxScroll = scrollController.position.maxScrollExtent;
      final cubit = context.read<MangeSearchFilterProductsCubit>();

      if (currentScroll >= (maxScroll * 0.9)) {
        if (!cubit.isSearchProducts && !cubit.isFilterProducts) {
          context
              .read<GetProductsByCatIdBloc>()
              .add(GetAllPoductsByCatIdEvent(categoryID: widget.cData.id!));
        } else if (cubit.isSearchProducts && !cubit.isFilterProducts) {
          final searchText = cubit.searchText;
          if (searchText != null) {
            context.read<SearchFilterPoductsBloc>().add(SearchProductsByCatId(
                widget.cData.id!,
                searchText: searchText));
          }
        } else if (cubit.isFilterProducts && !cubit.isSearchProducts) {
          final min = cubit.min;
          final max = cubit.max;
          if (min != null && max != null) {
            context.read<SearchFilterPoductsBloc>().add(
                FilterProductsByCatId(widget.cData.id!, min: min, max: max));
          }
        }
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
      backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
        children: [
          // Header (Search/Filter + Categories)
          TopOvalWidget(
            isNotHome: widget.isNotHome,
            firstText: widget.cData.name!,
            parentId: widget.cData.id!,
            children: widget.cData.children ?? [],
          ),

          // Content
          Expanded(
            child:
                BlocBuilder<SearchFilterPoductsBloc, SearchFilterPoductsState>(
              builder: (context, state) {
                switch (state.status) {
                  case SearchFilterProductsStatus.init:
                    return CategoriesGrid(
                        categoryId: widget.cData.id!,
                        scrollController: scrollController);

                  case SearchFilterProductsStatus.loading:
                    return const Center(
                        child: CustomCircularProgressIndicator());

                  case SearchFilterProductsStatus.error:
                    return Center(
                      child:
                          MyErrorWidget(msg: state.errorMsg, onPressed: () {}),
                    );

                  case SearchFilterProductsStatus.success:
                    if (state.products.isEmpty) {
                      return _buildEmptyState(context);
                    }
                    return ListView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(top: 1.h, bottom: 5.h),
                      children: [
                        CustomLazyLoadGridView(
                          items: state.products,
                          hasReachedMax: state.hasReachedMax,
                          childAspectRatio: 0.62, // Matches Card Design
                          itemBuilder: (context, product) => ProductCardWidget(
                            isHomeScreen: false,
                            product: product,
                            addToCartPaddingButton: 3.w,
                            screen: "cat",
                          ),
                        ),
                      ],
                    );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryColors.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search_off_rounded,
                size: 40.sp, color: AppColors.primaryColors.withOpacity(0.5)),
          ),
          SizedBox(height: 2.h),
          Text(
            "there_are_no_results_found".tr(context),
            style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}

class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid(
      {super.key, required this.categoryId, required this.scrollController});
  final int categoryId;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetProductsByCatIdBloc, GetProductsByCatIdState>(
      builder: (context, state) {
        switch (state.status) {
          case GetProductsByCatIdStatus.loading:
            return const Center(child: CustomCircularProgressIndicator());

          case GetProductsByCatIdStatus.success:
            if (state.products.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inventory_2_outlined,
                        size: 40.sp, color: Colors.grey[300]),
                    SizedBox(height: 1.h),
                    Text("no_products_here_yet".tr(context),
                        style: TextStyle(color: Colors.grey[500])),
                  ],
                ),
              );
            }
            return ListView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(top: 1.h, bottom: 5.h),
              children: [
                CustomLazyLoadGridView(
                  items: state.products,
                  hasReachedMax: state.hasReachedMax,
                  childAspectRatio: 0.62,
                  itemBuilder: (context, product) => ProductCardWidget(
                    isHomeScreen: false,
                    product: product,
                    addToCartPaddingButton: 3.w,
                    screen: "cat",
                  ),
                ),
              ],
            );

          case GetProductsByCatIdStatus.error:
            return Center(
              child: MyErrorWidget(
                msg: state.errorMsg,
                onPressed: () {
                  context.read<GetProductsByCatIdBloc>().add(ResetPagination());
                  context
                      .read<GetProductsByCatIdBloc>()
                      .add(GetAllPoductsByCatIdEvent(categoryID: categoryId));
                },
              ),
            );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:zein_store/Future/Home/Blocs/search_products/search_products_bloc.dart';
import 'package:zein_store/Future/Home/Cubits/cartCubit/cart.bloc.dart';
import 'package:zein_store/Future/Home/Widgets/custom_lazy_load_grid_view.dart';
import 'package:zein_store/Future/Home/Widgets/custom_snak_bar.dart';
import 'package:zein_store/Future/Home/Widgets/error_widget.dart';
import 'package:zein_store/Future/Home/Widgets/home_screen/product_card_widget.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';
import '../Widgets/custom_circular_progress_indicator.dart';

class SearchProductScreen extends StatefulWidget {
  const SearchProductScreen({super.key});

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  late TextEditingController controller;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    scrollController = ScrollController();
    scrollController.addListener(onScroll);

    // Reset state on entry
    context.read<SearchProductsBloc>().add(ResetSearchingToInit());
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void onScroll() {
    if (scrollController.hasClients) {
      final currentScroll = scrollController.offset;
      final maxScroll = scrollController.position.maxScrollExtent;

      if (currentScroll >= (maxScroll * 0.9)) {
        context
            .read<SearchProductsBloc>()
            .add(SearchForProducsEvent(search: controller.text));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is AddToCartFromSearchState) {
          CustomSnackBar.showMessage(
              context, 'add_product_done'.tr(context), Colors.green);
        } else if (state is AlreadyInCartFromSearchState) {
          CustomSnackBar.showMessage(
              context, 'product_in_cart'.tr(context), Colors.grey);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: AppColors.buttonCategoryColor.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.buttonCategoryColor, size: 16.sp),
            ),
          ),
          title: Text(
            "search_product_screen_title".tr(context),
            style: TextStyle(
                color: AppColors.textTitleAppBarColor,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Search Bar Container
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.h),
              child: ShearchBarWidget(controller: controller),
            ),

            // Search Results
            Expanded(
              child: ListView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(top: 1.h),
                children: [
                  SearchContentWidget(controller: controller),
                  SizedBox(height: 5.h), // Bottom padding
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SearchContentWidget extends StatelessWidget {
  const SearchContentWidget({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchProductsBloc, SearchProductsState>(
      builder: (context, state) {
        switch (state.status) {
          case SearchProductsStatus.init:
            return _buildEmptyState(
              context,
              icon: Icons.manage_search_rounded,
              message: "search_product_screen_body".tr(context),
            );

          case SearchProductsStatus.loading:
            return SizedBox(
              height: 50.h,
              child: const Center(child: CustomCircularProgressIndicator()),
            );

          case SearchProductsStatus.error:
            return SizedBox(
              height: 50.h,
              child: Center(
                child: MyErrorWidget(
                  msg: state.errorMsg,
                  onPressed: () {
                    context.read<SearchProductsBloc>().add(
                        SearchForProducsEvent(search: controller.text.trim()));
                  },
                ),
              ),
            );

          case SearchProductsStatus.success:
            if (state.products.isEmpty) {
              return _buildEmptyState(context,
                  icon: Icons.search_off_rounded,
                  message: "there_are_no_results_found".tr(context),
                  subMessage: "Try using different keywords");
            }
            return CustomLazyLoadGridView(
              items: state.products,
              hasReachedMax: state.hasReachedMax,
              // Use the optimized aspect ratio from earlier (0.62)
              childAspectRatio: 0.62,
              itemBuilder: (context, product) => ProductCardWidget(
                isHomeScreen: false,
                product: product,
                screen: "search",
              ),
            );
        }
      },
    );
  }

  Widget _buildEmptyState(BuildContext context,
      {required IconData icon, required String message, String? subMessage}) {
    return SizedBox(
      height: 50.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryColors.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  size: 40.sp, color: AppColors.primaryColors.withOpacity(0.5)),
            ),
            SizedBox(height: 2.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            if (subMessage != null) ...[
              SizedBox(height: 1.h),
              Text(
                subMessage,
                style: TextStyle(fontSize: 10.sp, color: Colors.grey[500]),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class ShearchBarWidget extends StatelessWidget {
  const ShearchBarWidget({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7), // Light grey input background
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controller,
        textInputAction: TextInputAction.search,
        onFieldSubmitted: (value) {
          if (value.isNotEmpty && value.trim() != "") {
            context.read<SearchProductsBloc>().add(ResetSearchText());
            context
                .read<SearchProductsBloc>()
                .add(SearchForProducsEvent(search: value));
          }
        },
        style:
            const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: "search_product_hint".tr(context),
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 11.sp),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[600]),
          suffixIcon: IconButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                controller.clear();
                context.read<SearchProductsBloc>().add(ResetSearchingToInit());
              }
            },
            icon: Icon(Icons.close_rounded, color: Colors.grey[500], size: 18),
          ),
        ),
      ),
    );
  }
}

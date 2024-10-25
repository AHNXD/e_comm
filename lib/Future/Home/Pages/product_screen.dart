import 'package:e_comm/Future/Home/Cubits/get_min_max_cubit/get_min_max_cubit.dart';
import 'package:e_comm/Future/Home/Widgets/error_widget.dart';
import 'package:e_comm/Future/Home/Widgets/home_screen/product_card_widget.dart';

import 'package:e_comm/Utils/app_localizations.dart';
import '../Cubits/cartCubit/cart.bloc.dart';
import '../Cubits/getProductById/get_porduct_by_id_cubit.dart';
import '../Cubits/searchProductByCatId/search_product_by_category_id_cubit.dart';
import '../Widgets/scroll_top_button.dart';
import '../models/catigories_model.dart';
import '../models/product_model.dart';
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
    context.read<GetPorductByIdCubit>().getProductsByCategory(widget.cData.id!);
    context.read<GetMinMaxCubit>().getMinMax(widget.cData.id);

    super.initState();
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
    return BlocProvider(
      create: (context) => SearchProductByCategoryIdCubit(),
      child: BlocListener<CartCubit, CartState>(
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
                BlocBuilder<SearchProductByCategoryIdCubit,
                    SearchProductByCategoryIdState>(
                  builder: (context, state) {
                    if (state is SearchProductByCategoryIdError) {
                      return MyErrorWidget(
                          msg: state.message, onPressed: () {});
                    } else if (state is SearchProductByCategoryIdLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is SearchProductByCategoryIdNotFound) {
                      return Center(
                        child: Text(
                          "there_are_no_results_found".tr(context),
                        ),
                      );
                    } else if (state is SearchProductByCategoryIdSuccess) {
                      return CustomGridVeiw(
                        products: state.products,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                      );
                    } else {
                      return CategoriesGrid(categoryId: widget.cData.id!);
                    }
                  },
                )
              ],
            ),
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
    return BlocBuilder<GetPorductByIdCubit, GetPorductByIdState>(
      builder: (context, state) {
        if (state is GetPorductByIdError) {
          return MyErrorWidget(
              msg: state.msg,
              onPressed: () {
                context
                    .read<GetPorductByIdCubit>()
                    .getProductsByCategory(categoryId);
              });
        } else if (state is GetPorductByIdLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is GetPorductByIdSuccess) {
          return CustomGridVeiw(
            products: state.products,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
          );
        }
        return const SizedBox();
      },
    );
  }
}

class CustomGridVeiw extends StatelessWidget {
  const CustomGridVeiw(
      {super.key, required this.products, this.physics, this.shrinkWrap});
  final List<MainProduct> products;
  final ScrollPhysics? physics;
  final bool? shrinkWrap;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    int selectScreenWidth(screenWidth) {
      if (screenWidth <= 280) {
        return 1;
      }
      return 2;
    }

    double selectAspectRatio(screenWidth, screenHeight) {
      if (screenWidth <= 280) {
        return screenWidth / (screenHeight) * 2.3;
      } else if (screenWidth > 280 && screenWidth < 450) {
        return screenWidth / (screenHeight);
      } else if (screenWidth >= 450 && screenWidth < 600) {
        return screenWidth / (screenHeight) * 0.82;
      } else if (screenWidth >= 600 && screenWidth < 900) {
        return screenWidth / (screenHeight) * 0.55;
      }
      return screenWidth / (screenHeight) * 0.3;
    }

    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: physics ?? const BouncingScrollPhysics(),
      shrinkWrap: shrinkWrap ?? false,
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: selectAspectRatio(screenWidth, screenHeight),
          crossAxisCount: selectScreenWidth(screenWidth),
          crossAxisSpacing: 3.w,
          mainAxisSpacing: 1.h),
      itemBuilder: (context, index) {
        return ProductCardWidget(
          isHomeScreen: false,
          product: products[index],
          addToCartPaddingButton: 3.w,
        );
      },
    );
  }
}

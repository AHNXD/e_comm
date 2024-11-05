import 'package:e_comm/Future/Home/Widgets/error_widget.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/enums.dart';
import 'package:e_comm/Utils/images.dart';
import 'package:e_comm/Utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import '../../../Utils/colors.dart';
import '../Cubits/searchProductsCubit/search_products_cubit.dart';
import '../Widgets/product_Screen/custom_gridView.dart';

class SearchProductScreen extends StatefulWidget {
  const SearchProductScreen({super.key});

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  late TextEditingController controller;
  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: IconButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateColor.resolveWith(
                (states) => AppColors.buttonCategoryColor),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            context.read<SearchProductsCubit>().reset();
          },
          icon: SvgPicture.asset(
            AppImagesAssets.back,
            height: 3.h,
          ),
          color: Colors.white,
          iconSize: 20.sp,
        ),
        excludeHeaderSemantics: false,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Text(
          "search_product_screen_title".tr(context),
          style: TextStyle(
              color: AppColors.textTitleAppBarColor,
              fontWeight: FontWeight.bold,
              fontSize: 15.sp),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            child: TextFormField(
              controller: controller,
              validator: (s) => validation(s, ValidationState.normal),
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  hintText: "search_product_hint".tr(context),
                  hintStyle: const TextStyle(
                    color: Colors.black54,
                  ),
                  filled: true,
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.clear();
                      context.read<SearchProductsCubit>().reset();
                    },
                    icon: const Icon(
                      textDirection: TextDirection.ltr,
                      Icons.close,
                      color: AppColors.buttonCategoryColor,
                    ),
                  ),
                  prefixIcon: IconButton(
                    icon: BlocBuilder<SearchProductsCubit, SearchProductsState>(
                      builder: (context, state) {
                        return const Icon(
                          Icons.search,
                          color: AppColors.buttonCategoryColor,
                        );
                      },
                    ),
                    onPressed: () {
                      context
                          .read<SearchProductsCubit>()
                          .searchProducts(controller.text);
                    },
                  ),
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(4.w))),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchProductsCubit, SearchProductsState>(
                builder: (context, state) {
              if (state is SearchProductsInitial) {
                return Center(
                  child: Text("search_product_screen_body".tr(context)),
                );
              }
              if (state is SearchProductsLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is SearchProductsErrorState) {
                return MyErrorWidget(
                  msg: state.message,
                  onPressed: () {
                    context
                        .read<SearchProductsCubit>()
                        .searchProducts(controller.text.trim());
                  },
                );
              }
              if (state is SearchProductsSuccessfulState) {
                return CustomGridVeiw(products: state.products);
                // return GridView.builder(
                //   physics: const AlwaysScrollableScrollPhysics(),
                //   itemCount:
                //       productCardList(false, getSearchProduct(context)).length,
                //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //       childAspectRatio: 0.083.h,
                //       crossAxisCount: 2,
                //       crossAxisSpacing: 3.w,
                //       mainAxisSpacing: 1.h),
                //   itemBuilder: (context, index) {
                //     return ProductCardWidget(
                //       isHomeScreen: false,
                //       product: state.products[index],
                //       addToCartPaddingButton: 3.w,
                //     );
                //     // return productCardList(
                //     //     false, getSearchProduct(context))[index];
                //   },
                // );
              } else if (state is SearchProductsNotFoundfulState) {
                return Center(
                    child: Text("there_are_no_results_found".tr(context)));
              }
              return const SizedBox();
            }),
          )
        ],
      ),
    );
  }
}

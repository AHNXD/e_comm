import 'package:e_comm/Future/Home/Cubits/cartCubit/cart.bloc.dart';
import 'package:e_comm/Future/Home/Widgets/custom_snak_bar.dart';
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
import '../Blocs/search_products/search_products_bloc.dart';
import '../Widgets/custom_circular_progress_indicator.dart';
import '../Widgets/custom_lazy_load_grid_view.dart';
import '../Widgets/home_screen/product_card_widget.dart';

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
    controller = TextEditingController();
    scrollController = ScrollController();
    scrollController.addListener(onScroll);
    context.read<SearchProductsBloc>().add(ResetSearchingToInit());

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    final currentScroll = scrollController.offset;
    final maxScroll = scrollController.position.maxScrollExtent;

    if (currentScroll >= (maxScroll * 0.9)) {
      context
          .read<SearchProductsBloc>()
          .add(SearchForProducsEvent(search: controller.text));
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
            ShearchBarWidget(controller: controller),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                children: [
                  SearchContentWidget(
                    controller: controller,
                  ),
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
            return Center(
              child: Text("search_product_screen_body".tr(context)),
            );
          case SearchProductsStatus.loading:
            return const Center(child: CustomCircularProgressIndicator());
          case SearchProductsStatus.error:
            return MyErrorWidget(
              msg: state.errorMsg,
              onPressed: () {
                context
                    .read<SearchProductsBloc>()
                    .add(SearchForProducsEvent(search: controller.text.trim()));
              },
            );
          case SearchProductsStatus.success:
            if (state.products.isEmpty) {
              return Center(
                child: Text("there_are_no_results_found".tr(context)),
              );
            }
            return CustomLazyLoadGridView(
                items: state.products,
                hasReachedMax: state.hasReachedMax,
                itemBuilder: (context, product) => ProductCardWidget(
                    isHomeScreen: false,
                    product: product,
                    addToCartPaddingButton: 3.w,
                    screen: "search"));
        }
      },
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      child: TextFormField(
        controller: controller,
        onFieldSubmitted: (value) {
          if (value.isNotEmpty && value.trim() != "") {
            context.read<SearchProductsBloc>().add(ResetSearchText());
            context
                .read<SearchProductsBloc>()
                .add(SearchForProducsEvent(search: value));
          }
        },
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
                if (controller.text.isNotEmpty &&
                    controller.text.trim() != "") {
                  controller.clear();
                  context
                      .read<SearchProductsBloc>()
                      .add(ResetSearchingToInit());
                }
              },
              icon: const Icon(
                textDirection: TextDirection.ltr,
                Icons.close,
                color: AppColors.buttonCategoryColor,
              ),
            ),
            prefixIcon: IconButton(
              icon: const Icon(
                Icons.search,
                color: AppColors.buttonCategoryColor,
              ),
              onPressed: () {
                if (controller.text.isNotEmpty &&
                    controller.text.trim() != "") {
                  context.read<SearchProductsBloc>().add(ResetSearchText());
                  context
                      .read<SearchProductsBloc>()
                      .add(SearchForProducsEvent(search: controller.text));
                }
              },
            ),
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(4.w))),
      ),
    );
  }
}

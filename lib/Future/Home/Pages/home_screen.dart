import 'package:e_comm/Future/Auth/Pages/login_screen.dart';
import 'package:e_comm/Future/Auth/cubit/auth_cubit.dart';
import 'package:e_comm/Future/Home/Blocs/get_latest_products/get_latest_products_bloc.dart';
import 'package:e_comm/Future/Home/Cubits/GetOffers/get_offers_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/cartCubit/cart.bloc.dart';
//import 'package:e_comm/Future/Home/Cubits/get_latest_products/get_latest_products_cubit.dart';
import 'package:e_comm/Future/Home/Widgets/error_widget.dart';
import 'package:e_comm/Utils/app_localizations.dart';

import '/Future/Home/Widgets/home_screen/appbar_widget.dart';
import '/Future/Home/Widgets/home_screen/carousel_slider_widget.dart';
import '../Widgets/home_screen/home_page_categories_button_widget.dart';
import '/Future/Home/Widgets/home_screen/tilte_card_widget.dart';
import '/Utils/colors.dart';
import '/Utils/test_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final sc = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final currentScroll = _scrollController.offset;
    final maxScroll = _scrollController.position.maxScrollExtent;

    if (currentScroll >= (maxScroll * 0.9)) {
      context.read<GetLatestProductsBloc>().add(GetAllLatestProductsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
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

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccessState) {
          showMessage(state.message, Colors.green);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (builder) {
            return LoginScreen();
          }));
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 8.5.h),
          child: const AppBarWidget(),
        ),
        backgroundColor: AppColors.backgroundColor,
        body: BlocListener<CartCubit, CartState>(
          listener: (context, state) {
            if (state is AddToCartState) {
              showMessage('add_product_done'.tr(context), Colors.green);
            } else if (state is AlreadyInCartState) {
              showMessage('product_in_cart'.tr(context), Colors.grey);
            }
          },
          child: ListView(
            shrinkWrap: true,
            controller: _scrollController,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "categoris".tr(context),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: AppColors.textTitleAppBarColor),
                ),
              ),
              const HomePageCategoriesButtonWidget(),
              BlocBuilder<GetOffersCubit, GetOffersState>(
                builder: (context, state) {
                  final model = context.read<GetOffersCubit>();
                  if (state is GetOffersLoadingState) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is GetOffersErrorState) {
                    return MyErrorWidget(
                      msg: state.msg,
                      onPressed: () {
                        model.getOffers();
                      },
                    );
                  } else if (state is GetOffersSuccessfulState) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "offers".tr(context),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: AppColors.textTitleAppBarColor),
                              ),
                            ),
                          ],
                        ),
                        CarouselSliderWidget(
                          list: offersList(state.products),
                          height: 350,
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "latest_products".tr(context),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: AppColors.textTitleAppBarColor),
                ),
              ),
              LastestProductAndTitle(controller: _scrollController),
              SizedBox(
                height: 2.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LastestProductAndTitle extends StatefulWidget {
  final ScrollController controller;
  const LastestProductAndTitle({
    super.key,
    required this.controller,
  });

  @override
  State<LastestProductAndTitle> createState() => _LastestProductAndTitleState();
}

class _LastestProductAndTitleState extends State<LastestProductAndTitle> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetLatestProductsBloc, GetLatestProductsState>(
      builder: (context, state) {
        switch (state.status) {
          case LatestProductsStatus.loading:
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          case LatestProductsStatus.success:
            // if (state.latestProducts.isEmpty) {
            //   return const Center(
            //     child: Text("No Posts."),
            //   );
            // }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.hasReachedMax
                  ? state.latestProducts.length
                  : state.latestProducts.length + 1,
              itemBuilder: (BuildContext context, int index) {
                return index >= state.latestProducts.length
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              color: AppColors.buttonCategoryColor,
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          TitleCardWidget(
                              cData: state.latestProducts[index].category!),
                          CarouselSliderWidget(
                            list: productCardList(
                                true, state.latestProducts[index].products!),
                            height: 425,
                          ),
                        ],
                      );
              },
            );
          case LatestProductsStatus.error:
            return Center(child: Text(state.errorMsg));
        }
      },
    );
  }
}

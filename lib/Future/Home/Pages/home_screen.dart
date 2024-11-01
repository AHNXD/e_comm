import 'package:e_comm/Future/Auth/Pages/login_screen.dart';
import 'package:e_comm/Future/Auth/cubit/auth_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/GetOffers/get_offers_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/cartCubit/cart.bloc.dart';
import 'package:e_comm/Future/Home/Cubits/get_latest_products/get_latest_products_cubit.dart';
import 'package:e_comm/Future/Home/Widgets/error_widget.dart';
import 'package:e_comm/Future/Home/models/catigories_model.dart';
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

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final ScrollController controller = ScrollController();

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
          preferredSize: Size(double.infinity, 8.h),
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
            controller: controller,
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
              SizedBox(
                height: 12.h,
                child: const HomePageCategoriesButtonWidget(),
              ),
              SizedBox(height: 1.h),
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
                          height: 38.h,
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
                  // return model.productOffers!.isNotEmpty
                  //     ? Column(
                  //         children: [
                  //           Row(
                  //             children: [
                  //               Padding(
                  //                 padding: const EdgeInsets.all(8.0),
                  //                 child: Text(
                  //                   "offers".tr(context),
                  //                   style: const TextStyle(
                  //                       fontWeight: FontWeight.bold,
                  //                       fontSize: 30,
                  //                       color: AppColors.textTitleAppBarColor),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           CarouselSliderWidget(
                  //             list: offersList(model.productOffers!),
                  //             height: 38.h,
                  //           ),
                  //         ],
                  //       )
                  //     : const SizedBox();
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
              LastestProductAndTitle(controller: controller),
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

class LastestProductAndTitle extends StatelessWidget {
  const LastestProductAndTitle({
    super.key,
    required this.controller,
  });
  final ScrollController controller;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetLatestProductsCubit, GetLatestProductsState>(
      builder: (context, state) {
        if (state is GetLatestProductsInitial ||
            state is GetLatestProductsLoadingState) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is GetLatestProductsSuccessfulState) {
          return ListView.builder(
            shrinkWrap: true,
            controller: controller,
            itemCount: state.latestProducts.length,
            itemBuilder: (BuildContext context, int index) {
              String name = state.latestProducts[index].category!.name!;
              int id = state.latestProducts[index].category!.id!;
              CatigoriesData cData = state.latestProducts[index].category!;
              return Column(
                children: [
                  TitleCardWidget(title: name, id: id, cData: cData),
                  CarouselSliderWidget(
                    list: productCardList(
                        true, state.latestProducts[index].products!),
                    height: 51.5.h,
                  ),
                ],
              );
            },
          );
        } else if (state is GetLatestProductsErrorState) {
          return MyErrorWidget(
            msg: state.msg,
            onPressed: () {
              context.read<GetLatestProductsCubit>().getLatestProducts();
            },
          );
        } else {
          return const Text('Unexpected state');
        }
      },
    );
  }
}

import 'package:e_comm/Future/Auth/Pages/login_screen.dart';
import 'package:e_comm/Future/Auth/cubit/auth_cubit.dart';
import 'package:e_comm/Future/Home/Blocs/get_latest_products/get_latest_products_bloc.dart';
import 'package:e_comm/Future/Home/Blocs/get_offers/get_offers_bloc.dart';
import 'package:e_comm/Future/Home/Cubits/cartCubit/cart.bloc.dart';
import 'package:e_comm/Future/Home/Cubits/cubit/delete_profile_cubit.dart';
//import 'package:e_comm/Future/Home/Cubits/get_latest_products/get_latest_products_cubit.dart';
import 'package:e_comm/Future/Home/Widgets/error_widget.dart';
import 'package:e_comm/Future/Home/Widgets/home_screen/offers_widget.dart';
import 'package:e_comm/Utils/app_localizations.dart';

import '../Widgets/custom_snak_bar.dart';
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
  final _scrollControllerOffers = ScrollController();
  final _scrollControllerCategories = ScrollController();
  final sc = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrollLatestProducts);
    _scrollControllerOffers.addListener(_onScrollOffers);
    _scrollControllerCategories.addListener(_onScrollCategories);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScrollLatestProducts)
      ..dispose();

    _scrollControllerOffers
      ..removeListener(_onScrollOffers)
      ..dispose();

    _scrollControllerCategories
      ..removeListener(_onScrollCategories)
      ..dispose();

    super.dispose();
  }

  void _onScrollLatestProducts() {
    final currentScroll = _scrollController.offset;
    final maxScroll = _scrollController.position.maxScrollExtent;

    if (currentScroll >= (maxScroll * 0.9)) {
      context.read<GetLatestProductsBloc>().add(GetAllLatestProductsEvent());
    }
  }

  void _onScrollOffers() {
    final currentScroll = _scrollControllerOffers.offset;
    final maxScroll = _scrollControllerOffers.position.maxScrollExtent;

    if (currentScroll >= (maxScroll * 0.9)) {
      context.read<GetOffersBloc>().add(GetAllOffersEvent());
    }
  }

  void _onScrollCategories() {
    final currentScroll = _scrollControllerCategories.offset;
    final maxScroll = _scrollControllerCategories.position.maxScrollExtent;

    if (currentScroll >= (maxScroll * 0.9)) {
      context.read<GetOffersBloc>().add(GetAllOffersEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccessState) {
          CustomSnackBar.showMessage(context, state.message, Colors.green);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (builder) {
            return LoginScreen();
          }));
        }
      },
      child: BlocListener<DeleteProfileCubit, DeleteProfileState>(
        listener: (context, state) {
          if (state is DeleteProfileSuccess) {
            CustomSnackBar.showMessage(context, state.msg, Colors.red);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (builder) {
              return LoginScreen();
            }));
          } else if (state is DeleteProfileError) {
            CustomSnackBar.showMessage(context, state.msg, Colors.red);
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
              if (state is AddedTocartFromHomeScreen) {
                CustomSnackBar.showMessage(
                    context, 'add_product_done'.tr(context), Colors.green);
              } else if (state is AlreadyInCartState) {
                CustomSnackBar.showMessage(
                    context, 'product_in_cart'.tr(context), Colors.grey);
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
                BlocBuilder<GetOffersBloc, GetOffersState>(
                    builder: (context, state) {
                  switch (state.status) {
                    case GetOffersStatus.loading:
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    case GetOffersStatus.success:
                      if (state.offersProducts.isEmpty) {
                        return Center(
                          child: Text(
                            "offers_empty_msg".tr(context),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return SizedBox(
                        height: 480,
                        width: double.infinity,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 400,
                              width: double.infinity,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                controller: _scrollControllerOffers,
                                itemCount: state.hasReachedMax
                                    ? state.offersProducts.length
                                    : state.offersProducts.length + 1,
                                itemBuilder: (BuildContext context, int index) {
                                  return index >= state.offersProducts.length
                                      ? const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(4),
                                            child: SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: CircularProgressIndicator(
                                                color: AppColors
                                                    .buttonCategoryColor,
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          child: OffersWidget(
                                              data:
                                                  state.offersProducts[index]),
                                        );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    case GetOffersStatus.error:
                      return Center(
                          child: MyErrorWidget(
                        msg: state.errorMsg,
                        onPressed: () {
                          context
                              .read<GetOffersBloc>()
                              .add(ResetPaginationAllOffersEvent());
                          context
                              .read<GetOffersBloc>()
                              .add(GetAllOffersEvent());
                        },
                      ));
                  }
                }),
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
            return Center(
                child: MyErrorWidget(
              msg: state.errorMsg,
              onPressed: () {
                context
                    .read<GetLatestProductsBloc>()
                    .add(ResetPaginationAllLatestProductsEvent());
                context
                    .read<GetLatestProductsBloc>()
                    .add(GetAllLatestProductsEvent());
              },
            ));
        }
      },
    );
  }
}

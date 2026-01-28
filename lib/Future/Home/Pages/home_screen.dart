import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:zein_store/Future/Auth/Pages/login_screen.dart';
import 'package:zein_store/Future/Auth/cubit/auth_cubit.dart';
import 'package:zein_store/Future/Home/Blocs/get_categories/get_categories_bloc.dart';
import 'package:zein_store/Future/Home/Blocs/get_latest_products/get_latest_products_bloc.dart';
import 'package:zein_store/Future/Home/Blocs/get_offers/get_offers_bloc.dart';
import 'package:zein_store/Future/Home/Cubits/cartCubit/cart.bloc.dart';
import 'package:zein_store/Future/Home/Cubits/delete_profile/delete_profile_cubit.dart';
import 'package:zein_store/Future/Home/Pages/all_offers_screen.dart';
import 'package:zein_store/Future/Home/Widgets/error_widget.dart';
import 'package:zein_store/Future/Home/Widgets/home_screen/appbar_widget.dart';
import 'package:zein_store/Future/Home/Widgets/home_screen/product_card_widget.dart';
import 'package:zein_store/Future/Home/Widgets/home_screen/tilte_card_widget.dart';
import 'package:zein_store/Future/Home/models/product_model.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';

import '../Widgets/custom_circular_progress_indicator.dart';
import '../Widgets/custom_snak_bar.dart';
import '../Widgets/home_screen/home_page_categories_button_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- Controllers ---
  final _scrollController = ScrollController();
  final _scrollControllerOffers = ScrollController();
  final _scrollControllerCategories = ScrollController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // --- Logic ---
  void _onRefresh() async {
    context.read<GetCategoriesBloc>().add(ResetPaginationCategoriesEvent());
    context.read<GetCategoriesBloc>().add(GetAllCategoriesEvent());

    context
        .read<GetLatestProductsBloc>()
        .add(ResetPaginationAllLatestProductsEvent());
    context.read<GetLatestProductsBloc>().add(GetAllLatestProductsEvent());

    context.read<GetOffersBloc>().add(ResetPaginationAllOffersEvent());
    context.read<GetOffersBloc>().add(GetAllOffersEvent());

    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrollLatestProducts);
    _scrollControllerOffers.addListener(_onScrollOffers);
    _scrollControllerCategories.addListener(_onScrollCategories);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollControllerOffers.dispose();
    _scrollControllerCategories.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void _onScrollLatestProducts() {
    if (_scrollController.hasClients) {
      final currentScroll = _scrollController.offset;
      final maxScroll = _scrollController.position.maxScrollExtent;
      if (currentScroll >= (maxScroll * 0.9)) {
        context.read<GetLatestProductsBloc>().add(GetAllLatestProductsEvent());
      }
    }
  }

  void _onScrollOffers() {
    if (_scrollControllerOffers.hasClients) {
      final currentScroll = _scrollControllerOffers.offset;
      final maxScroll = _scrollControllerOffers.position.maxScrollExtent;
      if (currentScroll >= (maxScroll * 0.9)) {
        context.read<GetOffersBloc>().add(GetAllOffersEvent());
      }
    }
  }

  void _onScrollCategories() {
    if (_scrollControllerCategories.hasClients) {
      final currentScroll = _scrollControllerCategories.offset;
      final maxScroll = _scrollControllerCategories.position.maxScrollExtent;
      if (currentScroll >= (maxScroll * 0.9)) {
        context.read<GetCategoriesBloc>().add(GetAllCategoriesEvent());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is LogoutSuccessState) {
              context.read<CartCubit>().pcw = <MainProduct>[];
              CustomSnackBar.showMessage(context, state.message, Colors.green);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => LoginScreen()));
            }
          },
        ),
        BlocListener<DeleteProfileCubit, DeleteProfileState>(
          listener: (context, state) {
            if (state is DeleteProfileSuccess) {
              CustomSnackBar.showMessage(context, state.msg, Colors.green);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => LoginScreen()));
            } else if (state is DeleteProfileError) {
              CustomSnackBar.showMessage(context, state.msg, Colors.red);
            }
          },
        ),
        BlocListener<CartCubit, CartState>(
          listener: (context, state) {
            if (state is AddedTocartFromHomeScreen) {
              CustomSnackBar.showMessage(
                  context, 'add_product_done'.tr(context), Colors.green);
            } else if (state is AlreadyInCartFromHomeState) {
              CustomSnackBar.showMessage(
                  context, 'product_in_cart'.tr(context), Colors.grey);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA), // slightly cleaner background
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 8.5.h),
          child: const AppBarWidget(),
        ),
        body: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          physics: const BouncingScrollPhysics(),
          child: ListView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 5.h, top: 1.h),
            children: [
              // 1. Categories Section
              _SectionHeader(title: "categoris".tr(context)),
              const HomePageCategoriesButtonWidget(),

              SizedBox(height: 1.h),

              // 2. Offers Section
              _SectionHeader(
                title: "offers".tr(context),
                onSeeAll: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AllOffersScreen()));
                },
              ),
              _buildOffersList(),

              SizedBox(height: 2.h),

              // 3. Latest Products Section
              _SectionHeader(title: "latest_products".tr(context)),
              LastestProductAndTitle(controller: _scrollController),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets ---

  Widget _buildOffersList() {
    return BlocBuilder<GetOffersBloc, GetOffersState>(
      builder: (context, state) {
        switch (state.status) {
          case GetOffersStatus.loading:
            return SizedBox(
              height: 42.h,
              child: const Center(child: CustomCircularProgressIndicator()),
            );
          case GetOffersStatus.success:
            if (state.offersProducts.isEmpty) {
              return SizedBox(
                height: 15.h,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.discount_outlined,
                          color: Colors.grey[400], size: 30.sp),
                      SizedBox(height: 1.h),
                      Text(
                        "offers_empty_msg".tr(context),
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              );
            }
            return SizedBox(
              height: 42.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                controller: _scrollControllerOffers,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.hasReachedMax
                    ? state.offersProducts.length
                    : state.offersProducts.length + 1,
                separatorBuilder: (context, index) => SizedBox(width: 2.w),
                itemBuilder: (BuildContext context, int index) {
                  if (index >= state.offersProducts.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CustomCircularProgressIndicator(),
                        ),
                      ),
                    );
                  }
                  return SizedBox(
                    width: 50.w,
                    child: ProductCardWidget(
                      isHomeScreen: true,
                      product: state.offersProducts[index],
                      screen: "home",
                    ),
                  );
                },
              ),
            );
          case GetOffersStatus.error:
            return SizedBox(
              height: 30.h,
              child: Center(
                child: MyErrorWidget(
                  msg: state.errorMsg,
                  onPressed: () {
                    context
                        .read<GetOffersBloc>()
                        .add(ResetPaginationAllOffersEvent());
                    context.read<GetOffersBloc>().add(GetAllOffersEvent());
                  },
                ),
              ),
            );
        }
      },
    );
  }
}

// --- Reusable Section Header ---
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const _SectionHeader({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18.sp,
              color: AppColors.textTitleAppBarColor,
              letterSpacing: 0.5,
            ),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color:
                      AppColors.primaryColors[50], // Very light tint of primary
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "see_all".tr(context),
                  style: TextStyle(
                    color: AppColors.seeAllTextButtonColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// --- Latest Products Widget ---
class LastestProductAndTitle extends StatelessWidget {
  final ScrollController controller;
  const LastestProductAndTitle({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetLatestProductsBloc, GetLatestProductsState>(
      builder: (context, state) {
        switch (state.status) {
          case LatestProductsStatus.loading:
            return SizedBox(
              height: 20.h,
              child: const Center(child: CustomCircularProgressIndicator()),
            );
          case LatestProductsStatus.success:
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.hasReachedMax
                  ? state.latestProducts.length
                  : state.latestProducts.length + 1,
              separatorBuilder: (context, index) => SizedBox(height: 2.h),
              itemBuilder: (BuildContext context, int index) {
                if (index >= state.latestProducts.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CustomCircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                final category = state.latestProducts[index];
                final products = category.products ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Padding handled inside TitleCardWidget or add here
                    TitleCardWidget(cData: category.category!),

                    SizedBox(height: 1.h),

                    // Horizontal Scroll List
                    SizedBox(
                      height: 42.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: products.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 2.w),
                        itemBuilder: (context, prodIndex) {
                          return SizedBox(
                            width: 50.w, // Fixed Width to match Offers
                            child: ProductCardWidget(
                              isHomeScreen: true,
                              product: products[prodIndex],
                              screen: "home",
                            ),
                          );
                        },
                      ),
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
              ),
            );
        }
      },
    );
  }
}

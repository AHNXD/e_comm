// ignore_for_file: use_build_context_synchronously

import 'package:e_comm/Future/Auth/Widgets/my_button_widget.dart';
import 'package:e_comm/Future/Auth/cubit/auth_cubit.dart';
import 'package:e_comm/Future/Home/Blocs/get_latest_products/get_latest_products_bloc.dart';
import 'package:e_comm/Future/Home/Blocs/get_offers/get_offers_bloc.dart';
import 'package:e_comm/Future/Home/Cubits/getCatigories/get_catigories_cubit.dart';
import 'package:e_comm/Future/Home/Pages/about_us_screen.dart';
import 'package:e_comm/Future/Home/Pages/maintenance_order.dart';
import 'package:e_comm/Future/Home/Pages/print_image.dart';
import 'package:e_comm/Future/Home/Pages/sell_prodact.dart';
import 'package:e_comm/Future/Home/Cubits/locale/locale_cubit.dart';
import 'package:e_comm/Utils/SharedPreferences/SharedPreferencesHelper.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:e_comm/Utils/constants.dart';
import 'package:e_comm/Utils/functions.dart';
import 'package:e_comm/Utils/images.dart';
import 'package:e_comm/Utils/services/save.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../Blocs/get_categories/get_categories_bloc.dart';
import '../../Cubits/cartCubit/cart.bloc.dart';
import '../../Cubits/get_print_sizes_cubit/get_print_sizes_cubit.dart';
import '../../Pages/contact_us_screen.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                // height: 140.sp,
                // width: 50.sp,
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 5),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    AppImagesAssets.logoNoBg,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const Divider(
                thickness: 2,
                color: AppColors.buttonCategoryColor,
              ),
              MyButtonWidget(
                  text: "contact_us".tr(context),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ContactUsScreen()));
                  },
                  verticalHieght: 1.h,
                  horizontalWidth: 2.w,
                  color: AppColors.buttonCategoryColor),
              MyButtonWidget(
                  text: "about_us".tr(context),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AboutUsScreen()));
                  },
                  verticalHieght: 1.h,
                  horizontalWidth: 2.w,
                  color: AppColors.buttonCategoryColor),
              const Divider(
                thickness: 2,
                color: AppColors.buttonCategoryColor,
              ),
              MyButtonWidget(
                  text: "sell_product".tr(context),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SellProdact()));
                  },
                  verticalHieght: 1.h,
                  horizontalWidth: 2.w,
                  color: AppColors.buttonCategoryColor),
              MyButtonWidget(
                  text: "maintenance_btn".tr(context),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MaintenanceScreen()));
                  },
                  verticalHieght: 1.h,
                  horizontalWidth: 2.w,
                  color: AppColors.buttonCategoryColor),
              MyButtonWidget(
                  text: "print_image_order_btn".tr(context),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PrintImageScreen()));
                  },
                  verticalHieght: 1.h,
                  horizontalWidth: 2.w,
                  color: AppColors.buttonCategoryColor),
              const Divider(
                thickness: 2,
                color: AppColors.buttonCategoryColor,
              ),
              MyButtonWidget(
                  text: "language".tr(context),
                  onPressed: () async {
                    String langCode =
                        await SaveService.retrieve("LOCALE") ?? "en";
                    lang = langCode == "en" ? "ar" : "en";
                    changeLang(context);
                    // context.read<GetOffersCubit>().getOffers();
                    // context.read<GetProductsCubit>().getProducts();
                    //context.read<FavoriteCubit>().getProductsFavorite();
                    //context.read<GetMyOrdersCubit>().getMyOrders();
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      Navigator.pop(context);
                      massege(context, "change_lang".tr(context), Colors.green);
                    });
                  },
                  verticalHieght: 1.h,
                  horizontalWidth: 2.w,
                  color: AppColors.buttonCategoryColor),
              !AppSharedPreferences.hasToken
                  ? Column(
                      children: [
                        MyButtonWidget(
                            text: "logIn".tr(context),
                            onPressed: () {},
                            verticalHieght: 1.h,
                            horizontalWidth: 2.w,
                            color: AppColors.buttonCategoryColor),
                        MyButtonWidget(
                            text: "signUp".tr(context),
                            onPressed: () {},
                            verticalHieght: 1.h,
                            horizontalWidth: 2.w,
                            color: AppColors.buttonCategoryColor),
                      ],
                    )
                  : MyButtonWidget(
                      text: "logOut".tr(context),
                      onPressed: () {
                        context.read<AuthCubit>().logOut();
                      },
                      verticalHieght: 1.h,
                      horizontalWidth: 2.w,
                      color: AppColors.buttonCategoryColor),
            ],
          ),
        ),
      ),
    );
  }

  void changeLang(BuildContext context) {
    context.read<LocaleCubit>().changeLanguage(lang);
    getCategorisONChangeLang(context);
    getOffersOnChangeLang(context);
    getLatestProductsOnChangeLang(context);
    context.read<GetCatigoriesCubit>().getCatigories();
    context.read<CartCubit>().refreshCartOnLanguageChange();
    context.read<GetPrintSizesCubit>().getPrintSizes();
  }

  void getCategorisONChangeLang(BuildContext context) {
    context.read<GetCategoriesBloc>().add(ResetPaginationCategoriesEvent());
    context.read<GetCategoriesBloc>().add(GetAllCategoriesEvent());
  }

  void getOffersOnChangeLang(BuildContext context) {
    context.read<GetOffersBloc>().add(ResetPaginationAllOffersEvent());
    context.read<GetOffersBloc>().add(GetAllOffersEvent());
  }

  void getLatestProductsOnChangeLang(BuildContext context) {
    context
        .read<GetLatestProductsBloc>()
        .add(ResetPaginationAllLatestProductsEvent());
    context.read<GetLatestProductsBloc>().add(GetAllLatestProductsEvent());
  }
}

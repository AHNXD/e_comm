// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:zein_store/Future/Auth/Widgets/my_button_widget.dart';
import 'package:zein_store/Future/Auth/cubit/auth_cubit.dart';
import 'package:zein_store/Future/Home/Blocs/get_latest_products/get_latest_products_bloc.dart';
import 'package:zein_store/Future/Home/Blocs/get_offers/get_offers_bloc.dart';
import 'package:zein_store/Future/Home/Cubits/delete_profile/delete_profile_cubit.dart';
import 'package:zein_store/Future/Home/Pages/about_us_screen.dart';
import 'package:zein_store/Future/Home/Pages/edit_profile.dart';
import 'package:zein_store/Future/Home/Pages/maintenance_order.dart';
import 'package:zein_store/Future/Home/Pages/print_image.dart';
import 'package:zein_store/Future/Home/Pages/sell_prodact.dart';
import 'package:zein_store/Future/Home/Cubits/locale/locale_cubit.dart';
import 'package:zein_store/Utils/SharedPreferences/SharedPreferencesHelper.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';
import 'package:zein_store/Utils/constants.dart';
import 'package:zein_store/Utils/functions.dart';
import 'package:zein_store/Utils/images.dart';
import 'package:zein_store/Utils/services/save.dart';
import 'package:zein_store/conditionsScreen.dart';
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
    void showAwesomeDialog(
        {required String tilte, required String message}) async {
      await AwesomeDialog(
        descTextStyle: TextStyle(fontSize: 12.sp),
        title: tilte,
        desc: message,
        btnOkText: "ok".tr(context),
        btnOkColor: AppColors.primaryColors,
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        btnOkOnPress: () {
          context.read<DeleteProfileCubit>().deleteProfile();
        },
      ).show();
    }

    return SafeArea(
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Image.asset(
                AppImagesAssets.logoNoBg,
                height: 20.h,
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
              MyButtonWidget(
                  text: "title_conditions".tr(context),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            const ConditionsScreen(home: true)));
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
              MyButtonWidget(
                  text: "edit_profile".tr(context),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const EditeProfile()));
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
              const Divider(
                thickness: 2,
                color: AppColors.buttonCategoryColor,
              ),
              MyButtonWidget(
                  text: "delete_account".tr(context),
                  onPressed: () {
                    showAwesomeDialog(
                      tilte: "delete_account".tr(context),
                      message: "delete_account_msg".tr(context),
                    );
                  },
                  verticalHieght: 1.h,
                  horizontalWidth: 2.w,
                  color: Colors.red),
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

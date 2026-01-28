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
import 'package:zein_store/Future/Home/Pages/order_prodcut_screen.dart';
import 'package:zein_store/Future/Home/Pages/print_image.dart';
import 'package:zein_store/Future/Home/Pages/sell_prodact.dart';
import 'package:zein_store/Future/Home/Cubits/locale/locale_cubit.dart';
import 'package:zein_store/Utils/SharedPreferences/SharedPreferencesHelper.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';
import 'package:zein_store/Utils/constants.dart';
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
    void showDeleteDialog() {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: "delete_account".tr(context),
        desc: "delete_account_msg".tr(context),
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          context.read<DeleteProfileCubit>().deleteProfile();
        },
        btnOkColor: const Color(0xFFFF5252),
        btnCancelColor: Colors.grey,
        btnOkText: "yes".tr(context),
        btnCancelText: "no".tr(context),
      ).show();
    }

    // Standard Navigation Helper
    void navigateTo(Widget page) {
      Navigator.pop(context); // Close drawer first
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
    }

    return Drawer(
      backgroundColor: const Color(0xFFFDFDFD),
      elevation: 0,
      width: 80.w, // Slightly wider for better breathing room
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        children: [
          // --- 1. Header Area ---
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 5.h, 20, 20),
            decoration: BoxDecoration(
              color: AppColors.primaryColors.withOpacity(0.05),
              borderRadius:
                  const BorderRadius.only(topRight: Radius.circular(30)),
            ),
            child: Hero(
              tag: 'drawer_logo',
              child: Image.asset(AppImagesAssets.logoNoBg, height: 12.h),
            ),
          ),

          // --- 2. Scrollable Menu Items ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              physics: const BouncingScrollPhysics(),
              children: [
                // Section: GENERAL
                _SectionLabel(title: "general".tr(context).toUpperCase()),
                _DrawerTile(
                  icon: Icons.info_outline_rounded,
                  title: "about_us".tr(context),
                  onTap: () => navigateTo(const AboutUsScreen()),
                ),
                _DrawerTile(
                  icon: Icons.headset_mic_outlined,
                  title: "contact_us".tr(context),
                  onTap: () => navigateTo(const ContactUsScreen()),
                ),
                _DrawerTile(
                  icon: Icons.gavel_rounded,
                  title: "title_conditions".tr(context),
                  onTap: () => navigateTo(const ConditionsScreen(home: true)),
                ),

                const SizedBox(height: 16),

                // Section: SERVICES
                _SectionLabel(title: "services".tr(context).toUpperCase()),
                _DrawerTile(
                  icon: Icons.sell_outlined,
                  title: "sell_product".tr(context),
                  onTap: () => navigateTo(const SellProdact()),
                ),
                _DrawerTile(
                  icon: Icons.shopping_basket_outlined,
                  title: "order_product".tr(context),
                  onTap: () => navigateTo(const OrderProduct()),
                ),
                _DrawerTile(
                  icon: Icons.build_circle_outlined,
                  title: "maintenance_btn".tr(context),
                  onTap: () => navigateTo(const MaintenanceScreen()),
                ),
                _DrawerTile(
                  icon: Icons.print_rounded,
                  title: "print_image_order_btn".tr(context),
                  onTap: () => navigateTo(const PrintImageScreen()),
                ),

                const SizedBox(height: 16),

                // Section: SETTINGS
                _SectionLabel(title: "settings".tr(context).toUpperCase()),
                _DrawerTile(
                  icon: Icons.language_rounded,
                  title: "language".tr(context),
                  trailing: Text(
                    lang == 'en' ? '🇺🇸' : '🇸🇾',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  onTap: () async {
                    String langCode =
                        await SaveService.retrieve("LOCALE") ?? "en";
                    lang = langCode == "en" ? "ar" : "en";
                    changeLang(context);
                    await Future.delayed(const Duration(milliseconds: 300), () {
                      Navigator.pop(context);
                      // Optional: Restart app or show snackbar
                    });
                  },
                ),
                _DrawerTile(
                  icon: Icons.person_outline_rounded,
                  title: "edit_profile".tr(context),
                  onTap: () => navigateTo(const EditeProfile()),
                ),
              ],
            ),
          ),

          // --- 3. Footer (Login/Logout/Delete) ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              children: [
                if (!AppSharedPreferences.hasToken) ...[
                  // Login / Signup Row
                  Row(
                    children: [
                      Expanded(
                        child: MyButtonWidget(
                          text: "logIn".tr(context),
                          icon: Icons.login_rounded,
                          color: AppColors.primaryColors,
                          onPressed: () {
                            // Navigate to login
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyButtonWidget(
                          text: "signUp".tr(context),
                          isOutlined: true,
                          color: AppColors.primaryColors,
                          onPressed: () {
                            // Navigate to signup
                          },
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  MyButtonWidget(
                    text: "logOut".tr(context),
                    icon: Icons.logout_rounded,
                    color: const Color(0xFF6C757D), // Grey for logout
                    onPressed: () => context.read<AuthCubit>().logOut(),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: showDeleteDialog,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "delete_account".tr(context),
                        style: TextStyle(
                          color: Colors.red[400],
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void changeLang(BuildContext context) {
    context.read<LocaleCubit>().changeLanguage(lang);
    context.read<GetCategoriesBloc>().add(ResetPaginationCategoriesEvent());
    context.read<GetCategoriesBloc>().add(GetAllCategoriesEvent());
    context.read<GetOffersBloc>().add(ResetPaginationAllOffersEvent());
    context.read<GetOffersBloc>().add(GetAllOffersEvent());
    context
        .read<GetLatestProductsBloc>()
        .add(ResetPaginationAllLatestProductsEvent());
    context.read<GetLatestProductsBloc>().add(GetAllLatestProductsEvent());
    context.read<CartCubit>().refreshCartOnLanguageChange();
    context.read<GetPrintSizesCubit>().getPrintSizes();
  }
}

// --- Helper: Section Label ---
class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 9.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// --- Helper: Drawer Menu Tile ---
class _DrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Widget? trailing;

  const _DrawerTile({
    required this.title,
    required this.icon,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: AppColors.primaryColors.withOpacity(0.1),
          highlightColor: AppColors.primaryColors.withOpacity(0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              // color: Colors.white, // Uncomment for card style
              // border: Border.all(color: Colors.grey.shade100), // Uncomment for card style
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColors.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child:
                      Icon(icon, size: 14.sp, color: AppColors.primaryColors),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D2D2D),
                    ),
                  ),
                ),
                if (trailing != null)
                  trailing!
                else
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 10.sp, color: Colors.grey[300])
              ],
            ),
          ),
        ),
      ),
    );
  }
}

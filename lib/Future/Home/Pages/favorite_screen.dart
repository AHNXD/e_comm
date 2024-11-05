import 'package:e_comm/Future/Home/Cubits/cartCubit/cart.bloc.dart';
import 'package:e_comm/Future/Home/Widgets/error_widget.dart';
import 'package:e_comm/Future/Home/Widgets/home_screen/appbar_widget.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../Cubits/favoriteCubit/favorite_cubit.dart';
import '../Widgets/product_Screen/custom_gridView.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

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

    context.read<FavoriteCubit>().getProductsFavorite();
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is AddToCartState) {
          showMessage('add_product_done'.tr(context), Colors.green);
        } else if (state is AlreadyInCartState) {
          showMessage('product_in_cart'.tr(context), Colors.grey);
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 8.h),
          child: AppBarWidget(
            isHome: false,
            title: "fav_screen_title".tr(context),
          ),
          // child: AppBar(
          //   scrolledUnderElevation: 0,
          //   backgroundColor: Colors.white,
          //   centerTitle: true,
          //   title: Padding(
          //     padding: const EdgeInsets.only(top: 15.0),
          //     child: Text(
          //       "fav_screen_title".tr(context),
          //       style: const TextStyle(
          //           fontWeight: FontWeight.bold,
          //           color: AppColors.primaryColors),
          //     ),
          //   ),
          // ),
        ),
        body: BlocConsumer<FavoriteCubit, FavoriteState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is GetFavoriteProductsSuccessfulState) {
              if (state.fvModel!.isEmpty) {
                return Center(
                  child: Text(
                    "fav_body_msg".tr(context),
                  ),
                );
              } else {
                return ListView(
                  children: [
                    CustomGridVeiw(
                      products: state.fvModel!,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                  ],
                );
              }
            } else if (state is FavoriteProductsErrorState) {
              return MyErrorWidget(
                  msg: state.message,
                  onPressed: () {
                    context.read<FavoriteCubit>().getProductsFavorite();
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

import 'package:zein_store/Future/Home/Cubits/cartCubit/cart.bloc.dart';
import 'package:zein_store/Future/Home/Widgets/custom_lazy_load_grid_view.dart';
import 'package:zein_store/Future/Home/Widgets/error_widget.dart';
import 'package:zein_store/Future/Home/Widgets/home_screen/appbar_widget.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../Blocs/get_favorite/get_favorite_bloc.dart';
import '../Widgets/custom_circular_progress_indicator.dart';
import '../Widgets/custom_snak_bar.dart';
import '../Widgets/home_screen/product_card_widget.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    context.read<GetFavoriteBloc>().add(RestPagination());
    context.read<GetFavoriteBloc>().add(GetAllFavoriteEvent());
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.hasClients) {
      final currentScroll = scrollController.offset;
      final maxScroll = scrollController.position.maxScrollExtent;

      if (currentScroll >= (maxScroll * 0.9)) {
        context.read<GetFavoriteBloc>().add(GetAllFavoriteEvent());
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Note: Removed the duplicate GetAllFavoriteEvent() call here.
    // It is already called in initState. Calling it in build causes loops.

    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is AddToCartFromFavState) {
          CustomSnackBar.showMessage(
              context, 'add_product_done'.tr(context), Colors.green);
        } else if (state is AlreadyInCartFromFavState) {
          CustomSnackBar.showMessage(
              context, 'product_in_cart'.tr(context), Colors.grey);
        }
      },
      child: Scaffold(
        backgroundColor:
            const Color(0xFFF9F9F9), // Light background to make cards pop
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 8.h),
          child: AppBarWidget(
            isHome: false,
            title: "fav_screen_title".tr(context),
          ),
        ),
        body: BlocBuilder<GetFavoriteBloc, GetFavoriteState>(
          builder: (context, state) {
            switch (state.status) {
              case GetFavoriteStatus.loading:
                return const Center(
                  child: CustomCircularProgressIndicator(),
                );
              case GetFavoriteStatus.error:
                return MyErrorWidget(
                    msg: state.errorMsg,
                    onPressed: () {
                      context
                          .read<GetFavoriteBloc>()
                          .add(GetAllFavoriteEvent());
                    });
              case GetFavoriteStatus.success:
                if (state.favoriteProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border,
                            size: 40.sp, color: Colors.grey[300]),
                        SizedBox(height: 2.h),
                        Text(
                          "fav_body_msg".tr(context),
                          style: TextStyle(
                              color: Colors.grey[500], fontSize: 12.sp),
                        ),
                      ],
                    ),
                  );
                }
                return ListView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 5.h), // Bottom padding
                  children: [
                    CustomLazyLoadGridView(
                      hasReachedMax: state.hasReachedMax,
                      items: state.favoriteProducts,
                      // Optional: Adjust aspect ratio manually here if needed.
                      // 0.62 is the default in the widget now, which fits the new card.
                      childAspectRatio: 0.62,
                      itemBuilder: (context, favoriteProduct) {
                        return ProductCardWidget(
                            isHomeScreen: false,
                            product: favoriteProduct,
                            screen: "fav");
                      },
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}

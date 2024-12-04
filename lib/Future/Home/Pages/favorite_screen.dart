import 'package:e_comm/Future/Home/Cubits/cartCubit/cart.bloc.dart';
import 'package:e_comm/Future/Home/Widgets/custom_lazy_load_grid_view.dart';
import 'package:e_comm/Future/Home/Widgets/error_widget.dart';
import 'package:e_comm/Future/Home/Widgets/home_screen/appbar_widget.dart';
import 'package:e_comm/Utils/app_localizations.dart';
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
    context.read<GetFavoriteBloc>().add(RestPagination());
    context.read<GetFavoriteBloc>().add(GetAllFavoriteEvent());
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    final currentScroll = scrollController.offset;
    final maxScroll = scrollController.position.maxScrollExtent;

    if (currentScroll >= (maxScroll * 0.9)) {
      context.read<GetFavoriteBloc>().add(GetAllFavoriteEvent());
    }
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<GetFavoriteBloc>().add(GetAllFavoriteEvent());
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
                    child: Text(
                      "fav_body_msg".tr(context),
                    ),
                  );
                }
                return ListView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    CustomLazyLoadGridView(
                      hasReachedMax: state.hasReachedMax,
                      items: state.favoriteProducts,
                      itemBuilder: (context, favoriteProduct) {
                        return ProductCardWidget(
                            isHomeScreen: false,
                            product: favoriteProduct,
                            addToCartPaddingButton: 3.w,
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

import 'package:e_comm/Future/Home/Blocs/get_offers/get_offers_bloc.dart';
import 'package:e_comm/Future/Home/Cubits/cartCubit/cart.bloc.dart';
import 'package:e_comm/Future/Home/Widgets/custom_lazy_load_grid_view.dart';
import 'package:e_comm/Future/Home/Widgets/error_widget.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../Widgets/custom_circular_progress_indicator.dart';
import '../Widgets/custom_snak_bar.dart';
import '../Widgets/home_screen/product_card_widget.dart';

class AllOffersScreen extends StatefulWidget {
  const AllOffersScreen({super.key});

  @override
  State<AllOffersScreen> createState() => _AllOffersScreenScreenState();
}

class _AllOffersScreenScreenState extends State<AllOffersScreen> {
  late ScrollController scrollController;
  @override
  void initState() {
    context.read<GetOffersBloc>().add(ResetPaginationAllOffersEvent());
    context.read<GetOffersBloc>().add(GetAllOffersEvent());
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    final currentScroll = scrollController.offset;
    final maxScroll = scrollController.position.maxScrollExtent;

    if (currentScroll >= (maxScroll * 0.9)) {
      context.read<GetOffersBloc>().add(GetAllOffersEvent());
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
    context.read<GetOffersBloc>().add(GetAllOffersEvent());
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is AddedTocartFromHomeScreen) {
          CustomSnackBar.showMessage(
              context, 'add_product_done'.tr(context), Colors.green);
        } else if (state is AlreadyInCartFromHomeState) {
          CustomSnackBar.showMessage(
              context, 'product_in_cart'.tr(context), Colors.grey);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          centerTitle: true,
          backgroundColor: AppColors.primaryColors,
          title: Text(
            "offers_screen_title".tr(context),
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
        body: BlocBuilder<GetOffersBloc, GetOffersState>(
          builder: (context, state) {
            switch (state.status) {
              case GetOffersStatus.loading:
                return const Center(
                  child: CustomCircularProgressIndicator(),
                );
              case GetOffersStatus.error:
                return MyErrorWidget(
                    msg: state.errorMsg,
                    onPressed: () {
                      context.read<GetOffersBloc>().add(GetAllOffersEvent());
                    });
              case GetOffersStatus.success:
                if (state.offersProducts.isEmpty) {
                  return Center(
                    child: Text(
                      "no_offers".tr(context),
                    ),
                  );
                }
                return ListView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    CustomLazyLoadGridView(
                      hasReachedMax: state.hasReachedMax,
                      items: state.offersProducts,
                      itemBuilder: (context, favoriteProduct) {
                        return ProductCardWidget(
                            isHomeScreen: false,
                            product: favoriteProduct,
                            addToCartPaddingButton: 3.w,
                            screen: "home");
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

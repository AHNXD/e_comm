import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:zein_store/Future/Home/Blocs/get_offers/get_offers_bloc.dart';
import 'package:zein_store/Future/Home/Cubits/cartCubit/cart.bloc.dart';
import 'package:zein_store/Future/Home/Widgets/custom_lazy_load_grid_view.dart';
import 'package:zein_store/Future/Home/Widgets/error_widget.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';
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
    super.initState();
    // Initialize Logic
    context.read<GetOffersBloc>().add(ResetPaginationAllOffersEvent());
    context.read<GetOffersBloc>().add(GetAllOffersEvent());

    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.hasClients) {
      final currentScroll = scrollController.offset;
      final maxScroll = scrollController.position.maxScrollExtent;

      if (currentScroll >= (maxScroll * 0.9)) {
        context.read<GetOffersBloc>().add(GetAllOffersEvent());
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
    // Note: Removed the side-effect API call from build()

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
        backgroundColor: const Color(0xFFF9F9F9), // Consistent background
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primaryColors.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.primaryColors, size: 16.sp),
            ),
          ),
          title: Text(
            "offers_screen_title".tr(context),
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textTitleAppBarColor),
          ),
        ),
        body: BlocBuilder<GetOffersBloc, GetOffersState>(
          builder: (context, state) {
            switch (state.status) {
              case GetOffersStatus.loading:
                return const Center(child: CustomCircularProgressIndicator());

              case GetOffersStatus.error:
                return Center(
                  child: MyErrorWidget(
                      msg: state.errorMsg,
                      onPressed: () {
                        context
                            .read<GetOffersBloc>()
                            .add(ResetPaginationAllOffersEvent());
                        context.read<GetOffersBloc>().add(GetAllOffersEvent());
                      }),
                );

              case GetOffersStatus.success:
                if (state.offersProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.local_offer_outlined,
                              size: 40.sp, color: Colors.grey),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "no_offers".tr(context),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(top: 1.h, bottom: 5.h),
                  children: [
                    CustomLazyLoadGridView(
                      hasReachedMax: state.hasReachedMax,
                      items: state.offersProducts,
                      // IMPT: Use 0.62 to match the new Card Design dimensions
                      childAspectRatio: 0.62,
                      itemBuilder: (context, product) {
                        return ProductCardWidget(
                            isHomeScreen: false,
                            product: product,
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

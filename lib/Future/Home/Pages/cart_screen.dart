import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:zein_store/Future/Home/Widgets/error_widget.dart';
import 'package:zein_store/Future/Home/Widgets/home_screen/appbar_widget.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:sizer/sizer.dart';
import '../../../Utils/colors.dart';
import '../Widgets/custom_circular_progress_indicator.dart';
import '../Widgets/scroll_top_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Cubits/cartCubit/cart.bloc.dart';
import '../Widgets/cartScreen1/cart_tile.dart';
import '../Widgets/cartScreen1/check_out_box.dart';

class CartScreen1 extends StatefulWidget {
  const CartScreen1({super.key});

  @override
  State<CartScreen1> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen1> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().refreshCartOnLanguageChange();
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 85.0),
        child: ScrollToTopButton(scrollController: scrollController),
      ),
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 8.h),
        child: AppBarWidget(
          isHome: false,
          title: "cart_screen_title".tr(context),
        ),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is EmptyCartState ||
              context.read<CartCubit>().pcw.isEmpty) {
            return Center(
              child: Text("empty_cart".tr(context)),
            );
          } else if (state is GetCartSuccessfulState) {
            return CartListViewItem(
              scrollController: scrollController,
            );
          } else if (state is CartLoadingState) {
            return const Center(child: CustomCircularProgressIndicator());
          } else if (state is CartErrorState) {
            return MyErrorWidget(
                msg: state.errorMessage,
                onPressed:
                    context.read<CartCubit>().refreshCartOnLanguageChange);
          } else {
            return CartListViewItem(
              scrollController: scrollController,
            );
          }
        },
      ),
    );
  }
}

class CartListViewItem extends StatelessWidget {
  const CartListViewItem({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    void showAwesomeDialog(
        {required String message, required int index}) async {
      await AwesomeDialog(
              descTextStyle: TextStyle(fontSize: 15.sp),
              btnOkText: "yes".tr(context),
              btnCancelText: "no".tr(context),
              btnOkColor: Colors.red,
              btnCancelColor: Colors.green,
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.scale,
              title: message,
              btnOkOnPress: () {
                context.read<CartCubit>().pcw[index].userQuantity = 1;
                context
                    .read<CartCubit>()
                    .removeformTheCart(context.read<CartCubit>().pcw[index]);
              },
              btnCancelOnPress: () {})
          .show();
    }

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return SingleChildScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
            child: Column(
              children: [
                CheckOutBox(
                  items: context.read<CartCubit>().pcw,
                ),
                SizedBox(
                  height: 1.h,
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: context.read<CartCubit>().pcw.length,
                  itemBuilder: (context, index) => CartTile(
                    deleteProduct: () {
                      showAwesomeDialog(
                          index: index,
                          message: "delete_product_msg".tr(context));
                    },
                    product: context.read<CartCubit>().pcw[index],
                    onRemove: () {
                      if (context.read<CartCubit>().pcw[index].userQuantity >
                          1) {
                        context.read<CartCubit>().decreaseQuantity(
                            context.read<CartCubit>().pcw[index]);
                      }
                    },
                    onAdd: () {
                      context.read<CartCubit>().increaseQuantity(
                          context.read<CartCubit>().pcw[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

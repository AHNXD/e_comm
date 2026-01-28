import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:zein_store/Future/Home/Widgets/error_widget.dart';
import 'package:zein_store/Future/Home/Widgets/home_screen/appbar_widget.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:sizer/sizer.dart';
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
    // Refresh cart on init to ensure language/currency is correct
    context.read<CartCubit>().refreshCartOnLanguageChange();
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Cleaner light grey
      floatingActionButton:
          ScrollToTopButton(scrollController: scrollController),

      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 8.h),
        child: AppBarWidget(
          isHome: false,
          title: "cart_screen_title".tr(context),
        ),
      ),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          // You can handle snackbars here if needed
        },
        builder: (context, state) {
          if (state is CartLoadingState) {
            return const Center(child: CustomCircularProgressIndicator());
          } else if (state is CartErrorState) {
            return Center(
              child: MyErrorWidget(
                  msg: state.errorMessage,
                  onPressed:
                      context.read<CartCubit>().refreshCartOnLanguageChange),
            );
          } else if (context.read<CartCubit>().pcw.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 40.sp, color: Colors.grey[300]),
                  SizedBox(height: 2.h),
                  Text("empty_cart".tr(context),
                      style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            );
          } else {
            return CartListViewItem(scrollController: scrollController);
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
    void showDeleteDialog({required int index}) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: "delete_product_msg".tr(context),
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          final cartCubit = context.read<CartCubit>();
          final item = cartCubit.pcw[index];
          // Reset quantity logic if needed or just remove
          item.userQuantity = 1;
          cartCubit.removeformTheCart(item);
        },
        btnOkColor: const Color(0xFFFF5252),
        btnCancelColor: Colors.grey,
        btnOkText: "yes".tr(context),
        btnCancelText: "no".tr(context),
      ).show();
    }

    return SingleChildScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding:
          EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 12.h), // Bottom padding for FAB
      child: Column(
        children: [
          // Checkout Summary Box
          CheckOutBox(items: context.read<CartCubit>().pcw),

          SizedBox(height: 2.h),

          // Cart Items List
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: context.read<CartCubit>().pcw.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.5.h),
            itemBuilder: (context, index) {
              final product = context.read<CartCubit>().pcw[index];
              return CartTile(
                product: product,
                deleteProduct: () => showDeleteDialog(index: index),
                onRemove: () {
                  if (product.userQuantity > 1) {
                    context.read<CartCubit>().decreaseQuantity(product);
                  }
                },
                onAdd: () {
                  context.read<CartCubit>().increaseQuantity(product);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

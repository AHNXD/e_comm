import 'package:e_comm/Future/Home/Widgets/error_widget.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:sizer/sizer.dart';
import '../../../Utils/colors.dart';
import '/Future/Home/models/product_model.dart';
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
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 85.0),
        child: ScrollToTopButton(scrollController: scrollController),
      ),
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 10.h),
        child: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              "cart_screen_title".tr(context),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.primaryColors),
            ),
          ),
        ),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          List<MainProduct> l = context.read<CartCubit>().pcw;
          if (state is EmptyCartState || l.isEmpty) {
            return Center(
              child: Text("empty_cart".tr(context)),
            );
          } else if (state is CartRefreshState) {
            return CartListViewItem(
              l: state.loadedporduct,
              scrollController: scrollController,
            );
          } else if (state is RemvoeFromCartState) {
            return CartListViewItem(
              l: state.porducts,
              scrollController: scrollController,
            );
          } else if (state is CartLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CartErrorState) {
            return MyErrorWidget(
                msg: state.errorMessage,
                onPressed:
                    context.read<CartCubit>().refreshCartOnLanguageChange);
          } else {
            return CartListViewItem(
              l: l,
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
    required this.l,
    required this.scrollController,
  });

  final List<MainProduct> l;
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
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
              itemCount: l.length,
              itemBuilder: (context, index) => CartTile(
                deleteProduct: () {
                  context.read<CartCubit>().pcw[index].userQuantity = 1;
                  context.read<CartCubit>().removeformTheCart(l[index]);
                },
                product: l[index],
                onRemove: () {
                  if (l[index].userQuantity > 1) {
                    context.read<CartCubit>().decreaseQuantity(l[index]);
                  }
                },
                onAdd: () {
                  context.read<CartCubit>().increaseQuantity(l[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScrollToTopButton extends StatelessWidget {
  final ScrollController scrollController;

  const ScrollToTopButton({super.key, required this.scrollController});

  void _scrollToTop() {
    scrollController.animateTo(
      0.0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.navBarColor,
      onPressed: _scrollToTop,
      tooltip: 'Scroll to Top',
      child: const Icon(
        Icons.arrow_upward,
        color: Colors.black,
      ),
    );
  }
}

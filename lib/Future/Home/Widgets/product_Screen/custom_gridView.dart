import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../models/product_model.dart';
import '../home_screen/product_card_widget.dart';

class CustomGridVeiw extends StatelessWidget {
  const CustomGridVeiw(
      {super.key, required this.products, this.physics, this.shrinkWrap});
  final List<MainProduct> products;
  final ScrollPhysics? physics;
  final bool? shrinkWrap;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    int selectScreenWidth(screenWidth) {
      if (screenWidth <= 280) {
        return 1;
      }
      return 2;
    }

    double selectAspectRatio(screenWidth, screenHeight) {
      if (screenWidth <= 280) {
        return screenWidth / (screenHeight) * 2.3;
      } else if (screenWidth > 280 && screenWidth < 450) {
        return screenWidth / (screenHeight) * 0.92;
      } else if (screenWidth >= 450 && screenWidth < 600) {
        return screenWidth / (screenHeight) * 0.82;
      } else if (screenWidth >= 600 && screenWidth < 900) {
        return screenWidth / (screenHeight) * 0.55;
      }
      return screenWidth / (screenHeight) * 0.3;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: physics ?? const BouncingScrollPhysics(),
        shrinkWrap: shrinkWrap ?? false,
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.45,
            crossAxisCount: selectScreenWidth(screenWidth),
            crossAxisSpacing: 4.w,
            mainAxisSpacing: 1.h),
        itemBuilder: (context, index) {
          return ProductCardWidget(
            isHomeScreen: false,
            product: products[index],
            addToCartPaddingButton: 3.w,
          );
        },
      ),
    );
  }
}

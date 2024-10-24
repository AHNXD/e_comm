import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../models/product_model.dart';

class PrudoctDaitlesCart extends StatelessWidget {
  const PrudoctDaitlesCart({
    super.key,
    required this.product,
  });

  final MainProduct product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          product.name!,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 1.h),
        if (product.selectedSize != null &&
            product.selectedSize != "NULL" &&
            product.selectedSize!.isNotEmpty)
          Text(
            "size: ${product.selectedSize}",
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.grey.shade600,
            ),
          ),
        SizedBox(height: 1.h),
        if (product.isOffer != null && product.isOffer == true)
          CircleAvatar(
            backgroundColor: Colors.red,
            child: Text(
              "${(1 - (double.tryParse(product.offers!.priceAfterOffer!)! / double.tryParse(product.offers!.priceAfterOffer!)!)) * 100}%",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}

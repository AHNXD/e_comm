import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sizer/sizer.dart';

import '../../models/product_model.dart';
import 'constants.dart';

class QauntityButton extends StatelessWidget {
  const QauntityButton({
    super.key,
    required this.onRemove,
    required this.product,
    required this.onAdd,
  });

  final Function() onRemove;
  final MainProduct product;
  final Function() onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: kcontentColor,
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onRemove,
            iconSize: 18,
            icon: const Icon(
              Ionicons.remove_outline,
              color: Colors.black,
            ),
          ),
          Text(
            product.userQuantity.toString(),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
          IconButton(
            onPressed: onAdd,
            iconSize: 18,
            icon: const Icon(
              Ionicons.add_outline,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../models/product_model.dart';
import 'package:zein_store/Utils/colors.dart'; // Ensure AppColors is imported

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
      // Compact height/width logic
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7), // Very light grey background
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBtn(
              icon: Icons.remove,
              onTap: onRemove,
              isEnabled: product.userQuantity > 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              product.userQuantity.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11.sp,
                color: Colors.black87,
              ),
            ),
          ),
          _buildBtn(
              icon: Icons.add, onTap: onAdd, isEnabled: true, isAdd: true),
        ],
      ),
    );
  }

  Widget _buildBtn(
      {required IconData icon,
      required VoidCallback onTap,
      required bool isEnabled,
      bool isAdd = false}) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: 28,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isAdd
              ? AppColors.primaryColors[400]
              : Colors.transparent, // Highlight add button optionally
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isAdd
              ? Colors.white
              : (isEnabled ? Colors.black87 : Colors.grey[300]),
        ),
      ),
    );
  }
}

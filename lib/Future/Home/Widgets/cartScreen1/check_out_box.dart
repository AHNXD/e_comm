import 'package:e_comm/Future/Home/Pages/cart_information.dart';
import 'package:e_comm/Future/Home/Widgets/custom_note_label.dart';
import 'package:e_comm/Future/Home/models/product_model.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CheckOutBox extends StatelessWidget {
  final List<MainProduct> items;
  const CheckOutBox({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26.h,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "total_price".tr(context),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    "${items.length > 1 ? items.map((e) => (e.userQuantity * (e.newSellingPrice == null ? e.sellingPrice : double.tryParse(e.newSellingPrice!))!)).reduce((value1, value2) => value1 + value2) : items[0].userQuantity * (items[0].newSellingPrice == null ? items[0].sellingPrice : double.tryParse(items[0].newSellingPrice!))!}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'sp'.tr(context),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (b) {
                  return const CartInformation();
                }));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonCategoryColor,
                minimumSize: const Size(double.infinity, 55),
              ),
              child: Text(
                "check_out".tr(context),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          CustomNoteLabel(
            noteText: "cart_note".tr(context),
          ),
        ],
      ),
    );
  }
}

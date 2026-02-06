import 'package:zein_store/Future/Home/Pages/cart_information.dart';
import 'package:zein_store/Future/Home/Widgets/custom_note_label.dart';
import 'package:zein_store/Future/Home/models/product_model.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';
import 'package:zein_store/Utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CheckOutBox extends StatelessWidget {
  final List<MainProduct> items;
  final String unit;
  const CheckOutBox({
    super.key,
    required this.items,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
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
                    "${formatter.format(items.length > 1 ? items.map((e) => (e.userQuantity * double.tryParse(e.isOffer == false ? e.sellingPrice! : e.offers!.priceAfterOffer!)!)).reduce((value1, value2) => value1 + value2) : items[0].userQuantity * double.tryParse(items[0].isOffer == false ? items[0].sellingPrice! : items[0].offers!.priceAfterOffer!)!)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    unit.tr(context),
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
          CustomNoteLabel(
            noteText: "cart_note".tr(context),
          ),
        ],
      ),
    );
  }
}

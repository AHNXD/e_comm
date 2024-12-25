import 'package:e_comm/Future/Home/models/product_model.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../Apis/Urls.dart';
import '../cached_network_image.dart';

class OrderTileWidget extends StatelessWidget {
  final MainProduct product;
  final String? size;
  final String? price;
  final int? qty;
  const OrderTileWidget(
      {super.key,
      required this.qty,
      required this.product,
      required this.size,
      required this.price});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$price ${"sp".tr(context)}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (size != null && size != "NULL" && size!.isNotEmpty)
            Text(
              "${'size'.tr(context)}: $size",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
      trailing: CircleAvatar(
        backgroundColor: AppColors.primaryColors,
        child: Text(
          qty.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        product.name!,
        style: const TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: MyCachedNetworkImage(
        height: 10.h,
        width: 10.w,
        imageUrl: product.files![0].path != null
            ? Urls.storageProducts + product.files![0].name!
            : product.files![0].name!,
      ),
    );
  }
}

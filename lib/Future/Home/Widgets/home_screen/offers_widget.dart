import 'package:e_comm/Apis/Urls.dart';
import 'package:e_comm/Future/Home/Cubits/favoriteCubit/favorite_cubit.dart';
import 'package:e_comm/Future/Home/Pages/product_details.dart';
import 'package:e_comm/Future/Home/models/product_model.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:e_comm/Utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../cached_network_image.dart';

class OffersWidget extends StatefulWidget {
  const OffersWidget({super.key, required this.data});
  final MainProduct data;

  @override
  State<OffersWidget> createState() => _OffersWidgetState();
}

class _OffersWidgetState extends State<OffersWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DetailPage(
            product: widget.data,
          );
        }));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
              // color: AppColors.primaryColors[400]!,
              color: Colors.red,
              blurRadius: 10,
              blurStyle: BlurStyle.solid,
              offset: Offset(0, 4))
        ], borderRadius: BorderRadius.circular(6.w), color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                BlocBuilder<FavoriteCubit, FavoriteState>(
                  builder: (context, state) {
                    return IconButton(
                        onPressed: () async {
                          widget.data.isFavorite = await context
                              .read<FavoriteCubit>()
                              .addAndDelFavoriteProducts(
                                widget.data.id!,
                              );
                          setState(() {
                            massege(
                                context,
                                widget.data.isFavorite
                                    ? "added_fav".tr(context)
                                    : "removed_fav".tr(context),
                                Colors.green);
                          });
                        },
                        icon: Icon(
                          widget.data.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: widget.data.isFavorite
                              ? AppColors.textTitleAppBarColor
                              : Colors.black,
                        ));
                  },
                ),
              ],
            ),
            MyCachedNetworkImage(
              width: 45.w,
              height: 10.h,
              imageUrl: widget.data.files!.first.path == null
                  ? widget.data.files!.first.name!
                  : Urls.storageCategories + widget.data.files!.first.name!,
            ),
            SizedBox(
              height: 1.h,
            ),
            Text(widget.data.name!,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textButtonColors,
                  fontSize: 13.sp,
                )),
            SizedBox(
              height: 1.h,
            ),
            Column(
              children: [
                Text(
                  "${formatter.format(double.parse(widget.data.sellingPrice!).toInt())} ${"sp".tr(context)}",
                  style: TextStyle(
                      color: AppColors.textButtonColors,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.lineThrough),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "${formatter.format(double.parse(widget.data.offers!.priceAfterOffer!).toInt())} ${"sp".tr(context)}",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.red),
                  child: Text(
                    "${(1 - (double.tryParse(widget.data.offers!.priceAfterOffer!)! / double.tryParse(widget.data.offers!.priceAfterOffer!)!)) * 100}%",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

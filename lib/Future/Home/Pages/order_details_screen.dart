import 'package:e_comm/Future/Home/Pages/product_details.dart';
import 'package:e_comm/Future/Home/Widgets/order_details_screen/OrderTileWidget.dart';
import 'package:e_comm/Future/Home/models/my_orders_information.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:e_comm/Utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen(
      {super.key, required this.isNotHome, required this.order});
  final bool isNotHome;
  final OrderInformationData order;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   style: ButtonStyle(
        //     backgroundColor: WidgetStateColor.resolveWith(
        //         (states) => AppColors.buttonCategoryColor),
        //   ),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        //   icon: SvgPicture.asset(
        //     AppImagesAssets.back,
        //     height: 3.h,
        //   ),
        //   color: Colors.white,
        //   iconSize: 20.sp,
        // ),
        // title: Text("orderDetails_screen_title".tr(context)),

        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.primaryColors,
        centerTitle: true,
        title: Text(
          "orderDetails_screen_title".tr(context),
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            OrderInfoTextWidget(
              title: "phone_number".tr(context),
              body: order.phone?.toString() ?? "",
              icon: Icons.phone,
            ),
            OrderInfoTextWidget(
              title: "province".tr(context),
              body: order.province?.toString() ?? "",
              icon: Icons.public,
            ),
            OrderInfoTextWidget(
              title: "region".tr(context),
              body: order.region?.toString() ?? "",
              icon: Icons.pin_drop,
            ),
            OrderInfoTextWidget(
              title: "address".tr(context),
              body: order.address?.toString() ?? "",
              icon: Icons.maps_home_work,
            ),
            OrderInfoTextWidget(
              title: "order_status".tr(context),
              body: order.status?.toString().tr(context) ?? "",
              icon: Icons.info,
            ),
            OrderInfoTextWidget(
              title: "order_total_price".tr(context),
              body: formatter.format(double.parse(order.total!).toInt()),
              icon: Icons.monetization_on_rounded,
            ),
            OrderInfoTextWidget(
              title: "order_notes".tr(context),
              body: order.notes?.toString() ?? "",
              icon: Icons.note_alt_sharp,
            ),
            const Divider(
              color: AppColors.borderColor,
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: order.details?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return DetailPage(
                          product: order.details![index].product!,
                        );
                      }));
                    },
                    child: OrderTileWidget(
                        size: order.details![index].size,
                        product: order.details![index].product!,
                        price: formatter.format(
                            double.parse(order.details![index].price!).toInt()),
                        qty: order.details![index].quantity),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OrderInfoTextWidget extends StatelessWidget {
  const OrderInfoTextWidget(
      {super.key, required this.title, required this.body, required this.icon});
  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primaryColors,
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      title: Text(
        "$title:",
        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        body,
        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
      ),
    );
  }
}

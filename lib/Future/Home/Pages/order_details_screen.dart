import 'package:e_comm/Future/Home/Widgets/order_details_screen/OrderTileWidget.dart';
import 'package:e_comm/Future/Home/models/my_orders_information.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              OrderInfoTextWidget(
                title: "phone_number".tr(context),
                body: order.phone?.toString() ?? "",
              ),
              OrderInfoTextWidget(
                title: "province".tr(context),
                body: order.province?.toString() ?? "",
              ),
              OrderInfoTextWidget(
                title: "region".tr(context),
                body: order.region?.toString() ?? "",
              ),
              OrderInfoTextWidget(
                title: "address".tr(context),
                body: order.address?.toString() ?? "",
              ),
              OrderInfoTextWidget(
                title: "order_status".tr(context),
                body: order.status?.toString() ?? "",
              ),
              OrderInfoTextWidget(
                title: "order_total_price".tr(context),
                body: order.total?.toString() ?? "",
              ),
              OrderInfoTextWidget(
                title: "order_notes".tr(context),
                body: order.notes?.toString() ?? "",
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
                    child: OrderTileWidget(
                      size: order.details![index].size,
                      product: order.details![index].product!,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderInfoTextWidget extends StatelessWidget {
  const OrderInfoTextWidget(
      {super.key, required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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

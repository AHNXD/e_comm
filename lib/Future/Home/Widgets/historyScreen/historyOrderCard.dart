import 'package:e_comm/Future/Home/Pages/order_details_screen.dart';
import 'package:e_comm/Future/Home/models/my_orders_information.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HistoryCardItem extends StatelessWidget {
  const HistoryCardItem({super.key, required this.order});
  final OrderInformationData order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: AppColors.orderInfoCardColor),
        child: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (builder) {
              return OrderDetailsScreen(isNotHome: false, order: order);
            }));
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.buttonCategoryColor,
              child: CircleAvatar(
                  backgroundColor: order.status == "Accept"
                      ? Colors.green
                      : order.status == "Checkout"
                          ? Colors.yellow
                          : Colors.red,
                  child: const Text("")),
            ),
            title: Text(
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                "${order.firstName} ${order.lastName}"),
            subtitle: Column(
              children: [
                OrderInfoTextCardWidget(
                  title: "phone_number".tr(context),
                  body: order.phone?.toString() ?? "",
                ),
                OrderInfoTextCardWidget(
                  title: "order_date".tr(context),
                  body: order.orderDate?.toString() ?? "",
                ),
                OrderInfoTextCardWidget(
                  title: "order_status".tr(context),
                  body: order.status?.toString() ?? "",
                ),
                OrderInfoTextCardWidget(
                  title: "order_total_price".tr(context),
                  body: order.total?.toString() ?? "",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrderInfoTextCardWidget extends StatelessWidget {
  const OrderInfoTextCardWidget(
      {super.key, required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$title:",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

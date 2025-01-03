import 'package:zein_store/Future/Home/Pages/order_details_screen.dart';
import 'package:zein_store/Future/Home/models/my_orders_information.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';
import 'package:zein_store/Utils/functions.dart';
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
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: order.status == "Accept"
                      ? Colors.green
                      : order.status == "Checkout"
                          ? const Color.fromARGB(255, 223, 206, 51)
                          : Colors.red,
                  blurRadius: 8,
                  blurStyle: BlurStyle.solid,
                  offset: const Offset(0, 4))
            ],
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            color: Colors.white),
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
                  child: Icon(
                    order.status == "Accept"
                        ? Icons.check
                        : order.status == "Checkout"
                            ? Icons.timer
                            : Icons.do_not_disturb_alt_rounded,
                    color: const Color.fromARGB(218, 0, 0, 0),
                  )),
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
                  body: order.status?.toString().tr(context) ?? "",
                ),
                OrderInfoTextCardWidget(
                  title: "order_total_price".tr(context),
                  body: formatter.format(double.parse(order.total!).toInt()),
                ),
                OrderInfoTextCardWidget(
                  title: "products_num".tr(context),
                  body: order.details!.length.toString(),
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

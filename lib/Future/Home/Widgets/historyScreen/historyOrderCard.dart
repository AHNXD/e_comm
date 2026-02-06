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
    // 1. Determine Status Colors & Icon logic
    final isAccepted = order.status == "Accept";
    final isPending = order.status == "Checkout";

    Color statusColor;
    Color statusBgColor;
    IconData statusIcon;
    String statusText;

    if (isAccepted) {
      statusColor = Colors.green.shade700;
      statusBgColor = Colors.green.shade50;
      statusIcon = Icons.check_circle_outline;
      statusText = "Accept".tr(context); // Or use tr()
    } else if (isPending) {
      statusColor = const Color(0xFFF57C00); // Dark Orange
      statusBgColor = const Color(0xFFFFF3E0);
      statusIcon = Icons.access_time_rounded;
      statusText = "Checkout".tr(context);
    } else {
      statusColor = Colors.red.shade700;
      statusBgColor = Colors.red.shade50;
      statusIcon = Icons.cancel_outlined;
      statusText = "Cancell".tr(context);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF909090).withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
                spreadRadius: 1)
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (builder) {
                return OrderDetailsScreen(isNotHome: false, order: order);
              }));
            },
            child: Padding(
              padding: EdgeInsets.all(16.sp), // Consistent padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header: Name & Status Badge ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${order.firstName} ${order.lastName}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2D2D2D),
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Date
                            Row(
                              children: [
                                Icon(Icons.calendar_today_outlined,
                                    size: 10.sp, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  order.orderDate?.toString() ?? "",
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusBgColor,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: statusColor.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(statusIcon, size: 12.sp, color: statusColor),
                            const SizedBox(width: 4),
                            Text(
                              statusText, // Use order.status.tr(context) if needed
                              style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9.sp),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: Colors.grey[200], thickness: 1),
                  ),

                  // --- Body: Info Grid ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Total Price Section
                      _InfoColumn(
                        label: "order_total_price".tr(context),
                        value:
                            "${formatter.format(double.parse(order.total!).toInt())}",
                        isPrice: true,
                        unit: order.unit ?? "USD",
                        context: context,
                      ),

                      // Items Count Section
                      _InfoColumn(
                        label: "products_num".tr(context),
                        value: "${order.details!.length}",
                        unit: order.unit ?? "USD",
                        context: context,
                      ),

                      // View Details Arrow
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.buttonCategoryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12.sp,
                          color: AppColors.buttonCategoryColor,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Helper Widget for Data Columns ---
class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool isPrice;
  final String unit;
  final BuildContext context;

  const _InfoColumn({
    required this.label,
    required this.value,
    this.isPrice = false,
    required this.context,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 8.sp,
            color: Colors.grey[500],
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: isPrice ? AppColors.primaryColors : Colors.black87,
              ),
            ),
            if (isPrice) ...[
              const SizedBox(width: 2),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  unit.tr(context),
                  style: TextStyle(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColors,
                  ),
                ),
              )
            ]
          ],
        ),
      ],
    );
  }
}

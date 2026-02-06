import 'package:zein_store/Future/Home/Pages/product_details.dart';
import 'package:zein_store/Future/Home/Widgets/order_details_screen/OrderTileWidget.dart';
import 'package:zein_store/Future/Home/models/my_orders_information.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';
import 'package:zein_store/Utils/functions.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({
    super.key,
    required this.isNotHome,
    required this.order,
  });

  final bool isNotHome;
  final OrderInformationData order;

  @override
  Widget build(BuildContext context) {
    // Determine Status Logic
    bool isAccepted = order.status == "Accept";
    bool isPending = order.status == "Checkout";

    Color statusColor =
        isAccepted ? Colors.green : (isPending ? Colors.orange : Colors.red);
    IconData statusIcon = isAccepted
        ? Icons.check_circle
        : (isPending ? Icons.access_time_filled : Icons.cancel);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "orderDetails_screen_title".tr(context),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textTitleAppBarColor,
              fontSize: 14.sp),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // --- 1. Status Banner ---
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
              color: statusColor.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(statusIcon, color: statusColor, size: 18.sp),
                  SizedBox(width: 2.w),
                  Text(
                    order.status?.toString().tr(context) ?? "Unknown",
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  // --- 2. Total Price Card ---
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                        color: AppColors.primaryColors,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.primaryColors.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5))
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "total_price".tr(context), // You can translate this
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 11.sp),
                        ),
                        Text(
                          "${formatter.format(double.parse(order.total!).toInt())} ${order.unit!.tr(context)}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // --- 3. Delivery Information ---
                  _SectionHeader(
                      title: "delivery_details".tr(context),
                      icon: Icons.local_shipping_outlined),
                  SizedBox(height: 1.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4))
                        ]),
                    child: Column(
                      children: [
                        _InfoRow(
                          label: "phone_number".tr(context),
                          value: order.phone?.toString() ?? "--",
                          icon: Icons.phone_android_rounded,
                        ),
                        Divider(height: 3.h, color: Colors.grey[100]),
                        _InfoRow(
                          label: "province".tr(context),
                          value: order.province?.toString() ?? "--",
                          icon: Icons.map_outlined,
                        ),
                        SizedBox(height: 1.5.h),
                        _InfoRow(
                          label: "region".tr(context),
                          value: order.region?.toString() ?? "--",
                          icon: Icons.location_on_outlined,
                        ),
                        Divider(height: 3.h, color: Colors.grey[100]),
                        _InfoRow(
                          label: "address".tr(context),
                          value: order.address?.toString() ?? "--",
                          icon: Icons.home_rounded,
                          isMultiLine: true,
                        ),
                        if (order.notes != null && order.notes!.isNotEmpty) ...[
                          Divider(height: 3.h, color: Colors.grey[100]),
                          _InfoRow(
                            label: "order_notes".tr(context),
                            value: order.notes!,
                            icon: Icons.note_alt_outlined,
                            isMultiLine: true,
                            valueColor: Colors.orange.shade700,
                          ),
                        ]
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // --- 4. Ordered Items ---
                  _SectionHeader(
                      title:
                          "${"ordered_items".tr(context)} (${order.details?.length ?? 0})",
                      icon: Icons.shopping_bag_outlined),
                  SizedBox(height: 1.h),

                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: order.details?.length ?? 0,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 1.5.h),
                    itemBuilder: (BuildContext context, int index) {
                      final item = order.details![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return DetailPage(
                              product: item.product!,
                            );
                          }));
                        },
                        // We wrap the existing OrderTileWidget in a nice container
                        // Or you can leave OrderTileWidget as is if it has its own style
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4))
                              ]),
                          child: OrderTileWidget(
                            size: item.size,
                            product: item.product!,
                            price: formatter
                                .format(double.parse(item.price!).toInt()),
                            qty: item.quantity,
                            unit: item.product!.unit,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Helper Widgets ---

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: Colors.grey[600]),
        SizedBox(width: 2.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isMultiLine;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.isMultiLine = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryColors.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primaryColors, size: 12.sp),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 9.sp,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: isMultiLine ? 3 : 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 11.sp,
                    color: valueColor ?? Colors.black87,
                    fontWeight: FontWeight.w600,
                    height: 1.3),
              ),
            ],
          ),
        )
      ],
    );
  }
}

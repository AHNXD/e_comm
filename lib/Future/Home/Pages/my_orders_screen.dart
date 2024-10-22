import 'package:e_comm/Future/Home/Cubits/getMyOrders/get_my_orders_cubit.dart';
import 'package:e_comm/Future/Home/Widgets/error_widget.dart';
import 'package:e_comm/Future/Home/Widgets/historyScreen/historyOrderCard.dart';
import 'package:e_comm/Future/Home/models/my_orders_information.dart';

import 'package:e_comm/Utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../Utils/colors.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<GetMyOrdersCubit>().getMyOrders();
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 10.h),
          child: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                "myOrders_screen_title".tr(context),
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColors),
              ),
            ),
          ),
        ),
        body: BlocBuilder<GetMyOrdersCubit, GetMyOrdersState>(
          builder: (context, state) {
            if (state is GetMyOrdersSuccessfulState) {
              List<OrderInformationData> myOrders =
                  state.orderInformation.data?.reversed.toList() ?? [];
              if (myOrders.isNotEmpty) {
                return ListView.builder(
                  itemCount: myOrders.length,
                  itemBuilder: (BuildContext context, int index) {
                    return HistoryCardItem(order: myOrders[index]);
                  },
                );
              } else {
                return Center(
                  child: Text(
                    "no_orders".tr(context),
                  ),
                );
              }
            } else if (state is GetMyOrdersErrorState) {
              return MyErrorWidget(
                  msg: state.msg,
                  onPressed: () {
                    context.read<GetMyOrdersCubit>().getMyOrders();
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}

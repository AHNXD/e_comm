import 'package:e_comm/Future/Home/Blocs/get_my_orders/get_my_orders_bloc.dart';

import 'package:e_comm/Future/Home/Widgets/error_widget.dart';
import 'package:e_comm/Future/Home/Widgets/historyScreen/historyOrderCard.dart';
import 'package:e_comm/Future/Home/Widgets/home_screen/appbar_widget.dart';

import 'package:e_comm/Utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../Widgets/custom_circular_progress_indicator.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final _scrollControllerMyOrders = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<GetMyOrdersBloc>().add(RestPagination());
    context.read<GetMyOrdersBloc>().add(GetAllMyOrdersEvent());
    _scrollControllerMyOrders.addListener(_onScrollCategories);
  }

  @override
  void dispose() {
    _scrollControllerMyOrders
      ..removeListener(_onScrollCategories)
      ..dispose();

    super.dispose();
  }

  void _onScrollCategories() {
    final currentScroll = _scrollControllerMyOrders.offset;
    final maxScroll = _scrollControllerMyOrders.position.maxScrollExtent;

    if (currentScroll >= (maxScroll * 0.9)) {
      context.read<GetMyOrdersBloc>().add(GetAllMyOrdersEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<GetMyOrdersBloc>().add(GetAllMyOrdersEvent());
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 8.h),
          child: AppBarWidget(
            isHome: false,
            title: "myOrders_screen_title".tr(context),
          ),
          // child: AppBar(
          //   scrolledUnderElevation: 0,
          //   backgroundColor: Colors.white,
          //   centerTitle: true,
          //   title: Padding(
          //     padding: const EdgeInsets.only(top: 15.0),
          //     child: Text(
          //       "myOrders_screen_title".tr(context),
          //       style: const TextStyle(
          //           fontWeight: FontWeight.bold,
          //           color: AppColors.primaryColors),
          //     ),
          //   ),
          // ),
        ),
        body: BlocBuilder<GetMyOrdersBloc, GetMyOrdersState>(
          builder: (context, state) {
            switch (state.status) {
              case GetMyOrdersStatus.loading:
                return const Center(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CustomCircularProgressIndicator()),
                );
              case GetMyOrdersStatus.success:
                if (state.my_orders.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "my_orders_empty_msg".tr(context),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollControllerMyOrders,
                  itemCount: state.hasReachedMax
                      ? state.my_orders.length
                      : state.my_orders.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    return index >= state.my_orders.length
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CustomCircularProgressIndicator()),
                            ),
                          )
                        : HistoryCardItem(order: state.my_orders[index]);
                  },
                );
              case GetMyOrdersStatus.error:
                return Center(
                    child: MyErrorWidget(
                  msg: state.errorMsg,
                  onPressed: () {
                    context.read<GetMyOrdersBloc>().add(GetAllMyOrdersEvent());
                  },
                ));
            }
          },
        ));
  }
}

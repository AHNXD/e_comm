import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:e_comm/Apis/ExceptionsHandle.dart';
import 'package:e_comm/Apis/Network.dart';
import 'package:e_comm/Apis/Urls.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_comm/Future/Home/models/my_orders_information.dart';
import 'package:equatable/equatable.dart';

part 'get_my_orders_event.dart';
part 'get_my_orders_state.dart';

class GetMyOrdersBloc extends Bloc<GetMyOrdersEvent, GetMyOrdersState> {
  GetMyOrdersBloc() : super(const GetMyOrdersState()) {
    on<GetMyOrdersEvent>((event, emit) async {
      if (event is GetAllMyOrdersEvent) {
        if (state.hasReachedMax) return;
        try {
          if (state.status == GetMyOrdersStatus.loading) {
            final response = await Network.getData(
                url: "${Urls.getMyOrders}?per_page=5&page=1");
            if (response.statusCode == 200 || response.statusCode == 201) {
              OrdersInformation my_orders =
                  OrdersInformation.fromJson(response.data);

              return my_orders.data!.isEmpty
                  ? emit(state.copyWith(
                      status: GetMyOrdersStatus.success, hasReachedMax: true))
                  : emit(state.copyWith(
                      status: GetMyOrdersStatus.success,
                      my_orders: my_orders.data,
                      hasReachedMax: false,
                      currentPage: my_orders.pagination!.currentPage,
                      totalPages: my_orders.pagination!.total));
            }
          } else {
            final response = await Network.getData(
                url:
                    "${Urls.getMyOrders}?per_page=5&page=${state.currentPage + 1}");
            if (response.statusCode == 200 || response.statusCode == 201) {
              OrdersInformation my_orders =
                  OrdersInformation.fromJson(response.data);
              my_orders.data!.isEmpty
                  ? emit(state.copyWith(hasReachedMax: true))
                  : emit(state.copyWith(
                      status: GetMyOrdersStatus.success,
                      my_orders: List.of(state.my_orders)
                        ..addAll(my_orders.data!),
                      hasReachedMax: false,
                      currentPage: my_orders.pagination!.currentPage,
                      totalPages: my_orders.pagination!.total));
            }
          }
        } catch (error) {
          if (error is DioException) {
            emit(state.copyWith(
                status: GetMyOrdersStatus.error,
                errorMsg: exceptionsHandle(error: error)));
          } else {
            emit(state.copyWith(
                status: GetMyOrdersStatus.error, errorMsg: error.toString()));
          }
        }
      }
    }, transformer: droppable());
  }
}

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:zein_store/Apis/ExceptionsHandle.dart';
import 'package:zein_store/Apis/Network.dart';
import 'package:zein_store/Apis/Urls.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zein_store/Future/Home/models/my_orders_information.dart';
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
              OrdersInformation myOrders =
                  OrdersInformation.fromJson(response.data);

              return myOrders.data!.isEmpty
                  ? emit(state.copyWith(
                      status: GetMyOrdersStatus.success, hasReachedMax: true))
                  : emit(state.copyWith(
                      status: GetMyOrdersStatus.success,
                      my_orders: myOrders.data,
                      hasReachedMax: myOrders.pagination!.currentPage ==
                          myOrders.pagination!.lastPage,
                      currentPage: myOrders.pagination!.currentPage,
                      totalPages: myOrders.pagination!.total));
            }
          } else {
            final response = await Network.getData(
                url:
                    "${Urls.getMyOrders}?per_page=5&page=${state.currentPage + 1}");
            if (response.statusCode == 200 || response.statusCode == 201) {
              OrdersInformation myOrders =
                  OrdersInformation.fromJson(response.data);
              myOrders.data!.isEmpty
                  ? emit(state.copyWith(hasReachedMax: true))
                  : emit(state.copyWith(
                      status: GetMyOrdersStatus.success,
                      my_orders: List.of(state.my_orders)
                        ..addAll(myOrders.data!),
                      hasReachedMax: myOrders.pagination!.currentPage ==
                          myOrders.pagination!.lastPage,
                      currentPage: myOrders.pagination!.currentPage,
                      totalPages: myOrders.pagination!.total));
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

    on<RestPagination>(
      (event, emit) {
        emit(state.copyWith(
          my_orders: [],
          hasReachedMax: false,
          status: GetMyOrdersStatus.loading,
          currentPage: 1,
          totalPages: 1,
          errorMsg: "",
        ));
      },
    );
  }
}

import 'package:dio/dio.dart';
import 'package:e_comm/Apis/ExceptionsHandle.dart';
import 'package:e_comm/Apis/Network.dart';
import 'package:e_comm/Apis/Urls.dart';

import 'package:e_comm/Future/Home/models/my_orders_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_my_orders_state.dart';

class GetMyOrdersCubit extends Cubit<GetMyOrdersState> {
  GetMyOrdersCubit() : super(GetMyOrdersInitial());

  void getMyOrders() async {
    emit(GetMyOrdersLoadingState());
    try {
      await Network.getData(url: Urls.getMyOrders).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          OrdersInformation? orderInformation =
              OrdersInformation.fromJson(response.data);

          emit(GetMyOrdersSuccessfulState(orderInformation: orderInformation));
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          GetMyOrdersErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        emit(
          GetMyOrdersErrorState(error.toString()),
        );
      }
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../../Apis/ExceptionsHandle.dart';
import '../../../../Apis/Network.dart';
import '../../../../Apis/Urls.dart';
import '../../../../Utils/constants.dart';
import '../../models/order_product_model.dart';

part 'order_product_state.dart';

class OrderProductCubit extends Cubit<OrderProductState> {
  OrderProductCubit() : super(OrderPoductInitial());

  void sendOrder(OrderProductModel order) async {
    try {
      final formData = await order.toFormData();
      final response = await Network.postDataWithFiles(
        url: Urls.orderProduct, // Make sure to define this URL constant
        data: formData,
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['status']) {
        emit(OrderProductSuccess(msg: response.data['msg']));
      } else {
        emit(OrderProductError(
            error: lang == 'en'
                ? 'Failed to submit order. Please try again.'
                : 'فشل في إرسال الطلب الرجاء المحاولة لاحقا'));
      }
    } catch (error) {
      if (error is DioException) {
        emit(OrderProductError(error: exceptionsHandle(error: error)));
      } else {
        print(error);
        emit(OrderProductError(error: error.toString()));
      }
    }
  }
}

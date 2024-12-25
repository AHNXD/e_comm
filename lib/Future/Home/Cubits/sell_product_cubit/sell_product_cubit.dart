import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:zein_store/Future/Home/models/sell_product_model.dart';
import 'package:zein_store/Utils/constants.dart';
import 'package:meta/meta.dart';

import '../../../../Apis/ExceptionsHandle.dart';
import '../../../../Apis/Network.dart';
import '../../../../Apis/Urls.dart';

part 'sell_product_state.dart';

class SellProductCubit extends Cubit<SellProductState> {
  SellProductCubit() : super(SellProductInitial());

  void sendProduct(SellProductModel product) async {
    emit(SellProductLoading());
    try {
      final formData = await product.toFormData();
      final response = await Network.postDataWithFiles(
          url: Urls.sellProduct, data: formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(SellProductSuccess(msg: response.data['msg']));
      } else {
        emit(SellProductError(
            error: lang == 'en'
                ? 'Failed to upload product. Please try again.'
                : 'فشل في رفع المنتج الرجاء المحاولة لاحقا'));
      }
    } catch (error) {
      if (error is DioException) {
        emit(SellProductError(error: exceptionsHandle(error: error)));
      } else {
        print(error);
        emit(SellProductError(error: error.toString()));
      }
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:zein_store/Future/Home/models/catigories_model.dart';
import 'package:zein_store/Future/Home/models/product_model.dart';
import 'package:meta/meta.dart';

import '../../../../Apis/ExceptionsHandle.dart';
import '../../../../Apis/Network.dart';
import '../../../../Apis/Urls.dart';

part 'get_porduct_by_id_state.dart';

class GetPorductByIdCubit extends Cubit<GetPorductByIdState> {
  GetPorductByIdCubit() : super(GetPorductByIdInitial());

  void getProductsByCategory(int id) async {
    emit(GetPorductByIdLoading());
    try {
      await Network.getData(
              url: "${Urls.getProductsByGategoryId}/$id?per_page=100&page=1")
          .then((response) {
        ProductsModel products = ProductsModel.fromJson(response.data);
        emit(GetPorductByIdSuccess(products: products.data!));
      });
    } catch (error) {
      if (error is DioException) {
        emit(GetPorductByIdError(msg: exceptionsHandle(error: error)));
      } else {
        emit(GetPorductByIdError(msg: error.toString()));
      }
    }
  }

  void getAllProductsByAllCategory(List<CatigoriesData> catigories) async {
    emit(GetPorductByIdLoading());

    try {
      List<List<MainProduct>> allProducts = [];
      for (int i = 0; i < catigories.length; i++) {
        await Network.getData(
                url: "${Urls.getProductsByGategoryId}/${catigories[i].id}")
            .then((response) {
          ProductsModel products = ProductsModel.fromJson(response.data);
          allProducts.add(products.data!);
        });
      }
      emit(GetAllPorductByIdSuccess(allProducts: allProducts));
    } catch (error) {
      if (error is DioException) {
        emit(GetPorductByIdError(msg: exceptionsHandle(error: error)));
      } else {
        emit(GetPorductByIdError(msg: error.toString()));
      }
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../../Apis/ExceptionsHandle.dart';
import '../../../../Apis/Network.dart';
import '../../../../Apis/Urls.dart';
import '../../models/catigories_model.dart';
import '../../models/product_model.dart';

part 'all_products_by_all_category_state.dart';

class AllProductsByAllCategoryCubit
    extends Cubit<AllProductsByAllCategoryState> {
  AllProductsByAllCategoryCubit() : super(AllProductsByAllCategoryInitial());
  void getAllProductsByAllCategory(List<CatigoriesData> catigories) async {
    emit(AllProductsByAllCategoryLoading());

    try {
      List<List<MainProduct>> allProducts = [];
      for (int i = 0; i < catigories.length; i++) {
        await Network.getData(
                url:
                    "${Urls.getProductsByGategoryId}/${catigories[i].id}?per_page=5&page=1")
            .then((response) {
          ProductsModel products = ProductsModel.fromJson(response.data);
          allProducts.add(products.data!);
        });
      }
      emit(AllProductsByAllCategorySuccess(allProducts: allProducts));
    } catch (error) {
      if (error is DioException) {
        emit(
            AllProductsByAllCategoryError(msg: exceptionsHandle(error: error)));
      } else {
        emit(AllProductsByAllCategoryError(msg: error.toString()));
      }
    }
  }
}

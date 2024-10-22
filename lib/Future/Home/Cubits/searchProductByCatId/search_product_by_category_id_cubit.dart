import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../../Apis/ExceptionsHandle.dart';
import '../../../../Apis/Network.dart';
import '../../../../Apis/Urls.dart';
import '../../models/product_model.dart';

part 'search_product_by_category_id_state.dart';

class SearchProductByCategoryIdCubit
    extends Cubit<SearchProductByCategoryIdState> {
  SearchProductByCategoryIdCubit() : super(SearchProductByCategoryIdInitial());

  Future<void> searchProductsByCategories(
      String productName, int categoryId) async {
    print(categoryId);
    emit(SearchProductByCategoryIdLoading());
    try {
      await Network.postData(url: Urls.filterProducts, data: {
        "search": productName,
        "category_id": categoryId,
      }).then((value) {
        if (value.statusCode == 200 || value.statusCode == 201) {
          if (value.data['data'] != null &&
              (value.data['data'] as List).isNotEmpty) {
            ProductsModel resault = ProductsModel.fromJson(value.data);
            emit(SearchProductByCategoryIdSuccess(products: resault.data!));
          } else {
            emit(SearchProductByCategoryIdNotFound());
          }
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          SearchProductByCategoryIdError(
            message: exceptionsHandle(error: error),
          ),
        );
      } else {
        emit(SearchProductByCategoryIdError(message: error.toString()));
      }
    }
  }
}

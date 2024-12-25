import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:e_comm/Apis/Network.dart';
import 'package:e_comm/Apis/Urls.dart';
import 'package:meta/meta.dart';

import '../../../../Apis/ExceptionsHandle.dart';
import '../../models/product_model.dart';

part 'search_products_state.dart';

class SearchProductsCubit extends Cubit<SearchProductsState> {
  SearchProductsCubit() : super(SearchProductsInitial());
  late ProductsModel resault;
  Future<void> searchProducts(String productName) async {
    emit(SearchProductsLoadingState());
    try {
      await Network.postData(url: Urls.filterProducts, data: {
        "search": productName,
      }).then((value) {
        if (value.statusCode == 200 || value.statusCode == 201) {
          resault = ProductsModel.fromJson(value.data);

          if (value.data['data'] != null &&
              (value.data['data'] as List).isNotEmpty) {
            resault = ProductsModel.fromJson(value.data);
            emit(SearchProductsSuccessfulState(products: resault.data!));
          } else {
            emit(SearchProductsNotFoundfulState());
          }
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          SearchProductsErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        SearchProductsErrorState(error.toString());
      }
    }
  }

  void reset() {
    emit(SearchProductsInitial());
  }
}

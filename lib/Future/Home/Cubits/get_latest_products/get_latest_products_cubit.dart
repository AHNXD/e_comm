import 'package:dio/dio.dart';
import 'package:e_comm/Apis/ExceptionsHandle.dart';
import 'package:e_comm/Apis/Network.dart';
import 'package:e_comm/Apis/Urls.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_comm/Future/Home/models/latest_products.dart';
import 'package:meta/meta.dart';

part 'get_latest_products_state.dart';

class GetLatestProductsCubit extends Cubit<GetLatestProductsState> {
  GetLatestProductsCubit() : super(GetLatestProductsInitial());

  LatestProductsModel? LatestProduct;

  void getLatestProducts() async {
    emit(GetLatestProductsLoadingState());
    try {
      await Network.getData(
              url: "${Urls.getLastestProducts}?per_page=100&page=1")
          .then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          LatestProduct = LatestProductsModel.fromJson(response.data);

          emit(GetLatestProductsSuccessfulState(
              latestProducts: LatestProduct!.data ?? []));
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          GetLatestProductsErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        GetLatestProductsErrorState(error.toString());
      }
    }
  }
}

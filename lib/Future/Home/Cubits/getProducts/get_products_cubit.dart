import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:zein_store/Apis/ExceptionsHandle.dart';
import 'package:zein_store/Apis/Network.dart';
import 'package:zein_store/Apis/Urls.dart';
import 'package:zein_store/Future/Home/models/offers_products_model.dart';
import 'package:zein_store/Future/Home/models/product_model.dart';

part 'get_products_state.dart';

class GetProductsCubit extends Cubit<GetProductsState> {
  GetProductsCubit() : super(GetProductsInitial());

  ProductsModel? model;
  MainProduct? product;
  OffersProductsModel? offersProductsModel;
  void getProducts() async {
    emit(GetProductsLoadingState());
    try {
      await Network.getData(url: Urls.getProducts).then((response) {
        model = ProductsModel.fromJson(response.data);

        emit(GetProductsSuccessfulState());
      });
    } catch (error) {
      if (error is DioException) {
        emit(GetProductsErrorState(exceptionsHandle(error: error)));
      } else {
        GetProductsErrorState(error.toString());
      }
    }
  }

  void getProductsById(int id) async {
    emit(GetProductsLoadingState());
    try {
      await Network.getData(url: "${Urls.getProducts}/$id").then((response) {
        product = MainProduct.fromJson(response.data);

        emit(GetProductsSuccessfulState());
      });
    } catch (error) {
      if (error is DioException) {
        emit(GetProductsErrorState(exceptionsHandle(error: error)));
      } else {
        GetProductsErrorState(error.toString());
      }
    }
  }

  void getLastestProducts() async {
    emit(GetProductsLoadingState());
    try {
      await Network.getData(url: Urls.getLastestProducts).then((response) {
        model = ProductsModel.fromJson(response.data);
        emit(GetProductsSuccessfulState());
      });
    } catch (error) {
      if (error is DioException) {
        emit(GetProductsErrorState(exceptionsHandle(error: error)));
      } else {
        GetProductsErrorState(error.toString());
      }
    }
  }

  void getOffersProducts() async {
    emit(GetProductsLoadingState());
    try {
      await Network.getData(url: Urls.getOffersCatigories).then((response) {
        offersProductsModel = OffersProductsModel.fromJson(response.data);
        emit(GetProductsSuccessfulState());
      });
    } catch (error) {
      if (error is DioException) {
        emit(GetProductsErrorState(exceptionsHandle(error: error)));
      } else {
        GetProductsErrorState(error.toString());
      }
    }
  }
}

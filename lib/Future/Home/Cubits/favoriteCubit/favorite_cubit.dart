import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:e_comm/Future/Home/models/favorite_model.dart';
import 'package:e_comm/Future/Home/models/product_model.dart';
import 'package:flutter/material.dart';
import '../../../../Apis/ExceptionsHandle.dart';
import '../../../../Apis/Network.dart';
import '../../../../Apis/Urls.dart';
part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitial());

  void getProductsFavorite() async {
    FavoriteModel? fvModel;
    emit(GetFavoriteProductsLoadingState());
    try {
      await Network.getData(url: Urls.getProductsFavorite)
          .then((response) async {
        if (response.statusCode == 200 || response.statusCode == 201) {
          fvModel = FavoriteModel.fromJson(response.data);
          List<MainProduct> favProducts = [];
          for (int i = 0; i < fvModel!.data!.length; i++) {
            await Network.getData(
                    url: "${Urls.getProduct}/${fvModel!.data![i].productId}")
                .then((response) {
              MainProduct product = MainProduct.fromJson(response.data["data"]);
              product.isFavorite = true;
              favProducts.add(product);
            });
          }
          emit(GetFavoriteProductsSuccessfulState(fvModel: favProducts));
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          FavoriteProductsErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        FavoriteProductsErrorState(error.toString());
      }
    }
  }

  Future<bool> addAndDelFavoriteProducts(int id) async {
    bool isFave = false;
    try {
      await Network.postData(
          url: Urls.addAndDelProductsFavorite, data: {"id": id}).then((value) {
        if (value.statusCode == 200 || value.statusCode == 201) {
          isFave = value.data['fav'] as bool;
          emit(FavoriteProductSuccessfulState(isFave: isFave));
        }
      });
    } catch (error) {
      isFave = false;
      if (error is DioException) {
        emit(
          FavoriteProductsErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        emit(FavoriteProductsErrorState(error.toString()));
      }
    }
    return isFave;
  }
}

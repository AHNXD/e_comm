import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:zein_store/Future/Home/models/product_model.dart';
import 'package:flutter/material.dart';
import '../../../../Apis/ExceptionsHandle.dart';
import '../../../../Apis/Network.dart';
import '../../../../Apis/Urls.dart';
part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitial());

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

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:e_comm/Apis/ExceptionsHandle.dart';
import 'package:e_comm/Apis/Network.dart';
import 'package:e_comm/Apis/Urls.dart';
import 'package:e_comm/Future/Home/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_comm/Future/Home/models/favorite_model.dart';
import 'package:equatable/equatable.dart';

part 'get_favorite_event.dart';
part 'get_favorite_state.dart';

class GetFavoriteBloc extends Bloc<GetFavoriteEvent, GetFavoriteState> {
  GetFavoriteBloc() : super(const GetFavoriteState()) {
    on<GetFavoriteEvent>((event, emit) async {
      if (event is GetAllFavoriteEvent) {
        if (state.hasReachedMax) return;
        try {
          if (state.status == GetFavoriteStatus.loading) {
            final response = await Network.getData(
                url: "${Urls.getProductsFavorite}?per_page=8&page=1");
            if (response.statusCode == 200 || response.statusCode == 201) {
              FavoriteModel favoritesProducts =
                  FavoriteModel.fromJson(response.data);
              for (int i = 0; i < favoritesProducts.data!.length; i++) {
                favoritesProducts.data![i].isFavorite = true;
              }

              return favoritesProducts.data!.isEmpty
                  ? emit(state.copyWith(
                      status: GetFavoriteStatus.success, hasReachedMax: true))
                  : emit(state.copyWith(
                      status: GetFavoriteStatus.success,
                      favoriteProducts: favoritesProducts.data,
                      hasReachedMax:
                          favoritesProducts.pagination!.currentPage ==
                              favoritesProducts.pagination!.lastPage,
                      currentPage: favoritesProducts.pagination!.currentPage,
                      totalPages: favoritesProducts.pagination!.total));
            }
          } else {
            final response = await Network.getData(
                url:
                    "${Urls.getProductsFavorite}?per_page=8&page=${state.currentPage + 1}");
            if (response.statusCode == 200 || response.statusCode == 201) {
              FavoriteModel favoritesProducts =
                  FavoriteModel.fromJson(response.data);
              for (int i = 0; i < favoritesProducts.data!.length; i++) {
                favoritesProducts.data![i].isFavorite = true;
              }
              favoritesProducts.data!.isEmpty
                  ? emit(state.copyWith(hasReachedMax: true))
                  : emit(state.copyWith(
                      status: GetFavoriteStatus.success,
                      favoriteProducts: List.of(state.favoriteProducts)
                        ..addAll(favoritesProducts.data!),
                      hasReachedMax:
                          favoritesProducts.pagination!.currentPage ==
                              favoritesProducts.pagination!.lastPage,
                      currentPage: favoritesProducts.pagination!.currentPage,
                      totalPages: favoritesProducts.pagination!.total));
            }
          }
        } catch (error) {
          if (error is DioException) {
            emit(state.copyWith(
                status: GetFavoriteStatus.error,
                errorMsg: exceptionsHandle(error: error)));
          } else {
            emit(state.copyWith(
                status: GetFavoriteStatus.error, errorMsg: error.toString()));
          }
        }
      }
    }, transformer: droppable());
    on<RestPagination>(
      (event, emit) {
        emit(state.copyWith(
          favoriteProducts: [],
          hasReachedMax: false,
          status: GetFavoriteStatus.loading,
          currentPage: 1,
          totalPages: 1,
          errorMsg: "",
        ));
      },
    );
  }
}

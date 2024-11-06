import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:e_comm/Apis/ExceptionsHandle.dart';
import 'package:e_comm/Apis/Network.dart';
import 'package:e_comm/Apis/Urls.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_comm/Future/Home/models/favorite_model.dart';
import 'package:equatable/equatable.dart';

part 'gerfavorite_event.dart';
part 'gerfavorite_state.dart';

class GerfavoriteBloc extends Bloc<GerfavoriteEvent, GerfavoriteState> {
  GerfavoriteBloc() : super(const GerfavoriteState()) {
    on<GerfavoriteEvent>((event, emit) async {
      if (event is GetAllFavoriteEvent) {
        if (state.hasReachedMax) return;
        try {
          if (state.status == GetfavoriteStatus.loading) {
            final response = await Network.getData(
                url: "${Urls.getProductsFavorite}?per_page=5&page=1");
            if (response.statusCode == 200 || response.statusCode == 201) {
              FavoriteModel favoritesProducts =
                  FavoriteModel.fromJson(response.data);

              return favoritesProducts.data!.isEmpty
                  ? emit(state.copyWith(
                      status: GetfavoriteStatus.success, hasReachedMax: true))
                  : emit(state.copyWith(
                      status: GetfavoriteStatus.success,
                      favoriteProducts: favoritesProducts.data,
                      hasReachedMax: false,
                      currentPage: favoritesProducts.pagination!.currentPage,
                      totalPages: favoritesProducts.pagination!.total));
            }
          } else {
            final response = await Network.getData(
                url:
                    "${Urls.getProductsFavorite}?per_page=5&page=${state.currentPage + 1}");
            if (response.statusCode == 200 || response.statusCode == 201) {
              FavoriteModel favoritesProducts =
                  FavoriteModel.fromJson(response.data);
              favoritesProducts.data!.isEmpty
                  ? emit(state.copyWith(hasReachedMax: true))
                  : emit(state.copyWith(
                      status: GetfavoriteStatus.success,
                      favoriteProducts: List.of(state.favoriteProducts)
                        ..addAll(favoritesProducts.data!),
                      hasReachedMax: false,
                      currentPage: favoritesProducts.pagination!.currentPage,
                      totalPages: favoritesProducts.pagination!.total));
            }
          }
        } catch (error) {
          if (error is DioException) {
            emit(state.copyWith(
                status: GetfavoriteStatus.error,
                errorMsg: exceptionsHandle(error: error)));
          } else {
            emit(state.copyWith(
                status: GetfavoriteStatus.error, errorMsg: error.toString()));
          }
        }
      }
    }, transformer: droppable());
  }
}

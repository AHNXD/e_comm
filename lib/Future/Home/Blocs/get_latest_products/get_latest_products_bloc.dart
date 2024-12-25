import 'package:dio/dio.dart';
import 'package:e_comm/Apis/ExceptionsHandle.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_comm/Apis/Network.dart';
import 'package:e_comm/Apis/Urls.dart';
import 'package:e_comm/Future/Home/models/latest_products.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
part 'get_latest_products_event.dart';
part 'get_latest_products_state.dart';

class GetLatestProductsBloc
    extends Bloc<GetLatestProductsEvent, GetLatestProductsState> {
  GetLatestProductsBloc() : super(const GetLatestProductsState()) {
    on<ResetPaginationAllLatestProductsEvent>(
      (event, emit) => emit(state.copyWith(
          latestProducts: [],
          hasReachedMax: false,
          status: LatestProductsStatus.loading,
          currentPage: 1,
          totalPages: 1,
          errorMsg: "")),
    );

    on<GetLatestProductsEvent>((event, emit) async {
      if (event is GetAllLatestProductsEvent) {
        if (state.hasReachedMax) return;
        try {
          if (state.status == LatestProductsStatus.loading) {
            final response = await Network.getData(
                url: "${Urls.getLastestProducts}?per_page=5&page=1");
            if (response.statusCode == 200 || response.statusCode == 201) {
              LatestProductsModel latestProducts =
                  LatestProductsModel.fromJson(response.data);

              return latestProducts.data!.isEmpty
                  ? emit(state.copyWith(
                      status: LatestProductsStatus.success,
                      hasReachedMax: true))
                  : emit(state.copyWith(
                      status: LatestProductsStatus.success,
                      latestProducts: latestProducts.data,
                      hasReachedMax: false,
                      currentPage: latestProducts.pagination!.currentPage,
                      totalPages: latestProducts.pagination!.total));
            }
          } else {
            final response = await Network.getData(
                url:
                    "${Urls.getLastestProducts}?per_page=5&page=${state.currentPage + 1}");
            if (response.statusCode == 200 || response.statusCode == 201) {
              LatestProductsModel latestProducts =
                  LatestProductsModel.fromJson(response.data);
              latestProducts.data!.isEmpty
                  ? emit(state.copyWith(hasReachedMax: true))
                  : emit(state.copyWith(
                      status: LatestProductsStatus.success,
                      latestProducts: List.of(state.latestProducts)
                        ..addAll(latestProducts.data!),
                      hasReachedMax: false,
                      currentPage: latestProducts.pagination!.currentPage,
                      totalPages: latestProducts.pagination!.total));
            }
          }
        } catch (error) {
          if (error is DioException) {
            emit(state.copyWith(
                status: LatestProductsStatus.error,
                errorMsg: exceptionsHandle(error: error)));
          } else {
            emit(state.copyWith(
                status: LatestProductsStatus.error,
                errorMsg: error.toString()));
          }
        }
      }
    }, transformer: droppable());
  }
}

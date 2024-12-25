import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:zein_store/Apis/ExceptionsHandle.dart';
import 'package:zein_store/Future/Home/models/product_model.dart';
import 'package:equatable/equatable.dart';

import '../../../../Apis/Network.dart';
import '../../../../Apis/Urls.dart';

part 'get_products_by_cat_id_event.dart';
part 'get_products_by_cat_id_state.dart';

class GetProductsByCatIdBloc
    extends Bloc<GetProductsByCatIdEvent, GetProductsByCatIdState> {
  GetProductsByCatIdBloc() : super(const GetProductsByCatIdState()) {
    on<ResetPagination>(
      (event, emit) {
        emit(state.copyWith(
          currentPage: 1,
          errorMsg: "",
          hasReachedMax: false,
          products: [],
          status: GetProductsByCatIdStatus.loading,
          totalPages: 1,
        ));
      },
    );
    on<GetProductsByCatIdEvent>((event, emit) async {
      if (event is GetAllPoductsByCatIdEvent) {
        if (state.hasReachedMax) return;
        try {
          if (state.status == GetProductsByCatIdStatus.loading) {
            final response = await Network.getData(
                url:
                    "${Urls.getProductsByGategoryId}/${event.categoryID}?per_page=6&page=1");
            if (response.statusCode == 200 || response.statusCode == 201) {
              ProductsModel products = ProductsModel.fromJson(response.data);

              return products.data!.isEmpty
                  ? emit(state.copyWith(
                      status: GetProductsByCatIdStatus.success,
                      hasReachedMax: true))
                  : emit(state.copyWith(
                      status: GetProductsByCatIdStatus.success,
                      products: products.data,
                      hasReachedMax: false,
                      currentPage: products.pagination!.currentPage,
                      totalPages: products.pagination!.lastPage,
                    ));
            }
          } else {
            final response = await Network.getData(
                url:
                    "${Urls.getProductsByGategoryId}/${event.categoryID}?per_page=6&page=${state.currentPage + 1}");
            if (response.statusCode == 200 || response.statusCode == 201) {
              ProductsModel products = ProductsModel.fromJson(response.data);
              products.data!.isEmpty
                  ? emit(state.copyWith(
                      status: GetProductsByCatIdStatus.success,
                      hasReachedMax: true))
                  : emit(state.copyWith(
                      status: GetProductsByCatIdStatus.success,
                      products: List.of(state.products)..addAll(products.data!),
                      hasReachedMax: false,
                      currentPage: products.pagination!.currentPage,
                      totalPages: products.pagination!.total));
            }
          }
        } catch (error) {
          if (error is DioException) {
            emit(state.copyWith(
                status: GetProductsByCatIdStatus.error,
                errorMsg: exceptionsHandle(error: error)));
          } else {
            emit(state.copyWith(
                status: GetProductsByCatIdStatus.error,
                errorMsg: error.toString()));
          }
        }
      }
    }, transformer: droppable());
  }
}

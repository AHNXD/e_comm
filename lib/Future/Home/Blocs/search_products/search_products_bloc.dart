import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../../Apis/ExceptionsHandle.dart';
import '../../../../Apis/Network.dart';
import '../../../../Apis/Urls.dart';
import '../../models/product_model.dart';

part 'search_products_event.dart';
part 'search_products_state.dart';

class SearchProductsBloc
    extends Bloc<SearchProductsEvent, SearchProductsState> {
  SearchProductsBloc() : super(const SearchProductsState()) {
    on<SearchForProducsEvent>((event, emit) async {
      if (state.hasReachedMax) return;
      final data = {"search": event.search};
      try {
        if (state.status == SearchProductsStatus.loading) {
          await Network.postData(
                  url: "${Urls.filterProducts}?per_page=6&page=1", data: data)
              .then((value) {
            if (value.statusCode == 200 || value.statusCode == 201) {
              ProductsModel resault = ProductsModel.fromJson(value.data);
              return resault.data!.isEmpty
                  ? emit(state.copyWith(
                      status: SearchProductsStatus.success,
                      hasReachedMax: true,
                    ))
                  : emit(state.copyWith(
                      products: resault.data,
                      status: SearchProductsStatus.success,
                      hasReachedMax: resault.data!.length <= 1,
                      totalPages: resault.pagination?.lastPage ?? 1,
                      currentPage: resault.pagination?.currentPage ?? 1,
                    ));
            }
          });
        } else {
          await Network.postData(
                  url:
                      "${Urls.filterProducts}?per_page=6&page=${state.currentPage + 1}",
                  data: data)
              .then((value) {
            if (value.statusCode == 200 || value.statusCode == 201) {
              ProductsModel resault = ProductsModel.fromJson(value.data);
              return resault.data!.isEmpty
                  ? emit(state.copyWith(
                      status: SearchProductsStatus.success,
                      hasReachedMax: true,
                    ))
                  : emit(state.copyWith(
                      products: List.of(state.products)..addAll(resault.data!),
                      status: SearchProductsStatus.success,
                      hasReachedMax: false,
                      totalPages: resault.pagination!.lastPage,
                      currentPage: resault.pagination!.currentPage,
                    ));
            }
          });
        }
      } catch (error) {
        if (error is DioException) {
          emit(state.copyWith(
              status: SearchProductsStatus.error,
              errorMsg: exceptionsHandle(error: error)));
        } else {
          emit(state.copyWith(
              status: SearchProductsStatus.error, errorMsg: error.toString()));
        }
      }
    }, transformer: droppable());

    on<ResetSearchingToInit>(
      (event, emit) {
        emit(state.copyWith(
          status: SearchProductsStatus.init,
          hasReachedMax: false,
          products: [],
          currentPage: 1,
        ));
      },
    );

    on<ResetSearchText>(
      (event, emit) {
        emit(state.copyWith(
          status: SearchProductsStatus.loading,
          hasReachedMax: false,
          products: [],
          currentPage: 1,
        ));
      },
    );
  }
}

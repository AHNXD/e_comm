import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../../Apis/ExceptionsHandle.dart';
import '../../../../Apis/Network.dart';
import '../../../../Apis/Urls.dart';
import '../../models/product_model.dart';

part 'search_filter_poducts_event.dart';
part 'search_filter_poducts_state.dart';

class SearchFilterPoductsBloc
    extends Bloc<SearchFilterPoductsEvent, SearchFilterPoductsState> {
  SearchFilterPoductsBloc() : super(const SearchFilterPoductsState()) {
    on<ResetSearchFilter>(
      (event, emit) {
        emit(state.copyWith(
            status: SearchFilterProductsStatus.loading,
            hasReachedMax: false,
            products: [],
            totalPages: 1,
            currentPage: 1,
            errorMsg: ""));
      },
    );
    on<ResetSearchFilterToInit>(
      (event, emit) {
        emit(state.copyWith(
            status: SearchFilterProductsStatus.init,
            hasReachedMax: false,
            products: [],
            totalPages: 1,
            currentPage: 1,
            errorMsg: ""));
      },
    );
    on<SearchFilterPoductsEvent>((event, emit) async {
      if (state.hasReachedMax) return;
      Map data = {};
      if (event is SearchProductsByCatId) {
        data = {"search": event.searchText, "category_id": event.categoryId};
        await searchFilterProducts(data, emit);
      } else if (event is FilterProductsByCatId) {
        data = {
          "min": event.min,
          "max": event.max,
          "category_id": event.categoryId
        };
        await searchFilterProducts(data, emit);
      }
    }, transformer: droppable());
  }

  Future<void> searchFilterProducts(Map<dynamic, dynamic> data,
      Emitter<SearchFilterPoductsState> emit) async {
    try {
      if (state.status == SearchFilterProductsStatus.loading) {
        await Network.postData(
                url: "${Urls.filterProducts}?per_page=6&page=1", data: data)
            .then((value) {
          if (value.statusCode == 200 || value.statusCode == 201) {
            ProductsModel resault = ProductsModel.fromJson(value.data);
            return resault.data!.isEmpty
                ? emit(state.copyWith(
                    status: SearchFilterProductsStatus.success,
                    hasReachedMax: true,
                  ))
                : emit(state.copyWith(
                    products: resault.data,
                    status: SearchFilterProductsStatus.success,
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
                    status: SearchFilterProductsStatus.success,
                    hasReachedMax: true,
                  ))
                : emit(state.copyWith(
                    products: List.of(state.products)..addAll(resault.data!),
                    status: SearchFilterProductsStatus.success,
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
            status: SearchFilterProductsStatus.error,
            errorMsg: exceptionsHandle(error: error)));
      } else {
        emit(state.copyWith(
            status: SearchFilterProductsStatus.error,
            errorMsg: error.toString()));
      }
    }
  }
}

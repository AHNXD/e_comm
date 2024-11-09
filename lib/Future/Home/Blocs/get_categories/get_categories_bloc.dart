import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:e_comm/Apis/ExceptionsHandle.dart';
import 'package:e_comm/Apis/Network.dart';
import 'package:e_comm/Apis/Urls.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_comm/Future/Home/models/catigories_model.dart';
import 'package:equatable/equatable.dart';

part 'get_categories_event.dart';
part 'get_categories_state.dart';

class GetCategoriesBloc extends Bloc<GetCategoriesEvent, GetCategoriesState> {
  GetCategoriesBloc() : super(const GetCategoriesState()) {
    on<ResetPaginationCategoriesEvent>(
      (event, emit) => emit(state.copyWith(
        categories: [],
        status: GetCategoriesStatus.loading,
        hasReachedMax: false,
        totalPages: 1,
        currentPage: 1,
        errorMsg: "",
      )),
    );
    on<GetCategoriesEvent>((event, emit) async {
      if (event is GetAllCategoriesEvent) {
        if (state.hasReachedMax) return;
        try {
          if (state.status == GetCategoriesStatus.loading) {
            final response = await Network.getData(
                url: "${Urls.getCatigories}?per_page=5&page=1");
            if (response.statusCode == 200 || response.statusCode == 201) {
              CatigoriesModel categories =
                  CatigoriesModel.fromJson(response.data);

              return categories.data!.isEmpty
                  ? emit(state.copyWith(
                      status: GetCategoriesStatus.success, hasReachedMax: true))
                  : emit(state.copyWith(
                      status: GetCategoriesStatus.success,
                      categories: categories.data,
                      hasReachedMax: false,
                      currentPage: categories.pagination!.currentPage,
                      totalPages: categories.pagination!.total));
            }
          } else {
            final response = await Network.getData(
                url:
                    "${Urls.getCatigories}?per_page=5&page=${state.currentPage + 1}");
            if (response.statusCode == 200 || response.statusCode == 201) {
              CatigoriesModel categories =
                  CatigoriesModel.fromJson(response.data);
              categories.data!.isEmpty
                  ? emit(state.copyWith(hasReachedMax: true))
                  : emit(state.copyWith(
                      status: GetCategoriesStatus.success,
                      categories: List.of(state.categories)
                        ..addAll(categories.data!),
                      hasReachedMax: false,
                      currentPage: categories.pagination!.currentPage,
                      totalPages: categories.pagination!.total));
            }
          }
        } catch (error) {
          if (error is DioException) {
            emit(state.copyWith(
                status: GetCategoriesStatus.error,
                errorMsg: exceptionsHandle(error: error)));
          } else {
            emit(state.copyWith(
                status: GetCategoriesStatus.error, errorMsg: error.toString()));
          }
        }
      }
    }, transformer: droppable());
  }
}

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:zein_store/Apis/ExceptionsHandle.dart';
import 'package:zein_store/Apis/Network.dart';
import 'package:zein_store/Apis/Urls.dart';
import 'package:zein_store/Future/Home/models/product_model.dart';
import 'package:equatable/equatable.dart';

part 'get_offers_event.dart';
part 'get_offers_state.dart';

class GetOffersBloc extends Bloc<GetOffersEvent, GetOffersState> {
  GetOffersBloc() : super(const GetOffersState()) {
    on<ResetPaginationAllOffersEvent>((event, emit) => emit(
          state.copyWith(
              offersProducts: [],
              hasReachedMax: false,
              status: GetOffersStatus.loading,
              currentPage: 1,
              totalPages: 1,
              errorMsg: ""),
        ));
    on<GetOffersEvent>((event, emit) async {
      if (event is GetAllOffersEvent) {
        if (state.hasReachedMax) return;
        try {
          if (state.status == GetOffersStatus.loading) {
            final response = await Network.getData(
                url: "${Urls.getOffersProducts}?per_page=5&page=1");
            if (response.statusCode == 200 || response.statusCode == 201) {
              ProductsModel offers = ProductsModel.fromJson(response.data);

              return offers.data!.isEmpty
                  ? emit(state.copyWith(
                      status: GetOffersStatus.success, hasReachedMax: true))
                  : emit(state.copyWith(
                      status: GetOffersStatus.success,
                      offersProducts: offers.data,
                      hasReachedMax: false,
                      currentPage: offers.pagination!.currentPage,
                      totalPages: offers.pagination!.total));
            }
          } else {
            final response = await Network.getData(
                url:
                    "${Urls.getOffersProducts}?per_page=5&page=${state.currentPage + 1}");
            if (response.statusCode == 200 || response.statusCode == 201) {
              ProductsModel offers = ProductsModel.fromJson(response.data);
              offers.data!.isEmpty
                  ? emit(state.copyWith(hasReachedMax: true))
                  : emit(state.copyWith(
                      status: GetOffersStatus.success,
                      offersProducts: List.of(state.offersProducts)
                        ..addAll(offers.data!),
                      hasReachedMax: false,
                      currentPage: offers.pagination!.currentPage,
                      totalPages: offers.pagination!.total));
            }
          }
        } catch (error) {
          if (error is DioException) {
            emit(state.copyWith(
                status: GetOffersStatus.error,
                errorMsg: exceptionsHandle(error: error)));
          } else {
            emit(state.copyWith(
                status: GetOffersStatus.error, errorMsg: error.toString()));
          }
        }
      }
    }, transformer: droppable());
  }
}

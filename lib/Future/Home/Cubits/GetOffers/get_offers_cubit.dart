import 'package:e_comm/Future/Home/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:e_comm/Apis/ExceptionsHandle.dart';
import 'package:e_comm/Apis/Network.dart';
import 'package:e_comm/Apis/Urls.dart';
import 'package:meta/meta.dart';

part 'get_offers_state.dart';

class GetOffersCubit extends Cubit<GetOffersState> {
  GetOffersCubit() : super(GetOffersInitial());
  //List<MainProduct>? productOffers = [];

  void getOffers() async {
    emit(GetOffersLoadingState());
    try {
      await Network.getData(
              url: "${Urls.getOffersProducts}?per_page=100&page=1")
          .then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          ProductsModel products = ProductsModel.fromJson(response.data);
          emit(GetOffersSuccessfulState(products: products.data!));
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          GetOffersErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        GetOffersErrorState(error.toString());
      }
    }
  }
}

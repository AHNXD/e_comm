import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:e_comm/Apis/ExceptionsHandle.dart';
import 'package:e_comm/Apis/Network.dart';
import 'package:e_comm/Apis/Urls.dart';
import 'package:meta/meta.dart';

part 'post_products_state.dart';

class PostProductsCubit extends Cubit<PostProductsState> {
  PostProductsCubit() : super(PostProductsInitial());
  void filterProducts(String? search, String? min, String? max, String? wight,
      int? catigoryId) async {
    emit(PostProductsLoadingState());
    try {
      await Network.postData(url: Urls.filterProducts, data: {
        if (search != null) {"search": search},
        if (min != null) {"min": min},
        if (max != null) {"max": max},
        if (wight != null) {"wight": wight},
        if (catigoryId != null) {"category_id": catigoryId},
      }).then((value) {
        if (value.statusCode == 200 || value.statusCode == 201) {
          emit(PostProductsSuccessfulState());
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          PostProductsErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        PostProductsErrorState(error.toString());
      }
    }
  }
}

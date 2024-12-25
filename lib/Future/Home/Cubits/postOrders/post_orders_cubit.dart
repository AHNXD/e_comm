import 'package:zein_store/Future/Home/models/order_information.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:zein_store/Apis/ExceptionsHandle.dart';
import 'package:zein_store/Apis/Network.dart';
import 'package:zein_store/Apis/Urls.dart';
import 'package:meta/meta.dart';

part 'post_orders_state.dart';

class PostOrdersCubit extends Cubit<PostOrdersState> {
  PostOrdersCubit() : super(PostOrdersInitial());

  void sendOrder(OrderInformation order) async {
    emit(PostOrdersLoadingState());

    try {
      final response =
          await Network.postData(url: Urls.storeOrder, data: order.toJson());

      // Handle successful response (200 or 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (responseData['status'] as bool) {
          emit(PostOrdersSuccessfulState());
        } else {
          final errorMessage = responseData['msg'];
          emit(PostOrdersErrorState(errorMessage));
        }
      } else {
        // Handle non-200/201 response codes
        final errorMessage = response.data['msg'];
        emit(PostOrdersErrorState(errorMessage));
      }
    } on DioException catch (error) {
      // Handle Dio-specific errors
      emit(PostOrdersErrorState(exceptionsHandle(error: error)));
    } catch (error) {
      // Handle other exceptions
      emit(PostOrdersErrorState(error.toString()));
    }
  }

  void cancelOrder(int id) async {
    emit(PostOrdersLoadingState());
    try {
      await Network.postData(url: "${Urls.cancelOrder}/$id", data: {})
          .then((value) {
        if (value.statusCode == 200 || value.statusCode == 201) {
          emit(PostOrdersSuccessfulState());
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          PostOrdersErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        PostOrdersErrorState(error.toString());
      }
    }
  }

  void storeComment(int id, String text) async {
    emit(PostOrdersLoadingState());
    try {
      await Network.postData(url: Urls.comment, data: {
        "product_id": id,
        "comment": text,
      }).then((value) {
        if (value.statusCode == 200 || value.statusCode == 201) {
          emit(PostOrdersSuccessfulState());
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          PostOrdersErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        PostOrdersErrorState(error.toString());
      }
    }
  }

  void review(int id, int rating) async {
    emit(PostOrdersLoadingState());
    try {
      await Network.postData(url: Urls.review, data: {
        "product_id": id,
        "rating": rating,
      }).then((value) {
        if (value.statusCode == 200 || value.statusCode == 201) {
          emit(PostOrdersSuccessfulState());
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          PostOrdersErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        PostOrdersErrorState(error.toString());
      }
    }
  }
}

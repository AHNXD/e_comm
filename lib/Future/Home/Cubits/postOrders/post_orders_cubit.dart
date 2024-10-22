import 'package:e_comm/Future/Home/models/order_information.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:e_comm/Apis/ExceptionsHandle.dart';
import 'package:e_comm/Apis/Network.dart';
import 'package:e_comm/Apis/Urls.dart';
import 'package:meta/meta.dart';

part 'post_orders_state.dart';

class PostOrdersCubit extends Cubit<PostOrdersState> {
  PostOrdersCubit() : super(PostOrdersInitial());

  void sendOrder(OrderInformation order) {
    emit(PostOrdersLoadingState());
    try {
      Network.postData(url: Urls.storeOrder, data: order.toJson())
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

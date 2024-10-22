import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import 'package:meta/meta.dart';

import '../../../../Apis/ExceptionsHandle.dart';
import '../../../../Apis/Network.dart';
import '../../../../Apis/Urls.dart';
import '../../../../Utils/constants.dart';
import '../../models/print_image_model.dart';

part 'print_image_state.dart';

class PrintImageCubit extends Cubit<PrintImageState> {
  PrintImageCubit() : super(PrintImageInitial());

  void sendPrintImageOrder(PrintImageModel printImage) async {
    try {
      final formData = await printImage.toFormData();
      final response = await Network.postDataWithFiles(
        url: Urls.printImage,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(PrintImageSuccess(
            msg: response.data['msg'] ?? 'Order placed successfully.'));
      } else {
        emit(PrintImageError(
          error: lang == 'en'
              ? 'Failed to place order. Please try again.'
              : 'فشل في تقديم الطلب. الرجاء المحاولة مرة أخرى.',
        ));
      }
    } catch (error) {
      if (error is DioException) {
        emit(PrintImageError(error: exceptionsHandle(error: error)));
      } else {
        emit(PrintImageError(error: error.toString()));
      }
    }
  }
}

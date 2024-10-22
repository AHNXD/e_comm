// ignore_for_file: file_names, unnecessary_brace_in_string_interps, avoid_print

import 'package:dio/dio.dart';

String exceptionsHandle({required DioException error}) {
  String? message;

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      message = "server_not_responding";

      return message;

    case DioExceptionType.sendTimeout:
      message = 'request_timeout';

      return message;
    case DioExceptionType.receiveTimeout:
      message = "server_not_responding";

      return message;
    case DioExceptionType.badResponse:
      // message = error.response!.data['msg'];
      print("error type is ${message}");
      message = "server_error";

      return message;
    case DioExceptionType.cancel:
      message = "request_canceled";

      return message;
    case DioExceptionType.unknown:
      // error.message!.contains('SocketException')
      //     ? message = "no_internet"
      //     : message = error.message!;
      if (error.message != null) {
        error.message!.contains('SocketException')
            ? message = "no_internet"
            : message = error.message!;
      } else {
        message = "unknown_error";
      }
      return message;
    case DioExceptionType.badCertificate:
      message = 'unknown_error';
      return message;
    case DioExceptionType.connectionError:
      message = 'no_internet';
      return message;
  }
}

// ignore_for_file: file_names, unnecessary_brace_in_string_interps, avoid_print

import 'package:dio/dio.dart';

import '../Utils/constants.dart';

String exceptionsHandle({required DioException error}) {
  String? message;

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      message = lang == 'en'
          ? "Connection timeoute with server"
          : "انتهت مهلة الاتصال بالخادم";

      return message;

    case DioExceptionType.sendTimeout:
      message = lang == 'en'
          ? 'request timeout with server'
          : "انتهت مهلة طلبك للخادم";

      return message;
    case DioExceptionType.receiveTimeout:
      message = lang == 'en' ? "server not responding" : "الخادم لا يستجيب";

      return message;

    case DioExceptionType.cancel:
      message = lang == 'en'
          ? "request canceled with server"
          : "تم الغاء الطلب للخادم";

      return message;
    case DioExceptionType.unknown:
      // error.message!.contains('SocketException')
      //     ? message = "no_internet"
      //     : message = error.message!;
      if (error.message != null) {
        error.message!.contains('SocketException')
            ? message = lang == 'en'
                ? "No internet connection"
                : "لايوجد اتصال بالانترنت"
            : message = error.message!;
      } else {
        message = lang == 'en' ? "Unknown error" : "خطأ غير معروف";
      }
      return message;
    case DioExceptionType.badCertificate:
      message = lang == 'en' ? "Unknown error" : "خطأ غير معروف";
      return message;
    case DioExceptionType.connectionError:
      message =
          lang == 'en' ? "No internet connection" : "لايوجد اتصال بالانترنت";
      return message;

    case DioExceptionType.badResponse:
      if (error.response!.statusCode == 400 ||
          error.response!.statusCode == 401 ||
          error.response!.statusCode == 403) {
        message = error.response!.data['msg'];
      } else if (error.response!.statusCode == 503) {
        message = error.response!.data['msg'];
      } else if (error.response!.statusCode == 404) {
        message = lang == "en" ? "your requst not found" : "الطلب لم يوجد";
      } else if (error.response!.statusCode == 500) {
        message = lang == "en" ? "Internal server error" : "خطأ في الخادم ";
      } else {
        message = lang == "en"
            ? "Opps there is was an error"
            : "هنالك خطأ ماالرجاء المحاولة لاحقا ";
      }
      return message!;
    default:
      message = lang == "en"
          ? "Opps there is was an error"
          : "هنالك خطأ ماالرجاء المحاولة لاحقا ";
      return message;
  }
}

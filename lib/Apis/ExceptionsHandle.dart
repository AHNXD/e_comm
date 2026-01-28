import 'package:dio/dio.dart';

import '../Utils/constants.dart';

final Map<String, String> enMessages = {
  "connectionTimeout": "Connection timeout with the server.",
  "sendTimeout": "Request timeout with the server.",
  "receiveTimeout": "The server is not responding.",
  "cancel": "Request was canceled.",
  "noInternet": "No internet connection.",
  "unknownError": "Unknown error occurred.",
  "badCertificate": "Bad certificate error.",
  "connectionError": "No internet connection.",
  "serverError": "Oops, there was an error. Please try again later.",
  "notFound": "The requested resource was not found.",
  "internalServerError": "Internal server error. Please try again later.",
  "validationError": "Invalid input data."
};

final Map<String, String> arMessages = {
  "connectionTimeout": "انتهت مهلة الاتصال بالخادم",
  "sendTimeout": "انتهت مهلة الطلب للخادم",
  "receiveTimeout": "الخادم لا يستجيب",
  "cancel": "تم إلغاء الطلب",
  "noInternet": "لا يوجد اتصال بالإنترنت",
  "unknownError": "حدث خطأ غير معروف",
  "badCertificate": "خطأ في الشهادة",
  "connectionError": "لا يوجد اتصال بالإنترنت",
  "serverError": "هنالك خطأ ما، الرجاء المحاولة لاحقاً",
  "notFound": "الطلب غير موجود",
  "internalServerError": "خطأ في الخادم، الرجاء المحاولة لاحقاً",
  "validationError": "بيانات غير صالحة"
};

String exceptionsHandle({required DioException error}) {
  String? message;
  Map<String, String> messages = lang == 'en' ? enMessages : arMessages;

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      message = messages["connectionTimeout"];
      return message!;

    case DioExceptionType.sendTimeout:
      message = messages["sendTimeout"];
      return message!;

    case DioExceptionType.receiveTimeout:
      message = messages["receiveTimeout"];
      return message!;

    case DioExceptionType.cancel:
      message = messages["cancel"];
      return message!;

    case DioExceptionType.unknown:
      if (error.message != null && error.message!.contains('SocketException')) {
        message = messages["noInternet"];
      } else {
        message = messages["unknownError"];
      }
      return message!;

    case DioExceptionType.badCertificate:
      message = messages["badCertificate"];
      return message!;

    case DioExceptionType.connectionError:
      message = messages["connectionError"];
      return message!;

    case DioExceptionType.badResponse:
      if (error.response != null) {
        switch (error.response!.statusCode) {
          case 400:
          case 401:
          case 403:
            message =
                error.response!.data['msg'] ?? error.response!.data['message'];
            break;

          case 503:
            message = error.response!.data['msg'] ?? messages["serverError"];
            break;

          case 404:
            message = messages["notFound"];
            break;

          case 500:
            message =
                error.response!.data['msg'] ?? messages["internalServerError"];
            break;

          case 422:
            message = _handleValidationErrors(error.response!.data, messages);
            break;

          default:
            message = messages["serverError"];
            break;
        }
      } else {
        message = lang == "en"
            ? "Opps there is was an error"
            : "هنالك خطأ ماالرجاء المحاولة لاحقا ";
      }
      return message!;
    }
}

String _handleValidationErrors(
    Map<String, dynamic> data, Map<String, String> messages) {
  Map<String, dynamic>? errors = data['errors'];

  if (errors != null && errors.isNotEmpty) {
    List<String> errorMessages = [];

    errors.forEach((key, value) {
      if (value is List) {
        errorMessages.addAll(value.map((v) => v.toString()));
      }
    });

    String combinedErrors = errorMessages.join(", ");
    return combinedErrors;
  }

  return messages["validationError"]!;
}

import 'package:dio/dio.dart';

class ContactusModel {
  final String? username;
  final String? emailOrPhone;
  final String? msg;

  ContactusModel({required this.username, required this.emailOrPhone, required this.msg});

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      "name": username,
      "email_or_phone": emailOrPhone,
      "message": msg,
    });
  }
}

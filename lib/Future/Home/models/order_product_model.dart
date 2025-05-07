import 'dart:io';

import 'package:dio/dio.dart';

class OrderProductModel {
  final String firstName;
  final String lastName;
  final String phone;
  final String description;
  final String? notes;
  final File? image;

  OrderProductModel(
    this.firstName,
    this.lastName,
    this.phone,
    this.description,
    this.notes,
    this.image,
  );

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'description': description,
      'notes': notes,
      if (image != null) 'image': await MultipartFile.fromFile(image!.path),
    });
  }
}

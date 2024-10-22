import 'dart:io';

import 'package:dio/dio.dart';

class PrintImageModel {
  String? firstName;
  String? lastName;
  String? phone;
  String? province;
  String? region;
  String? address;
  String? printSizeId;
  int? quantity;
  File? image;

  PrintImageModel({
    this.firstName,
    this.lastName,
    this.phone,
    this.province,
    this.region,
    this.address,
    this.printSizeId,
    this.quantity,
    this.image,
  });

  Future<FormData> toFormData() async {
    MultipartFile? imageFile;
    if (image != null) {
      String fileName = image!.path.split('/').last;
      imageFile = await MultipartFile.fromFile(image!.path, filename: fileName);
    }

    return FormData.fromMap({
      "first_name": firstName,
      "last_name": lastName,
      "phone": phone,
      "province": province,
      "region": region,
      "address": address,
      "print_size_id": printSizeId,
      "quantity": quantity,
      "image": imageFile,
    });
  }
}

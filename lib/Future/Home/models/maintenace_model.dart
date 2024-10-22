// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';

class MaintenaceModel {
  String? firstName;
  String? lastName;
  String? phone;
  String? province;
  String? region;
  String? address;
  String? problemCause;
  String? description;
  MaintenaceModel({
    this.firstName,
    this.lastName,
    this.phone,
    this.province,
    this.region,
    this.address,
    this.problemCause,
    this.description,
  });

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      "first_name": firstName,
      "last_name": lastName,
      "phone": phone,
      "province": province,
      "region": region,
      "address": address,
      "problem_cause": problemCause,
      "description": description,
    });
  }
}

// ignore_for_file: file_names, deprecated_member_use

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:zein_store/Utils/SharedPreferences/SharedPreferencesHelper.dart';
import 'package:zein_store/Utils/constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class Network {
  static late Dio dio;

  static init() {
    dio = Dio(BaseOptions(
        sendTimeout: const Duration(minutes: 1),
        headers: {
          'Authorization': "Bearer ${AppSharedPreferences.getToken}",
          'Content-Type': 'application/json',
          // "Accept": 'application/json',
          "Accept-Charset": "application/json",
          "Accept-Language": lang,
        },
        connectTimeout: const Duration(minutes: 1),
        receiveTimeout: const Duration(minutes: 1)));

    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        request: true,
        compact: true,
        maxWidth: 10000));

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  static Future<Response> getData({
    required String url,
  }) async {
    dio.options.headers = {
      'Authorization': "Bearer ${AppSharedPreferences.getToken}",
      'Content-Type': 'application/json',
      "Accept": 'application/json',
      "Accept-Charset": "application/json",
      "Accept-Language": lang,
    };
    final response = await dio.get(url);
    return response;
  }

  static Future<Response> postData({
    required String url,
    dynamic data,
  }) async {
    dio.options.headers = {
      'Authorization': "Bearer ${AppSharedPreferences.getToken}",
      'Content-Type': 'application/json',
      "Accept": 'application/json',
      "Accept-Charset": "application/json",
      "Accept-Language": lang,
    };
    return await dio.post(
      url,
      data: data,
    );
  }

  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? data,
  }) async {
    dio.options.headers = {
      'Authorization': "Bearer ${AppSharedPreferences.getToken}",
      'Content-Type': 'application/json',
      "Accept": 'application/json',
      "Accept-Charset": "application/json"
    };
    return await dio.put(url, data: data);
  }

  static Future<Response> patchData({
    required String url,
    Map<String, dynamic>? data,
  }) async {
    dio.options.headers = {
      'Authorization': "Bearer ${AppSharedPreferences.getToken}",
      'Content-Type': 'application/json',
      "Accept": 'application/json',
      "Accept-Charset": "application/json"
    };
    return await dio.patch(url, data: data);
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? data,
  }) async {
    return await dio.delete(url, data: data);
  }

  static Future<Response> postDataWithFiles({
    required String url,
    dynamic data,
  }) async {
    dio.options.headers = {
      'Authorization': "Bearer ${AppSharedPreferences.getToken}",
      "Accept": 'application/json',
      "Accept-Language": lang,
    };

    return await dio.post(
      url,
      data: data,
    );
  }
}

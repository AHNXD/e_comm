import 'package:e_comm/Future/Home/models/catigories_model.dart';
import 'package:e_comm/Future/Home/models/product_model.dart';

class LatestProductsModel {
  bool? status;
  List<LatestProducts>? data;
  Pagination? pagination;

  LatestProductsModel({this.status, this.data, this.pagination});

  LatestProductsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <LatestProducts>[];
      json['data'].forEach((v) {
        data!.add(LatestProducts.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class LatestProducts {
  CatigoriesData? category;
  List<MainProduct>? products;

  LatestProducts({this.category, this.products});

  LatestProducts.fromJson(Map<String, dynamic> json) {
    category = json['category'] != null
        ? CatigoriesData.fromJson(json['category'])
        : null;
    if (json['products'] != null) {
      products = <MainProduct>[];
      json['products'].forEach((v) {
        products!.add(MainProduct.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pagination {
  int? total;
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? from;
  int? to;

  Pagination(
      {this.total,
      this.currentPage,
      this.lastPage,
      this.perPage,
      this.from,
      this.to});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    data['per_page'] = perPage;
    data['from'] = from;
    data['to'] = to;
    return data;
  }
}

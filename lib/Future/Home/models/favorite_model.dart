import 'package:zein_store/Future/Home/models/product_model.dart';

class FavoriteModel {
  bool? status;
  List<MainProduct>? data;
  Pagination? pagination;

  FavoriteModel({this.status, this.data, this.pagination});

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <MainProduct>[];
      json['data'].forEach((v) {
        data!.add(MainProduct.fromJson(v['product']));
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

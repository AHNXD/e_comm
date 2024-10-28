import 'package:e_comm/Future/Home/models/product_model.dart';

class OrdersInformation {
  bool? status;
  List<OrderInformationData>? data;

  OrdersInformation({this.status, this.data});

  OrdersInformation.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <OrderInformationData>[];
      json['data'].forEach((v) {
        data!.add(OrderInformationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderInformationData {
  int? id;
  String? phone;
  String? firstName;
  String? lastName;
  String? address;
  String? province;
  String? region;
  String? notes;
  String? status;
  String? total;
  String? totalAfterDiscount;
  int? userId;
  int? couponId;
  String? couponValue;
  String? orderDate;
  String? createdAt;
  String? updatedAt;
  List<Details>? details;

  OrderInformationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    address = json['address'];
    province = json['province'];
    region = json['region'];
    notes = json['notes'];
    status = json['status'];
    total = json['total'];
    totalAfterDiscount = json['total_after_discount'];
    userId = json['user_id'];
    couponId = json['coupon_id'];
    couponValue = json['coupon_value'];
    orderDate = json['order_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phone'] = phone;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['address'] = address;
    data['province'] = province;
    data['region'] = region;
    data['notes'] = notes;
    data['status'] = status;
    data['total'] = total;
    data['total_after_discount'] = totalAfterDiscount;
    data['user_id'] = userId;
    data['coupon_id'] = couponId;
    data['coupon_value'] = couponValue;
    data['order_date'] = orderDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (details != null) {
      data['details'] = details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  String? price;
  int? quantity;
  String? size;
  MainProduct? product;

  Details({this.price, this.quantity, this.size, this.product});

  Details.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    quantity = json['quantity'];
    size = json['size'];
    product =
        json['product'] != null ? MainProduct.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['quantity'] = quantity;
    data['size'] = size;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

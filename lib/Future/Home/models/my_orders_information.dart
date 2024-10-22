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

  OrderInformationData(
      {this.id,
      this.phone,
      this.firstName,
      this.lastName,
      this.address,
      this.province,
      this.region,
      this.notes,
      this.status,
      this.total,
      this.totalAfterDiscount,
      this.userId,
      this.couponId,
      this.couponValue,
      this.orderDate,
      this.createdAt,
      this.updatedAt,
      this.details});

  OrderInformationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    address = json['address'];
    province = json['province'];
    region = json['region'];
    if (notes != null) {
      notes = json['notes'];
    }
    status = json['status'];
    total = json['total'];

    totalAfterDiscount = json['total_after_discount'];
    userId = json['user_id'];

    if (couponId != null) {
      couponId = json['coupon_id'];
    }
    if (couponValue != null) {
      couponValue = json['coupon_value'];
    }

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
  int? id;
  int? orderId;
  int? productId;
  String? productName;
  String? price;
  int? quantity;
  String? createdAt;
  String? updatedAt;
  MainProduct? product;
  String? size;
  Details(
      {this.id,
      this.orderId,
      this.productId,
      this.productName,
      this.price,
      this.quantity,
      this.createdAt,
      this.updatedAt,
      this.product,
      this.size});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    size = json['size'];
    productId = json['product_id'];
    productName = json['product_name'];
    price =
        (json['price'] is String) ? int.tryParse(json['price']) : json['price'];
    quantity = json['quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product =
        json['product'] != null ? MainProduct.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['price'] = price;
    data['quantity'] = quantity;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

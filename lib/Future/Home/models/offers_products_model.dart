class OffersProductsModel {
  bool? status;
  List<OffersProductsData>? data;

  OffersProductsModel({this.status, this.data});

  OffersProductsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <OffersProductsData>[];  
      json['data'].forEach((v) {
        data!.add(OffersProductsData.fromJson(v));
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

class OffersProductsData {
  int? id;
  int? productId;
  int? categoryId;
  int? status;
  int? percentageDiscount;
  int? priceDiscount;
  String? createdAt;
  String? updatedAt;
  OffersProductsDataProduct? product;

  OffersProductsData(
      {this.id,
      this.productId,
      this.categoryId,
      this.status,
      this.percentageDiscount,
      this.priceDiscount,
      this.createdAt,
      this.updatedAt,
      this.product});

  OffersProductsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    categoryId = json['category_id'];
    status = json['status'];
    percentageDiscount = json['Percentage_discount'];
    priceDiscount = json['price_discount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product =
        json['product'] != null ? OffersProductsDataProduct.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['category_id'] = categoryId;
    data['status'] = status;
    data['Percentage_discount'] = percentageDiscount;
    data['price_discount'] = priceDiscount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class OffersProductsDataProduct {
  int? id;
  String? name;
  int? wight;
  int? categoryId;
  int? weightMeasurementId;
  int? sellingPrice;
  int? newSellingPrice;
  int? quantity;
  String? descrption;
  List<Files>? files;
  List<Ratings>? ratings;
  Category? category;

  OffersProductsDataProduct(
      {this.id,
      this.name,
      this.wight,
      this.categoryId,
      this.weightMeasurementId,
      this.sellingPrice,
      this.newSellingPrice,
      this.quantity,
      this.descrption,
      this.files,
      this.ratings,
      this.category});

  OffersProductsDataProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    wight = json['wight'];
    categoryId = json['category_id'];
    weightMeasurementId = json['weight_measurement_id'];
    sellingPrice = json['selling_price'];
    newSellingPrice = json['new_selling_price'];
    quantity = json['quantity'];
    descrption = json['descrption'];
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(Files.fromJson(v));
      });
    }
    if (json['ratings'] != null) {
      ratings = <Ratings>[];
      json['ratings'].forEach((v) {
        ratings!.add(Ratings.fromJson(v));
      });
    }
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['wight'] = wight;
    data['category_id'] = categoryId;
    data['weight_measurement_id'] = weightMeasurementId;
    data['selling_price'] = sellingPrice;
    data['new_selling_price'] = newSellingPrice;
    data['quantity'] = quantity;
    data['descrption'] = descrption;
    if (files != null) {
      data['files'] = files!.map((v) => v.toJson()).toList();
    }
    if (ratings != null) {
      data['ratings'] = ratings!.map((v) => v.toJson()).toList();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}

class Files {
  int? id;
  String? name;
  String? path;
  String? fileableType;
  int? fileableId;

  Files({this.id, this.name, this.path, this.fileableType, this.fileableId});

  Files.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    path = json['path'];
    fileableType = json['fileable_type'];
    fileableId = json['fileable_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['path'] = path;
    data['fileable_type'] = fileableType;
    data['fileable_id'] = fileableId;
    return data;
  }
}

class Ratings {
  int? productId;
  int? rating;

  Ratings({this.productId, this.rating});

  Ratings.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['rating'] = rating;
    return data;
  }
}

class Category {
  int? id;
  String? name;
  int? parentId;
  Parent? parent;

  Category({this.id, this.name, this.parentId, this.parent});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'];
    parent = json['parent'] != null ? Parent.fromJson(json['parent']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['parent_id'] = parentId;
    if (parent != null) {
      data['parent'] = parent!.toJson();
    }
    return data;
  }
}

class Parent {
  int? id;
  String? name;
  int? parentId;

  Parent({this.id, this.name, this.parentId});

  Parent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['parent_id'] = parentId;
    return data;
  }
}

class OffersCatigoriesModel {
  bool? status;
  List<OffersCatigoriesData>? data;

  OffersCatigoriesModel({this.status, this.data});

  OffersCatigoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <OffersCatigoriesData>[];
      json['data'].forEach((v) {
        data!.add(OffersCatigoriesData.fromJson(v));
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

class OffersCatigoriesData {
  int? id;
  int? productId;
  int? categoryId;
  int? status;
  int? percentageDiscount;
  int? priceDiscount;
  String? createdAt;
  String? updatedAt;
  Category? category;

  OffersCatigoriesData(
      {this.id,
      this.productId,
      this.categoryId,
      this.status,
      this.percentageDiscount,
      this.priceDiscount,
      this.createdAt,
      this.updatedAt,
      this.category});

  OffersCatigoriesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    categoryId = json['category_id'];
    status = json['status'];
    percentageDiscount = json['Percentage_discount'];
    priceDiscount = json['price_discount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
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
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}

class Category {
  int? id;
  String? name;
  int? parentId;
  List<Files>? files;
  Parent? parent;

  Category({this.id, this.name, this.parentId, this.files, this.parent});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'];
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(Files.fromJson(v));
      });
    }
    parent = json['parent'] != null ? Parent.fromJson(json['parent']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['parent_id'] = parentId;
    if (files != null) {
      data['files'] = files!.map((v) => v.toJson()).toList();
    }
    if (parent != null) {
      data['parent'] = parent!.toJson();
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

class Parent {
  int? id;
  String? name;

  Parent({this.id, this.name});

  Parent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

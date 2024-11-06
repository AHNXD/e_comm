// ignore_for_file: prefer_typing_uninitialized_variables

class ProductsModel {
  bool? status;
  List<MainProduct>? data;
  Pagination? pagination;

  ProductsModel({this.status, this.data, this.pagination});

  ProductsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <MainProduct>[];
      json['data'].forEach((v) {
        data!.add(MainProduct.fromJson(v));
      });
    }
    if (json['pagination'] != null) {
      pagination = Pagination.fromJson(json['pagination']);
    }
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

class MainProduct {
  int? id;
  String? name;
  int? categoryId;
  String? sellingPrice;
  String? descrption;
  int userQuantity = 1;
  String? selectedSize;
  bool isFavorite = false;
  List<Files>? files;
  List<String>? sizes;
  bool? isOffer;
  Offers? offers;

  MainProduct(
      {this.id,
      this.name,
      this.categoryId,
      this.sellingPrice,
      this.descrption,
      this.files,
      this.sizes,
      this.selectedSize,
      this.isOffer,
      this.offers});

  MainProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    sellingPrice = json['new_selling_price'];
    descrption = json['descrption'];
    if (json['IsOffer'] != null) {
      isOffer = json['IsOffer'];
    } else {
      isOffer = false;
    }
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(Files.fromJson(v));
      });
    }
    offers = json['offers'] != null ? Offers.fromJson(json['offers']) : null;
    sizes = json['sizes'] != null ? List<String>.from(json['sizes']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['category_id'] = categoryId;
    data['new_selling_price'] = sellingPrice;
    data['descrption'] = descrption;
    data['IsOffer'] = isOffer;
    if (files != null) {
      data['files'] = files!.map((v) => v.toJson()).toList();
    }
    if (sizes != null) {
      data['sizes'] = sizes;
    }
    if (offers != null) {
      data['offers'] = offers;
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

class WeightMeasurement {
  int? id;
  String? name;

  WeightMeasurement({this.id, this.name});

  WeightMeasurement.fromJson(Map<String, dynamic> json) {
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

class Category {
  int? id;
  String? name;
  int? parentId;
  WeightMeasurement? parent;

  Category({this.id, this.name, this.parentId, this.parent});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'];
    parent = json['parent'] != null
        ? WeightMeasurement.fromJson(json['parent'])
        : null;
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

class Ratings {
  int? productId;
  var rating;

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

class Offers {
  String? priceDiscount;
  String? priceAfterOffer;

  Offers({this.priceDiscount, this.priceAfterOffer});

  Offers.fromJson(Map<String, dynamic> json) {
    priceDiscount = json['price_discount'].toString();
    priceAfterOffer = json['Price_after_offer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price_discount'] = priceDiscount;
    data['Price_after_offer'] = priceAfterOffer;
    return data;
  }
}

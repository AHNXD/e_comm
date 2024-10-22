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
  int? wight;
  int? categoryId;
  int? weightMeasurementId;
  int? sellingPrice;
  String? newSellingPrice;
  int? quantity;
  String? descrption;
  int userQuantity = 1;
  String? selectedSize;
  bool isFavorite = false;
  List<Files>? files;
  WeightMeasurement? weightMeasurement;
  Category? category;
  List<Ratings>? ratings;
  List<String>? sizes;
  MainProduct({
    this.id,
    this.name,
    this.wight,
    this.categoryId,
    this.weightMeasurementId,
    this.sellingPrice,
    this.newSellingPrice,
    this.quantity,
    this.descrption,
    this.files,
    this.weightMeasurement,
    this.category,
    this.ratings,
    this.sizes,
    this.selectedSize,
  });

  MainProduct.fromJson(Map<String, dynamic> json) {
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
    weightMeasurement = json['weight_measurement'] != null
        ? WeightMeasurement.fromJson(json['weight_measurement'])
        : null;
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    if (json['ratings'] != null) {
      ratings = <Ratings>[];
      json['ratings'].forEach((v) {
        ratings!.add(Ratings.fromJson(v));
      });
    } else {
      ratings = null;
    }
    sizes = json['sizes'] != null ? List<String>.from(json['sizes']) : null;
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
    if (weightMeasurement != null) {
      data['weight_measurement'] = weightMeasurement!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (ratings != null) {
      data['ratings'] = ratings!.map((v) => v.toJson()).toList();
    }
    if (sizes != null) {
      data['sizes'] = sizes;
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
  int? current_page;
  int? last_page;
  int? per_page;
  int? from;
  int? to;

  Pagination(
      {this.total,
      this.current_page,
      this.last_page,
      this.per_page,
      this.from,
      this.to});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    current_page = json['current_page'];
    last_page = json['last_page'];
    per_page = json['per_page'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['current_page'] = current_page;
    data['last_page'] = last_page;
    data['per_page'] = per_page;
    data['from'] = from;
    data['to'] = to;
    return data;
  }
}




// class ProductsModel {
//   bool? status;
//   ProductsData? data;

//   ProductsModel({this.status, this.data});

//   ProductsModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     data = json['data'] != null ? ProductsData.fromJson(json['data']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }

// class ProductsData {
//   int? currentPage;
//   List<MainProduct>? products;
//   String? firstPageUrl;
//   int? from;
//   int? lastPage;
//   String? lastPageUrl;
//   List<Links>? links;
//   String? nextPageUrl;
//   String? path;
//   int? perPage;
//   String? prevPageUrl;
//   int? to;
//   int? total;

//   ProductsData(
//       {this.currentPage,
//       this.products,
//       this.firstPageUrl,
//       this.from,
//       this.lastPage,
//       this.lastPageUrl,
//       this.links,
//       this.nextPageUrl,
//       this.path,
//       this.perPage,
//       this.prevPageUrl,
//       this.to,
//       this.total});

//   ProductsData.fromJson(Map<String, dynamic> json) {
//     currentPage = json['current_page'];
//     if (json['data'] != null) {
//       products = <MainProduct>[];
//       json['data'].forEach((v) {
//         products!.add(MainProduct.fromJson(v));
//       });
//     }
//     firstPageUrl = json['first_page_url'];
//     from = json['from'];
//     lastPage = json['last_page'];
//     lastPageUrl = json['last_page_url'];
//     if (json['links'] != null) {
//       links = <Links>[];
//       json['links'].forEach((v) {
//         links!.add(Links.fromJson(v));
//       });
//     }
//     nextPageUrl = json['next_page_url'];
//     path = json['path'];
//     perPage = json['per_page'];
//     prevPageUrl = json['prev_page_url'];
//     to = json['to'];
//     total = json['total'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['current_page'] = currentPage;
//     if (products != null) {
//       data['data'] = products!.map((v) => v.toJson()).toList();
//     }
//     data['first_page_url'] = firstPageUrl;
//     data['from'] = from;
//     data['last_page'] = lastPage;
//     data['last_page_url'] = lastPageUrl;
//     if (links != null) {
//       data['links'] = links!.map((v) => v.toJson()).toList();
//     }
//     data['next_page_url'] = nextPageUrl;
//     data['path'] = path;
//     data['per_page'] = perPage;
//     data['prev_page_url'] = prevPageUrl;
//     data['to'] = to;
//     data['total'] = total;
//     return data;
//   }
// }

// class MainProduct {
//   int? id;
//   String? name;
//   int? wight;
//   int? categoryId;
//   int? weightMeasurementId;
//   int? sellingPrice;
//   int? newSellingPrice;
//   int? quantity;
//   String? descrption;
//   List<Files>? files;
//   List<Ratings>? ratings;
//   Category? category;
//   WeightMeasurement? weightMeasurement;

//   MainProduct(
//       {this.id,
//       this.name,
//       this.wight,
//       this.categoryId,
//       this.weightMeasurementId,
//       this.sellingPrice,
//       this.newSellingPrice,
//       this.quantity,
//       this.descrption,
//       this.files,
//       this.ratings,
//       this.category});

//   MainProduct.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     wight = json['wight'];
//     categoryId = json['category_id'];
//     weightMeasurementId = json['weight_measurement_id'];
//     sellingPrice = json['selling_price'];
//     newSellingPrice = json['new_selling_price'];
//     quantity = json['quantity'];
//     descrption = json['descrption'];
//     if (json['files'] != null) {
//       files = <Files>[];
//       json['files'].forEach((v) {
//         files!.add(Files.fromJson(v));
//       });
//     }
//     if (json['ratings'] != null) {
//       ratings = <Ratings>[];
//       json['ratings'].forEach((v) {
//         ratings!.add(Ratings.fromJson(v));
//       });
//     }
//     category =
//         json['category'] != null ? Category.fromJson(json['category']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['wight'] = wight;
//     data['category_id'] = categoryId;
//     data['weight_measurement_id'] = weightMeasurementId;
//     data['selling_price'] = sellingPrice;
//     data['new_selling_price'] = newSellingPrice;
//     data['quantity'] = quantity;
//     data['descrption'] = descrption;
//     if (files != null) {
//       data['files'] = files!.map((v) => v.toJson()).toList();
//     }
//     if (ratings != null) {
//       data['ratings'] = ratings!.map((v) => v.toJson()).toList();
//     }
//     if (category != null) {
//       data['category'] = category!.toJson();
//     }
//     return data;
//   }
// }

// class Files {
//   int? id;
//   String? name;
//   String? path;
//   String? fileableType;
//   int? fileableId;
//   String? createdAt;
//   String? updatedAt;

//   Files(
//       {this.id,
//       this.name,
//       this.path,
//       this.fileableType,
//       this.fileableId,
//       this.createdAt,
//       this.updatedAt});

//   Files.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     path = json['path'];
//     fileableType = json['fileable_type'];
//     fileableId = json['fileable_id'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['path'] = path;
//     data['fileable_type'] = fileableType;
//     data['fileable_id'] = fileableId;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     return data;
//   }
// }

// class Ratings {
//   int? productId;
//   int? rating;

//   Ratings({this.productId, this.rating});

//   Ratings.fromJson(Map<String, dynamic> json) {
//     productId = json['product_id'];
//     rating = json['rating'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['product_id'] = productId;
//     data['rating'] = rating;
//     return data;
//   }
// }

// class Category {
//   int? id;
//   String? name;
//   int? parentId;
//   Parent? parent;

//   Category({this.id, this.name, this.parentId, this.parent});

//   Category.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     parentId = json['parent_id'];
//     parent = json['parent'] != null ? Parent.fromJson(json['parent']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['parent_id'] = parentId;
//     if (parent != null) {
//       data['parent'] = parent!.toJson();
//     }
//     return data;
//   }
// }

// class Parent {
//   int? id;
//   String? name;

//   Parent({this.id, this.name});

//   Parent.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     return data;
//   }
// }

// class WeightMeasurement {
//   int? id;
//   String? name;
//   WeightMeasurement({this.id, this.name});
//    WeightMeasurement.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     return data;
//   }
// }

// class Links {
//   String? url;
//   String? label;
//   bool? active;

//   Links({this.url, this.label, this.active});

//   Links.fromJson(Map<String, dynamic> json) {
//     url = json['url'];
//     label = json['label'];
//     active = json['active'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['url'] = url;
//     data['label'] = label;
//     data['active'] = active;
//     return data;
//   }
// }

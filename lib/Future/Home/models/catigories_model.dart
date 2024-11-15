class CatigoriesModel {
  bool? status;
  List<CatigoriesData>? data;
  Pagination? pagination;

  CatigoriesModel({this.status, this.data, this.pagination});

  CatigoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <CatigoriesData>[];
      json['data'].forEach((v) {
        data!.add(CatigoriesData.fromJson(v));
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

class CatigoriesData {
  int? id;
  String? name;
  int? parentId;
  List<CatigoriesData>? children;
  List<Files>? files;
  bool? isOffer;

  CatigoriesData(
      {this.id,
      this.name,
      this.parentId,
      this.children,
      this.files,
      this.isOffer});

  CatigoriesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'];
    isOffer = json['IsOffer'];
    if (json['child'] != null) {
      children = <CatigoriesData>[];
      json['child'].forEach((v) {
        children!.add(CatigoriesData.fromJson(v));
      });
    }
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(Files.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['parent_id'] = parentId;
    data['IsOffer'] = isOffer;
    if (children != null) {
      data['child'] = children!.map((v) => v.toJson()).toList();
    }
    if (files != null) {
      data['files'] = files!.map((v) => v.toJson()).toList();
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

// class CatigoriesModel {
//   bool? status;
//   List<CatigoriesData>? data;

//   CatigoriesModel({this.status, this.data});

//   CatigoriesModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     if (json['data'] != null) {
//       data = <CatigoriesData>[];
//       json['data'].forEach((v) {
//         data!.add(CatigoriesData.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class CatigoriesData {
//   int? id;
//   String? name;
//   int? parentId;
//   Parent? parent;
//   List<Files>? files;

//   CatigoriesData({this.id, this.name, this.parentId, this.parent, this.files});

//   CatigoriesData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     parentId = json['parent_id'];
//     parent = json['parent'] != null ? Parent.fromJson(json['parent']) : null;
//     if (json['files'] != null) {
//       files = <Files>[];
//       json['files'].forEach((v) {
//         files!.add(Files.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['parent_id'] = parentId;
//     if (parent != null) {
//       data['parent'] = parent!.toJson();
//     }
//     if (files != null) {
//       data['files'] = files!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Parent {
//   int? id;
//   String? name;
//   int? parentId;

//   Parent({this.id, this.name, this.parentId});

//   Parent.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     parentId = json['parent_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['parent_id'] = parentId;
//     return data;
//   }
// }

// class Files {
//   int? id;
//   String? name;
//   String? path;
//   String? fileableType;
//   int? fileableId;

//   Files({this.id, this.name, this.path, this.fileableType, this.fileableId});

//   Files.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     path = json['path'];
//     fileableType = json['fileable_type'];
//     fileableId = json['fileable_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['path'] = path;
//     data['fileable_type'] = fileableType;
//     data['fileable_id'] = fileableId;
//     return data;
//   }
// }

///
class CatigoriesModel {
  bool? status;
  List<CatigoriesData>? data;

  CatigoriesModel({this.status, this.data});

  CatigoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <CatigoriesData>[];
      json['data'].forEach((v) {
        data!.add(CatigoriesData.fromJson(v));
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

class CatigoriesData {
  int? id;
  String? name;
  int? parentId;
  List<Children>? children;
  List<Files>? files;

  CatigoriesData(
      {this.id, this.name, this.parentId, this.children, this.files});

  CatigoriesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'];
    if (json['children'] != null) {
      children = <Children>[];
      json['children'].forEach((v) {
        children!.add(Children.fromJson(v));
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
    if (children != null) {
      data['children'] = children!.map((v) => v.toJson()).toList();
    }
    if (files != null) {
      data['files'] = files!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Children {
  int? id;
  String? name;
  int? parentId;

  Children({this.id, this.name, this.parentId});

  Children.fromJson(Map<String, dynamic> json) {
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

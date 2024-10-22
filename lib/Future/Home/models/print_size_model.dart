class PrintSizeModel {
  bool? status;
  List<PrintSizeData>? data;

  PrintSizeModel({this.status, this.data});

  PrintSizeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <PrintSizeData>[];
      json['data'].forEach((v) {
        data!.add(PrintSizeData.fromJson(v));
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

class PrintSizeData {
  int? id;
  String? name;
  int? width;
  int? height;

  PrintSizeData({
    this.id,
    this.name,
    this.width,
    this.height,
  });

  PrintSizeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['width'] = width;
    data['height'] = height;

    return data;
  }
}

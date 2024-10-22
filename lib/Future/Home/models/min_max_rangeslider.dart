class MinAndMaxRangeSliderModel {
  bool? status;
  double? min;
  double? max;

  MinAndMaxRangeSliderModel({this.status, this.min, this.max});

  MinAndMaxRangeSliderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    min = double.tryParse(json['min'].toString());
    max = double.tryParse(json['max'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['min'] = min;
    data['max'] = max;
    return data;
  }
}

class AboutUsModel {
  String? descrption;
  String? image;
  String? phoneNumber;
  String? shopName;
  String? companyName;

  AboutUsModel(
      {this.descrption,
      this.image,
      this.phoneNumber,
      this.shopName,
      this.companyName});

  AboutUsModel.fromJson(Map<String, dynamic> json) {
    descrption = json['descrption'];
    image = json['image'];
    phoneNumber = json['phone_number'];
    shopName = json['Shop_name'];
    companyName = json['Company_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['descrption'] = descrption;
    data['image'] = image;
    data['phone_number'] = phoneNumber;
    data['Shop_name'] = shopName;
    data['Company_name'] = companyName;
    return data;
  }
}

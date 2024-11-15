class User {
  bool? status;
  UserProfile? data;

  User({this.status, this.data});

  User.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? UserProfile.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserProfile {
  String? firstName;
  String? lastName;
  String? phone;
  String? address;
  int? gender;
  String? email;

  UserProfile(
      {this.firstName,
      this.lastName,
      this.phone,
      this.address,
      this.gender,
      this.email});

  UserProfile.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    address = json['address'];
    gender = json['gender'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['address'] = address;
    data['gender'] = gender;
    data['email'] = email;
    return data;
  }
}

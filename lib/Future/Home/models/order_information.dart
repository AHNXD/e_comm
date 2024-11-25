class OrderInformation {
  String? firstName;
  String? lastName;
  String? phone;
  String? address;
  String? country;
  String? city;
  String? note;
  String? code;
  
  OrderInformation({
    this.address,
    this.code,
    this.city,
    this.country,
    this.firstName,
    this.lastName,
    this.note,
    this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "phone": phone,
      "province": country,
      "region": city,
      "address": address,
      "notes": note,
      "code": code,
    };
  }
}

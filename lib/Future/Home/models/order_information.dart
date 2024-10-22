class OrderInformation {
  List<int>? productId;
  List<int>? quantity;
  List<String?>? selectedSizes;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? address;
  String? country;
  String? city;
  String? note;
  String? code;
  OrderInformation(
      {this.address,
      this.code,
      this.city,
      this.country,
      this.email,
      this.firstName,
      this.lastName,
      this.note,
      this.phone,
      this.productId,
      this.quantity,
      this.selectedSizes});

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "phone": phone,
      "email": email,
      "province": country,
      "region": city,
      "address": address,
      "notes": note,
      "code": code,
      "product_id": productId,
      "qty": quantity,
      "sizes": selectedSizes
    };
  }
}

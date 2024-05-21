
import 'dart:convert';

AddressRequest addressRequestFromJson(String str) => AddressRequest.fromJson(json.decode(str));

String addressRequestToJson(AddressRequest data) => json.encode(data.toJson());

class AddressRequest {
  String city;
  String district;
  String ward;
  String street;
  String fullName;
  String phone;

  AddressRequest({
    required this.city,
    required this.district,
    required this.ward,
    required this.street,
    required this.fullName,
    required this.phone,
  });

  factory AddressRequest.fromJson(Map<String, dynamic> json) => AddressRequest(
    city: json["city"],
    district: json["district"],
    ward: json["ward"],
    street: json["street"],
    fullName: json["fullName"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "city": city,
    "district": district,
    "ward": ward,
    "street": street,
    "fullName": fullName,
    "phone": phone,
  };
}

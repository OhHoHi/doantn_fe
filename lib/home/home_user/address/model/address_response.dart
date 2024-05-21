import 'dart:convert';

import 'package:doan_tn/auth/login/model/user_response.dart';

List<AddressResponse> addressResponseFromJson(String str) => List<AddressResponse>.from(json.decode(str).map((x) => AddressResponse.fromJson(x)));

String addressResponseToJson(List<AddressResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddressResponse {
  int id;
  String city;
  String district;
  String ward;
  String street;
  String? fullName;
  String phone;
  UserResponse user;

  AddressResponse({
    required this.id,
    required this.city,
    required this.district,
    required this.ward,
    required this.street,
    required this.fullName,
    required this.phone,
    required this.user,
  });

  factory AddressResponse.fromJson(Map<String, dynamic> json) => AddressResponse(
    id: json["id"],
    city: json["city"],
    district: json["district"],
    ward: json["ward"],
    street: json["street"],
    fullName: json["fullName"],
    phone: json["phone"],
    user: UserResponse.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "city": city,
    "district": district,
    "ward": ward,
    "street": street,
    "fullName": fullName,
    "phone": phone,
    "user": user.toJson(),
  };
}

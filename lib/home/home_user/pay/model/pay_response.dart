import 'dart:convert';

import 'package:doan_tn/auth/login/model/user_response.dart';
import 'package:doan_tn/home/home_user/address/model/address_response.dart';
import 'package:doan_tn/home/home_user/pay/model/order_item_response.dart';

List<PayResponse> payResponseFromJson(String str) => List<PayResponse>.from(json.decode(str).map((x) => PayResponse.fromJson(x)));

String payResponseToJson(List<PayResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PayResponse {
  int id;
  UserResponse user;
  List<OrderItemResponse> orderItems;
  AddressResponse address;
  DateTime orderDate;
  int status;
  double totalAmount;

  PayResponse({
    required this.id,
    required this.user,
    required this.orderItems,
    required this.address,
    required this.orderDate,
    required this.status,
    required this.totalAmount,
  });

  factory PayResponse.fromJson(Map<String, dynamic> json) => PayResponse(
    id: json["id"],
    user: UserResponse.fromJson(json["user"]),
    orderItems: List<OrderItemResponse>.from(json["orderItems"].map((x) => x)),
    address: AddressResponse.fromJson(json["address"]),
    orderDate: DateTime.parse(json["orderDate"]),
    status: json["status"],
    totalAmount: json["totalAmount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user.toJson(),
    "orderItems": List<dynamic>.from(orderItems.map((x) => x)),
    "address": address.toJson(),
    "orderDate": orderDate.toIso8601String(),
    "status": status,
    "totalAmount": totalAmount,
  };
}

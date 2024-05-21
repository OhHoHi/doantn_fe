import 'dart:convert';

import 'package:doan_tn/home/model/product_reponse.dart';

List<OrderItemResponse> orderItemResponseFromJson(String str) => List<OrderItemResponse>.from(json.decode(str).map((x) => OrderItemResponse.fromJson(x)));

String orderItemResponseToJson(List<OrderItemResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderItemResponse {
  int id;
  ProductResponse product;
  int quantity;

  OrderItemResponse({
    required this.id,
    required this.product,
    required this.quantity,
  });

  factory OrderItemResponse.fromJson(Map<String, dynamic> json) => OrderItemResponse(
    id: json["id"],
    product: ProductResponse.fromJson(json["product"]),
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product": product.toJson(),
    "quantity": quantity,
  };
}

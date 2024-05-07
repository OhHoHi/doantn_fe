import 'dart:convert';

CartRequest cartRequestFromJson(String str) => CartRequest.fromJson(json.decode(str));

String cartRequestToJson(CartRequest data) => json.encode(data.toJson());

class CartRequest {
  int userId;
  int productId;
  int quantity;

  CartRequest({
    required this.userId,
    required this.productId,
    required this.quantity,
  });

  factory CartRequest.fromJson(Map<String, dynamic> json) => CartRequest(
    userId: json["userId"],
    productId: json["productId"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "productId": productId,
    "quantity": quantity,
  };
}
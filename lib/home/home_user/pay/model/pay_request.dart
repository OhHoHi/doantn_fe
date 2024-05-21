import 'dart:convert';

PayRequest payRequestFromJson(String str) => PayRequest.fromJson(json.decode(str));

String payRequestToJson(PayRequest data) => json.encode(data.toJson());

class PayRequest {
  int userId;
  int status;
  int totalAmount;
  int addressId;
  List<OrderItem> orderItems;

  PayRequest({
    required this.userId,
    required this.status,
    required this.totalAmount,
    required this.addressId,
    required this.orderItems,
  });

  factory PayRequest.fromJson(Map<String, dynamic> json) => PayRequest(
    userId: json["userId"],
    status: json["status"],
    totalAmount: json["totalAmount"],
    addressId: json["addressId"],
    orderItems: List<OrderItem>.from(json["orderItems"].map((x) => OrderItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "status": status,
    "totalAmount": totalAmount,
    "addressId": addressId,
    "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
  };
}

class OrderItem {
  int productId;
  int quantity;

  OrderItem({
    required this.productId,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    productId: json["productId"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "quantity": quantity,
  };
}


import 'dart:convert';

List<ProductTop10Response> productTop10ResponseFromJson(String str) => List<ProductTop10Response>.from(json.decode(str).map((x) => ProductTop10Response.fromJson(x)));

String productTop10ResponseToJson(List<ProductTop10Response> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductTop10Response {
  int productId;
  String productName;
  double totalRevenue;

  ProductTop10Response({
    required this.productId,
    required this.productName,
    required this.totalRevenue,
  });

  factory ProductTop10Response.fromJson(Map<String, dynamic> json) => ProductTop10Response(
    productId: json["productId"],
    productName: json["productName"],
    totalRevenue: json["totalRevenue"],
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "productName": productName,
    "totalRevenue": totalRevenue,
  };
}
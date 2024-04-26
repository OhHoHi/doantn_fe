import 'dart:convert';

ProductAddResponse productAddResponseFromJson(String str) => ProductAddResponse.fromJson(json.decode(str));

String productAddResponseToJson(ProductAddResponse data) => json.encode(data.toJson());

class ProductAddResponse {
  String message;
  List<String> imageUrls;

  ProductAddResponse({
    required this.message,
    required this.imageUrls,
  });

  factory ProductAddResponse.fromJson(Map<String, dynamic> json) => ProductAddResponse(
    message: json["message"],
    imageUrls: List<String>.from(json["imageUrls"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "imageUrls": List<dynamic>.from(imageUrls.map((x) => x)),
  };
}
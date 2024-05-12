import 'dart:convert';

List<BrandResponse> brandResponseFromJson(String str) => List<BrandResponse>.from(json.decode(str).map((x) => BrandResponse.fromJson(x)));

String brandResponseToJson(List<BrandResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BrandResponse {
  int id;
  String name;
  dynamic description;

  BrandResponse({
    required this.id,
    required this.name,
    required this.description,
  });

  factory BrandResponse.fromJson(Map<String, dynamic> json) => BrandResponse(
    id: json["id"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
  };
}
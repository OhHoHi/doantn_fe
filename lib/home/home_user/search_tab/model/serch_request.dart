import 'dart:convert';

SearchRequest searchRequestFromJson(String str) => SearchRequest.fromJson(json.decode(str));

String searchRequestToJson(SearchRequest data) => json.encode(data.toJson());

class SearchRequest {
  int? brandId;
  String? sort;
  String? productName;
  double? minPrice;
  double? maxPrice;
  int? diemCanBang;
  int? page;
  int? size;

  SearchRequest({
    required this.brandId,
    required this.sort,
    required this.productName,
    required this.minPrice,
    required this.maxPrice,
    required this.diemCanBang,
    required this.page,
    required this.size,
  });

  factory SearchRequest.fromJson(Map<String, dynamic> json) => SearchRequest(
    brandId: json["brandId"],
    sort: json["sort"],
    productName: json["productName"],
    minPrice: json["minPrice"],
    maxPrice: json["maxPrice"],
    diemCanBang: json["diemCanBang"],
    page: json["page"],
    size: json["size"],
  );

  Map<String, dynamic> toJson() => {
    "brandId": brandId,
    "sort": sort,
    "productName": productName,
    "minPrice": minPrice,
    "maxPrice": maxPrice,
    "diemCanBang": diemCanBang,
    "page": page,
    "size": size,
  };
}

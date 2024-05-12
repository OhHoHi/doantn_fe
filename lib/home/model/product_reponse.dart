import 'dart:convert';

List<ProductResponse> productResponseFromJson(String str) => List<ProductResponse>.from(json.decode(str).map((x) => ProductResponse.fromJson(x)));

String productResponseToJson(List<ProductResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductResponse {
  int id;
  String name;
  List<String> imageUrls;
  int price;
  String status;
  String color;
  String chatLieuKhungVot;
  String chatLieuThanVot;
  String trongLuong;
  String doCung;
  int diemCanBang;
  String chieuDaiVot;
  String mucCangToiDa;
  String chuViCanCam;
  String trinhDoChoi;
  String noiDungChoi;
  String description;
  Brands brands;

  ProductResponse({
    required this.id,
    required this.name,
    required this.imageUrls,
    required this.price,
    required this.status,
    required this.color,
    required this.chatLieuKhungVot,
    required this.chatLieuThanVot,
    required this.trongLuong,
    required this.doCung,
    required this.diemCanBang,
    required this.chieuDaiVot,
    required this.mucCangToiDa,
    required this.chuViCanCam,
    required this.trinhDoChoi,
    required this.noiDungChoi,
    required this.description,
    required this.brands,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) => ProductResponse(
    id: json["id"],
    name: json["name"],
    imageUrls: List<String>.from(json["imageUrls"].map((x) => x)),
    price: json["price"],
    status: json["status"],
    color: json["color"],
    chatLieuKhungVot: json["chatLieuKhungVot"],
    chatLieuThanVot: json["chatLieuThanVot"],
    trongLuong: json["trongLuong"],
    doCung: json["doCung"],
    diemCanBang: json["diemCanBang"],
    chieuDaiVot: json["chieuDaiVot"],
    mucCangToiDa: json["mucCangToiDa"],
    chuViCanCam: json["chuViCanCam"],
    trinhDoChoi: json["trinhDoChoi"],
    noiDungChoi: json["noiDungChoi"],
    description: json["description"],
    brands: Brands.fromJson(json["brands"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "imageUrls": List<dynamic>.from(imageUrls.map((x) => x)),
    "price": price,
    "status": status,
    "color": color,
    "chatLieuKhungVot": chatLieuKhungVot,
    "chatLieuThanVot": chatLieuThanVot,
    "trongLuong": trongLuong,
    "doCung": doCung,
    "diemCanBang": diemCanBang,
    "chieuDaiVot": chieuDaiVot,
    "mucCangToiDa": mucCangToiDa,
    "chuViCanCam": chuViCanCam,
    "trinhDoChoi": trinhDoChoi,
    "noiDungChoi": noiDungChoi,
    "description": description,
    "brands": brands.toJson(),
  };
}

class Brands {
  int id;
  String name;
  dynamic description;

  Brands({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Brands.fromJson(Map<String, dynamic> json) => Brands(
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

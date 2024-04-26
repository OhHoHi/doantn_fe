import 'dart:convert';

ProductEditRequest productEditRequestFromJson(String str) => ProductEditRequest.fromJson(json.decode(str));

String productEditRequestToJson(ProductEditRequest data) => json.encode(data.toJson());

class ProductEditRequest {
  String name;
  int price;
  String status;
  String color;
  String chatLieuKhungVot;
  String chatLieuThanVot;
  String trongLuong;
  String doCung;
  String diemCanBang;
  String chieuDaiVot;
  String mucCangToiDa;
  String chuViCanCam;
  String trinhDoChoi;
  String noiDungChoi;
  String description;
  String brandsName;

  ProductEditRequest({
    required this.name,
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
    required this.brandsName,
  });

  factory ProductEditRequest.fromJson(Map<String, dynamic> json) => ProductEditRequest(
    name: json["name"],
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
    brandsName: json["brandsName"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
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
    "brandsName": brandsName,
  };
}
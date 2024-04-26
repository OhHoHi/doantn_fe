import 'dart:typed_data';

class ProductRequest {
  final String name;
  final String description;
  final List<Uint8List> images;
  final int price;
  final String brandsName;
  final String status;
  final String color;
  final String chatLieuKhungVot;
  final String chatLieuThanVot;
  final String trongLuong;
  final String doCung;
  final String diemCanBang;
  final String chieuDaiVot;
  final String mucCangToiDa;
  final String chuViCanCam;
  final String trinhDoChoi;
  final String noiDungChoi;

  ProductRequest({
    required this.name,
    required this.description,
    required this.images,
    required this.price,
    required this.brandsName,
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
  });

  Map<String, dynamic> toJson() {
    // Chuyển đổi các đối tượng Uint8List thành List<int> trước khi chuyển đổi sang JSON
    List<List<int>> imageBytesList = images.map((image) => image.toList()).toList();

    return {
      'name': name,
      'description': description,
      'images': imageBytesList,
      'price': price,
      'brandsName': brandsName,
      'status': status,
      'color': color,
      'chatLieuKhungVot': chatLieuKhungVot,
      'chatLieuThanVot': chatLieuThanVot,
      'trongLuong': trongLuong,
      'doCung': doCung,
      'diemCanBang': diemCanBang,
      'chieuDaiVot': chieuDaiVot,
      'mucCangToiDa': mucCangToiDa,
      'chuViCanCam': chuViCanCam,
      'trinhDoChoi': trinhDoChoi,
      'noiDungChoi': noiDungChoi,
    };
  }
}

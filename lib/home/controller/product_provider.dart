import 'dart:ffi';
import 'dart:typed_data';
import 'dart:io';
import 'package:doan_tn/home/model/product_add_response.dart';
import 'package:doan_tn/home/model/product_reponse.dart';
import 'package:doan_tn/home/model/product_request.dart';
import 'package:doan_tn/home/service/product_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../base/controler/base_provider.dart';
import '../../base/services/dio_option.dart';

class ProductProvider extends BaseProvider<ProductService> {
  ProductProvider(ProductService service) : super(service);
  Status statusAddProduct = Status.none;
  late List<ProductResponse> listProduct;

  // late Map<String, Uint8List?> images = {};
  late ProductAddResponse productAddResponse;
  late Map<String, List<Uint8List>> images = {};

  Future<void> getListProduct() async {
    resetStatus();
    try {
      // startLoading((){
      //   statusInfo = Status.loading;
      // });
      startLoading();
      listProduct = await service.getListProduct();
      for (var product in listProduct) {
        //await getImage(product.imageUrls.first); // Lấy ảnh cho sản phẩm đầu tiên trong danh sách ảnh
        await getImagesForProduct(product);
      }
      // finishLoading((){
      //   statusInfo = Status.loaded;
      // });
      finishLoading();
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      // receivedError((){
      //   statusInfo = Status.error;
      // });
      receivedError();
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return DialogBase(title:"Thất bại", icon: AppAssets.iconFail,content: "Có lỗi hệ thống",);
      //   },
      // );
    }
  }

  Future<void> getImagesForProduct(ProductResponse product) async {
    List<Uint8List> productImages = [];
    for (var imageUrl in product.imageUrls) {
      final image = await service.getImageFromApi(imageUrl);
      productImages.add(image!);
    }
    images[product.id.toString()] = productImages;
  }

  Future<void> addProduct(
    String name,
    String description,
    List<File> images,
    int price,
    String brandsName,
    String status,
    String color,
    String chatLieuKhungVot,
    String chatLieuThanVot,
    String trongLuong,
    String doCung,
    String diemCanBang,
    String chieuDaiVot,
    String mucCangToiDa,
    String chuViCanCam,
    String trinhDoChoi,
    String noiDungChoi,
  ) async {
    resetStatus();
    try {
      startLoading(() {
        statusAddProduct = Status.loading;
      });
      // startLoading();
      List<Uint8List> imageBytesList = [];
      for (var file in images) {
        Uint8List bytes = await file.readAsBytes();
        imageBytesList.add(bytes);
      }
      productAddResponse = await service.addProduct(
          ProductRequest(
              name: name,
              description: description,
              images: imageBytesList,
              price: price,
              brandsName: brandsName,
              status: status,
              color: color,
              chatLieuKhungVot: chatLieuKhungVot,
              chatLieuThanVot: chatLieuThanVot,
              trongLuong: trongLuong,
              doCung: doCung,
              diemCanBang: diemCanBang,
              chieuDaiVot: chieuDaiVot,
              mucCangToiDa: mucCangToiDa,
              chuViCanCam: chuViCanCam,
              trinhDoChoi: trinhDoChoi,
              noiDungChoi: noiDungChoi),
          images);
      // message = response;
      finishLoading(() {
        statusAddProduct = Status.loaded;
      });

      receivedError(() {
        statusAddProduct = Status.error;
      });
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusAddProduct = Status.error;
      });
    }
  }
}

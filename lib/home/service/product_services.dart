import 'dart:typed_data';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:doan_tn/home/model/product_add_response.dart';
import 'package:doan_tn/home/model/product_reponse.dart';
import '../../base/services/base_service.dart';
import '../../base/services/services_url.dart';
import '../model/product_request.dart';

class ProductService extends BaseService {
  ProductService(Dio client) : super(client);

  // Future<ProductResponse> getListProduct() async {
  //   // final result = await client
  //   //     .fetch<Map<String, dynamic>>(setStreamType<ProductResponse>(Options(
  //   //   method: 'GET',
  //   // ).compose(client.options, ServicesUrl.listProduct)));
  //   // final result = await client.get<Map<String, dynamic>>(
  //   //   ServicesUrl.listProduct,
  //   //   options: Options(method: 'GET'),
  //   // );
  //   Response result = await Dio().get(ServicesUrl.listProduct);
  //   return ProductResponse.fromJson(result.data!);
  // }

  Future<List<ProductResponse>> getListProduct() async {
      Response response = await Dio().get(ServicesUrl.listProduct);

      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data;

        List<ProductResponse> productList = responseData.map((json) {
          return ProductResponse.fromJson(json);
        }).toList();
        return productList;
      } else {
        throw Exception('Failed to load product data');
      }
  }

  Future<Uint8List?> getImageFromApi(String nameImgae) async {
    Response<Uint8List> results = await client.get<Uint8List>(
        "http://10.0.2.2:8080/products/images/$nameImgae",
        options: Options(responseType: ResponseType.bytes));
    return results.data;
  }

  Future<ProductAddResponse> addProduct(ProductRequest request ,List<File> images) async {

    List<MultipartFile> imageFiles = [];

    // Chuyển đổi danh sách ảnh từ File sang MultipartFile
    for (var image in images) {
      imageFiles.add(
        await MultipartFile.fromFile(image.path),
      );
    }

    FormData formData = FormData.fromMap({
      'name': request.name,
      'description': request.description,
      'images': imageFiles,
      'price': request.price,
      'brandsName': request.brandsName,
      'status': request.status,
      'color': request.color,
      'chatLieuKhungVot': request.chatLieuKhungVot,
      'chatLieuThanVot': request.chatLieuThanVot,
      'trongLuong': request.trongLuong,
      'doCung': request.doCung,
      'diemCanBang': request.diemCanBang,
      'chieuDaiVot': request.chieuDaiVot,
      'mucCangToiDa': request.mucCangToiDa,
      'chuViCanCam': request.chuViCanCam,
      'trinhDoChoi': request.trinhDoChoi,
      'noiDungChoi': request.noiDungChoi,
    });
    final result = await Dio().post(
      ServicesUrl.addProduct,
      data: formData,
    );
    return ProductAddResponse.fromJson(result.data!);
  }

}
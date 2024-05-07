import 'dart:ffi';
import 'dart:typed_data';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:doan_tn/home/home_admin/view/profile_tab.dart';
import 'package:doan_tn/home/model/car_request.dart';
import 'package:doan_tn/home/model/cart_response.dart';
import 'package:doan_tn/home/model/product_add_response.dart';
import 'package:doan_tn/home/model/product_edit_request.dart';
import 'package:doan_tn/home/model/product_reponse.dart';
import '../../base/services/base_service.dart';
import '../../base/services/services_url.dart';
import '../model/product_add_request.dart';

class ProductService extends BaseService {
  ProductService(Dio client) : super(client);

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

  Future<bool> addProduct(ProductRequest request ,List<File> images) async {
    try{
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
        await client.post(
        ServicesUrl.addProduct,
        data: formData
      );
      return true;
    }catch (e) {
      // Xử lý ngoại lệ ở đây, nếu cần
      return false;
    }
  }
  Future<bool> editProduct(ProductEditRequest request ,int id) async {
    try{
       await client.put(
        "http://10.0.2.2:8080/products/edit/$id",
        data: {
          'name': request.name,
          'description': request.description,
          'price': request.price,
          'brandsName' : request.brandsName,
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
        },
      );
      return true;
    }catch (e) {
      // Xử lý ngoại lệ ở đây, nếu cần
      return false;
    }
  }
  Future<bool> deleteProduct(int id) async {
    try{
      await client.delete(
        "http://10.0.2.2:8080/products/delete/$id",
      );
      return true;
    }catch (e) {
      // Xử lý ngoại lệ ở đây, nếu cần
      return false;
    }
  }

  Future<List<CartResponse>> getListCart(int userId) async {
    Response response = await Dio().get("http://10.0.2.2:8080/api/cart/items/$userId");

    if (response.statusCode == 200) {
      List<dynamic> responseData = response.data;

      List<CartResponse> cartList = responseData.map((json) {
        return CartResponse.fromJson(json);
      }).toList();
      return cartList;
    } else {
      throw Exception('Failed to load product data');
    }
  }

  Future<bool> addCart(CartRequest request) async {
    try{
      await client.post(
          ServicesUrl.addCart,
          data: {
            "userId" : request.userId,
            "productId" : request.productId,
            "quantity" : request.quantity
          }
      );
      return true;
    }catch (e) {
      // Xử lý ngoại lệ ở đây, nếu cần
      return false;
    }
  }
  Future<bool> deleteCart(int id) async {
    try{
      await client.delete(
        "http://10.0.2.2:8080/api/cart/items/$id",
      );
      return true;
    }catch (e) {
      // Xử lý ngoại lệ ở đây, nếu cần
      return false;
    }
  }
  Future<bool> increaseQuantity(int cartItemId) async {
    try{
      await client.put(
        "http://10.0.2.2:8080/api/cart/$cartItemId/increaseQuantity",
      );
      return true;
    }catch (e) {
      // Xử lý ngoại lệ ở đây, nếu cần
      return false;
    }
  }
  Future<bool> decreaseQuantity(int cartItemId) async {
    try{
      await client.put(
        "http://10.0.2.2:8080/api/cart/$cartItemId/decreaseQuantity",
      );
      return true;
    }catch (e) {
      // Xử lý ngoại lệ ở đây, nếu cần
      return false;
    }
  }

}
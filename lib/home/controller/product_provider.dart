import 'dart:ffi';
import 'dart:typed_data';
import 'dart:io';
import 'package:doan_tn/home/model/car_request.dart';
import 'package:doan_tn/home/model/cart_response.dart';
import 'package:doan_tn/home/model/product_add_response.dart';
import 'package:doan_tn/home/model/product_reponse.dart';
import 'package:doan_tn/home/model/product_add_request.dart';
import 'package:doan_tn/home/service/product_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../base/controler/base_provider.dart';
import '../../base/services/dio_option.dart';
import '../home_user/search_tab/model/serch_request.dart';
import '../model/brand_response.dart';
import '../model/product_edit_request.dart';

class ProductProvider extends BaseProvider<ProductService> {
  ProductProvider(ProductService service) : super(service);
  Status statusListProduct = Status.none;
  Status statusAddProduct = Status.none;
  Status statusEditProduct = Status.none;
  Status statusDeleteProduct = Status.none;

  Status statusListCart = Status.none;
  Status statusAddCart = Status.none;
  Status statusDeleteCart = Status.none;
  Status statusQuantity = Status.none;






  List<ProductResponse> listProduct = [];
  List<ProductResponse> listProductDisplay = [];

  List<CartResponse> listCart = [];
  bool? checkAdd;
  bool? checkEdit;
  bool? checkDelete;
  bool? checkAddCart;
  bool? checkDeleteCart;
  bool? checkIncreaseQuantity;
  bool? checkDecreaseQuantity;

  late ProductResponse productResponse;


  late ProductAddResponse productAddResponse;
  late Map<String, List<Uint8List>> images = {};


  late int page = 0;
  late String sort = "id_desc";
  late bool canLoadMore;
  bool refresh = false;

  void resetPage() {
    page = 0;
    canLoadMore = true;
    listProductDisplay = [];
  }

  void loadMore() {
    if (canLoadMore) {
      page += 1;
      getListProduct();
    }
  }


  Future<void> getListProduct() async {
    resetStatus();
    try {
      startLoading((){
        statusListProduct = Status.loading;
      });
      //startLoading();
      listProduct = await service.getListProduct(sort , page , 10);
      for (var product in listProduct) {
        //await getImage(product.imageUrls.first); // Lấy ảnh cho sản phẩm đầu tiên trong danh sách ảnh
        await getFirstImageForProduct(product);
      }
      if (refresh == true) {
        listProductDisplay = listProduct;
        refresh=false;
      } else {
        listProductDisplay += listProduct;
      }
      if (listProduct.length <10) {
        canLoadMore = false;
      }
      finishLoading((){
        statusListProduct = Status.loaded;
      });
     // finishLoading();
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError((){
        statusListProduct = Status.error;
      });
      //receivedError();
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return DialogBase(title:"Thất bại", icon: AppAssets.iconFail,content: "Có lỗi hệ thống",);
      //   },
      // );
    }
  }
// Phương thức để lấy ảnh đầu tiên cho mỗi sản phẩm
  Future<void> getFirstImageForProduct(ProductResponse product) async {
    try{
      startLoading((){
        statusListProduct = Status.loading;
      });
      final image = await service.getImageFromApi(product.imageUrls.first);
      images[product.id.toString()] = [image!]; // Lưu ảnh đầu tiên vào danh sách ảnh của sản phẩm
      finishLoading((){
        statusListProduct = Status.loaded;
      });
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError((){
        statusListProduct = Status.error;
      });
      //receivedError();
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return DialogBase(title:"Thất bại", icon: AppAssets.iconFail,content: "Có lỗi hệ thống",);
      //   },
      // );
    }
  }

  Future<void> getImagesForProduct(ProductResponse product) async {

    try{
      startLoading((){
        statusListProduct = Status.loading;
      });
      List<Uint8List> productImages = [];
      for (var imageUrl in product.imageUrls) {
        final image = await service.getImageFromApi(imageUrl);
        productImages.add(image!);
      }
      images[product.id.toString()] = productImages;
      finishLoading((){
        statusListProduct = Status.loaded;
      });
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError((){
        statusListProduct = Status.error;
      });
      //receivedError();
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return DialogBase(title:"Thất bại", icon: AppAssets.iconFail,content: "Có lỗi hệ thống",);
      //   },
      // );
    }
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
      checkAdd = await service.addProduct(
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

        // finishLoading(() {
        //   statusAddProduct = Status.loaded;
        // });
        //
        // receivedError(() {
        //   statusAddProduct = Status.error;
        // });

      if(checkAdd == true){
        finishLoading(() {
          statusAddProduct = Status.loaded;
        });
      }
      else{
        receivedError(() {
          statusAddProduct = Status.error;
        });
      }
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusAddProduct = Status.error;
      });
    }
  }

  Future<void> editProduct(
      String name,
      String description,
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
      int id
      ) async {
    resetStatus();
    try {
      startLoading(() {
        statusEditProduct = Status.loading;
      });
      // startLoading();
      checkEdit = await service.editProduct(
          ProductEditRequest(
              name: name,
              description: description,
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
              noiDungChoi: noiDungChoi) , id);
      // message = response;

      // finishLoading(() {
      //   statusEditProduct = Status.loaded;
      // });
      //
      // receivedError(() {
      //   statusEditProduct = Status.error;
      // });

      if(checkEdit == true){
        finishLoading(() {
          statusEditProduct = Status.loaded;
        });
      }
      else{
        receivedError(() {
          statusEditProduct = Status.error;
        });
      }
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusEditProduct = Status.error;
      });
    }
  }
  Future<void> deleteProduct(int id)async {
    resetStatus();
    try {
      startLoading((){
        statusDeleteProduct = Status.loading;
      });
     // startLoading();
      checkDelete = await service.deleteProduct(id);
      if(checkDelete == true){
        finishLoading(() {
          statusDeleteProduct = Status.loaded;
        });
      }
      else{
        receivedError(() {
          statusDeleteProduct = Status.error;
        });
      }
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError((){
        statusDeleteProduct = Status.error;
      });
     // receivedError();
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return DialogBase(title:"Thất bại", icon: AppAssets.iconFail,content: "Có lỗi hệ thống",);
      //   },
      // );
    }
  }

  // chức năng của người dùng
  Future<void> getImagesForCartProducts(List<CartResponse> cartItems) async {
    try {
      startLoading((){
        statusListCart = Status.loading;
      });
      for (var cartItem in cartItems) {
        await getFirstImageForProduct(cartItem.product);
      }
      finishLoading((){
        statusListCart = Status.loaded;
      });
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError((){
        statusListCart = Status.error;
      });
    }
  }
  // Phương thức để tính toán tổng giá từ danh sách sản phẩm
  double _calculateTotalAmount() {
    double total = 0;
    for (CartResponse cartResponse in listCart) {
      total += cartResponse.product.price * cartResponse.quantity;
    }
    return total;
  }
  double totalAmount = 0;
  Future<void> getListCart(int userId) async {
    resetStatus();
    try {
      startLoading((){
        statusListCart = Status.loading;
      });
     // startLoading();
      listCart = await service.getListCart(userId);
      totalAmount = _calculateTotalAmount(); // Tính toán tổng giá sau khi danh sách sản phẩm đã được cập nhật
      await getImagesForCartProducts(listCart);
      finishLoading((){
        statusListCart = Status.loaded;
      });
      //finishLoading();
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError((){
        statusListCart = Status.error;
      });
      //receivedError();
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return DialogBase(title:"Thất bại", icon: AppAssets.iconFail,content: "Có lỗi hệ thống",);
      //   },
      // );
    }
  }
  Future<void> addCart(int userId , int productId , int quantity ) async {
    resetStatus();
    try {
      startLoading(() {
        statusAddCart = Status.loading;
      });
      checkAddCart = await service.addCart(CartRequest(userId: userId, productId: productId, quantity: quantity));
      // startLoading();
      // message = response;

      // finishLoading(() {
      //   statusAddProduct = Status.loaded;
      // });
      //
      // receivedError(() {
      //   statusAddProduct = Status.error;
      // });

      if(checkAddCart == true){
        finishLoading(() {
          statusAddCart = Status.loaded;
        });
      }
      else{
        receivedError(() {
          statusAddCart = Status.error;
        });
      }
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusAddCart = Status.error;
      });
    }
  }
  Future<void> deleteCart(int id)async {
    resetStatus();
    try {
      startLoading((){
        statusDeleteCart = Status.loading;
      });
      // startLoading();
      checkDeleteCart = await service.deleteCart(id);
      if(checkDelete == true){
        finishLoading(() {
          statusDeleteCart = Status.loaded;
        });
      }
      else{
        receivedError(() {
          statusDeleteCart = Status.error;
        });
      }
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError((){
        statusDeleteCart = Status.error;
      });
      // receivedError();
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return DialogBase(title:"Thất bại", icon: AppAssets.iconFail,content: "Có lỗi hệ thống",);
      //   },
      // );
    }
  }
  Future<void> increaseQuantity(int cartItemId , int id)async {
    resetStatus();
    try {
      startLoading((){
        statusQuantity = Status.loading;
      });
      // startLoading();
      checkIncreaseQuantity = await service.increaseQuantity(cartItemId);
      if(checkIncreaseQuantity == true){
        getListCart(id);
        finishLoading(() {
          statusQuantity = Status.loaded;
        });
      }
      else{
        receivedError(() {
          statusQuantity = Status.error;
        });
      }
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError((){
        statusQuantity = Status.error;
      });
      // receivedError();
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return DialogBase(title:"Thất bại", icon: AppAssets.iconFail,content: "Có lỗi hệ thống",);
      //   },
      // );
    }
  }

  Future<void> decreaseQuantity(int cartItemId , int id)async {
    resetStatus();
    try {
      startLoading((){
        statusQuantity = Status.loading;
      });
      // startLoading();
      checkDecreaseQuantity = await service.decreaseQuantity(cartItemId);
      if(checkDecreaseQuantity == true){
        getListCart(id);
        finishLoading(() {
          statusQuantity = Status.loaded;
        });
      }
      else{
        receivedError(() {
          statusQuantity = Status.error;
        });
      }
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError((){
        statusQuantity = Status.error;
      });
      // receivedError();
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return DialogBase(title:"Thất bại", icon: AppAssets.iconFail,content: "Có lỗi hệ thống",);
      //   },
      // );
    }
  }


  //tìm kiếm
  Status statusListSearch = Status.none;
  late List<ProductResponse> listSearch = [] ;
  late List<ProductResponse> listSearchDisplay = [] ;


  int? brandId ;
  String? sortSearch;
  String? productName;
  double? minPrice ;
  double? maxPrice ;
  int? diemCanBang;
  int pageSearch = 0;

  BrandResponse? selectedBrand;
  String? selectedLoaivot = "Tất cả";

  late bool canLoadMoreSearch;
  bool refreshSearch = false;

  void resetPageSearch() {
    pageSearch = 0;
    canLoadMoreSearch = true;
    listSearchDisplay = [];
  }

  void loadMoreSearch() {
    if (canLoadMoreSearch) {
      pageSearch += 1;
      getListSearch();
    }
  }

  void search(String nameSearch) {
    productName = nameSearch;
    getListSearch();
  }

  void refreshAllSearch() {
    selectedBrand = null;
    selectedLoaivot = "Tất cả";
    minPrice =  null;
    maxPrice = null;
  }
  Future<void> getListSearch() async {
    resetStatus();
    try {
      startLoading(() {
        statusListSearch = Status.loading;
      });
      listSearch = await service.getListSearch(
          SearchRequest(
              brandId: selectedBrand?.id,
              page: pageSearch,
              size: 10,
              sort: sortSearch,
              productName: productName,
              minPrice: minPrice,
              maxPrice: maxPrice,
              diemCanBang:
              selectedLoaivot == 'Nhẹ đầu'
                  ? 285
                  : selectedLoaivot == 'Cân bằng'
                  ? 294
                  : selectedLoaivot == 'Nặng đầu'
                  ? 296
                  : null
          )
      );
      for (var product in listSearch) {
        await getFirstImageForProduct(product);
      }
      if (refreshSearch == true) {
        listSearchDisplay = listSearch;
        refreshSearch = false;
      } else {
        listSearchDisplay += listSearch;
      }
      if (listSearch.length < 10) {
        canLoadMoreSearch = false;
      }
      finishLoading(() {
        statusListSearch = Status.loaded;
      });
      if(listSearch.isEmpty){
        receivedNoData(() {
          statusListSearch = Status.noData;
        });
      }
      else{
        finishLoading(() {
          statusListSearch = Status.loaded;
        });
      }

    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusListSearch = Status.error;
      });
    }
  }

}

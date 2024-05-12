import 'dart:ffi';
import 'dart:typed_data';
import 'dart:io';
import 'package:doan_tn/home/model/brand_response.dart';
import 'package:doan_tn/home/model/car_request.dart';
import 'package:doan_tn/home/model/cart_response.dart';
import 'package:doan_tn/home/model/product_add_response.dart';
import 'package:doan_tn/home/model/product_reponse.dart';
import 'package:doan_tn/home/model/product_add_request.dart';
import 'package:doan_tn/home/service/brand_service.dart';
import 'package:doan_tn/home/service/product_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../base/controler/base_provider.dart';
import '../../base/services/dio_option.dart';
import '../model/product_edit_request.dart';

class BrandProvider extends BaseProvider<BrandService> {
  BrandProvider(BrandService service) : super(service);
  Status statusListBrand = Status.none;
  List<BrandResponse> listBrand = [];


  Future<void> getListBrand() async {
    resetStatus();
    try {
      startLoading((){
        statusListBrand = Status.loading;
      });
      //startLoading();
      listBrand = await service.getListBrand();
      finishLoading((){
        statusListBrand = Status.loaded;
      });
      // finishLoading();
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError((){
        statusListBrand = Status.error;
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

}

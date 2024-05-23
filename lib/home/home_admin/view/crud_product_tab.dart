import 'package:doan_tn/base/widget/SkeletonTab.dart';
import 'package:doan_tn/base/widget/appbar_widget.dart';
import 'package:doan_tn/home/controller/brand_controller.dart';
import 'package:doan_tn/home/controller/product_provider.dart';
import 'package:doan_tn/home/home_admin/view/widget/body_add_product_screen.dart';
import 'package:doan_tn/home/model/product_reponse.dart';
import 'package:doan_tn/home/service/brand_service.dart';
import 'package:doan_tn/home/service/product_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../base/services/dio_option.dart';

class CrudProductScreen extends StatelessWidget {
  CrudProductScreen({Key? key ,  this.productResponse}) : super(key: key);
  ProductResponse? productResponse;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context)=>ProductProvider(ProductService(DioOption().createDio())),
        ),
        ChangeNotifierProvider(
          create: (context)=>BrandProvider(BrandService(DioOption().createDio())),
        ),
      ],
      child: SkeletonTab(

        title: productResponse != null ? 'Chỉnh sửa sản phẩm' : 'Thêm sản phẩm mới',
        bodyWidgets: BodyAddProduct(productResponse:productResponse),
        isBack:true
      ),
    );
  }
}

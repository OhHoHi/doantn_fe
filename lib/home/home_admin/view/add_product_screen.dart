import 'package:doan_tn/base/widget/SkeletonTab.dart';
import 'package:doan_tn/base/widget/appbar_widget.dart';
import 'package:doan_tn/home/controller/product_provider.dart';
import 'package:doan_tn/home/home_admin/view/widget/body_add_product_screen.dart';
import 'package:doan_tn/home/home_admin/view/widget/body_admin_product_tab.dart';
import 'package:doan_tn/home/home_admin/view/widget/product_crud.dart';
import 'package:doan_tn/home/model/product_reponse.dart';
import 'package:doan_tn/home/service/product_services.dart';
import 'package:doan_tn/values/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../base/services/dio_option.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({Key? key ,  this.productResponse}) : super(key: key);
  ProductResponse? productResponse;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context)=>ProductProvider(ProductService(DioOption().createDio())),
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

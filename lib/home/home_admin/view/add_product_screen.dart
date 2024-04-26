import 'package:doan_tn/base/widget/appbar_widget.dart';
import 'package:doan_tn/home/controller/product_provider.dart';
import 'package:doan_tn/home/home_admin/view/widget/body_add_product_screen.dart';
import 'package:doan_tn/home/home_admin/view/widget/body_admin_product_tab.dart';
import 'package:doan_tn/home/service/product_services.dart';
import 'package:doan_tn/values/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../base/services/dio_option.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context)=>ProductProvider(ProductService(DioOption().createDio())),
        ),
      ],
      child: AppBarWidget(
        tittle: Text(
          'Add Product',
          style: AppStyles.h5,
        ),
        haveBackButton: true,
        child: BodyAddProduct(),


      ),
    );
  }
}

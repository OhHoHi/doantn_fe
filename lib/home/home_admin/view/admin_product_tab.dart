
import 'package:doan_tn/base/widget/SkeletonTab.dart';
import 'package:doan_tn/base/widget/appbar_widget.dart';
import 'package:doan_tn/home/controller/product_provider.dart';
import 'package:doan_tn/home/home_admin/view/widget/body_admin_product_tab.dart';
import 'package:doan_tn/home/service/product_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../base/services/dio_option.dart';
import 'crud_product_tab.dart';

class AdminProductTab extends StatelessWidget {
  const AdminProductTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context)=>ProductProvider(ProductService(DioOption().createDio())),
        ),
      ],
      child: SkeletonTab(
        title: 'Trang chủ admin',
        bodyWidgets: const BodyAdminProductTab(),
        floatingButton: FloatingActionButton(onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CrudProductScreen(),
            ),
          );
          //_navigatorToProductCrudPage(context);
        },
          child:const Icon(
            Icons.add,
            size: 25,
          ),
        ),
        // floatingButton: FloatingActionButton(
        //   onPressed: () => _navigateToAddProduct(context),
        //   child: const Icon(
        //     Icons.add,
        //     size: 25,
        //   ),
        // ),
        isBack: false,
      ),
    );
  }
}

import 'package:doan_tn/auth/login/controller/login_provider.dart';
import 'package:doan_tn/home/home_user/view/widget/body_user_product_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/login/services/login_services.dart';
import '../../../base/services/dio_option.dart';
import '../../../base/widget/SkeletonTab.dart';
import '../../controller/product_provider.dart';
import '../../service/product_services.dart';


class UserProductTab extends StatelessWidget {
  const UserProductTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context)=>ProductProvider(ProductService(DioOption().createDio())),
        ),
      ],
      child:  SkeletonTab(
         title: 'Trang chủ user',
        // title: loginProvider.user!.token ?? '',
        bodyWidgets: BodyUserProductTab(),
        isBack: false,
      ),
    );
  }
}

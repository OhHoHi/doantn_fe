import 'package:doan_tn/home/home_user/view/widget/body_user_cart_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../../base/services/dio_option.dart';
import '../../../base/widget/SkeletonTab.dart';
import '../../controller/product_provider.dart';
import '../../service/product_services.dart';

class UserCartTab extends StatelessWidget {
  const UserCartTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context)=>ProductProvider(ProductService(DioOption().createDio())),
        ),
      ],
      child:  BodyUserCartTab(),
      // const SkeletonTab(
      //   title: 'Trang chủ user',
      //   // title: loginProvider.user!.token ?? '',
      //   bodyWidgets: BodyUserCartTab(),
      //   isBack: false,
      //   bottomSheetWidgets: BottomSheetCart(),
      // ),
    );
  }
}
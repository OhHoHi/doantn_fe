import 'package:doan_tn/base/widget/SkeletonTab.dart';
import 'package:doan_tn/home/home_user/pay/view/widget/body_order_pay.dart';
import 'package:doan_tn/home/home_user/view/widget/body_user_pay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../base/services/dio_option.dart';
import '../../../controller/product_provider.dart';
import '../../../service/product_services.dart';
import '../controller/pay_controller.dart';
import '../servicer/pay_service.dart';



class OrderPayScreen extends StatelessWidget {
  OrderPayScreen({Key? key, required this.isAdmin , required this.initialTabIndex}) : super(key: key);
  bool isAdmin;
  final int initialTabIndex;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context)=>ProductProvider(ProductService(DioOption().createDio())),
        ),
        // ChangeNotifierProvider(
        //   create: (context)=>AddressProvider(AddressService(DioOption().createDio())),
        // ),
        ChangeNotifierProvider(
          create: (context)=>PaymentProvider(PayService(DioOption().createDio())),
        ),
      ],
      child:SkeletonTab(title: "Đơn hàng của bạn",
          bodyWidgets: BodyOrderPay(isAdmin: isAdmin,initialTabIndex: initialTabIndex),
          isBack: true)
    );
  }
}



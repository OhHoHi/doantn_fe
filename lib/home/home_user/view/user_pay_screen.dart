import 'package:doan_tn/home/home_user/view/widget/body_user_pay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../base/services/dio_option.dart';
import '../../../base/widget/SkeletonTab.dart';
import '../../controller/product_provider.dart';
import '../../model/cart_response.dart';
import '../../service/product_services.dart';
import '../address/controller/address_provider.dart';
import '../address/service/address_service.dart';
import '../pay/controller/pay_controller.dart';
import '../pay/servicer/pay_service.dart';


class UserPayScreen extends StatelessWidget {
  const UserPayScreen({Key? key, required this.productPayList, required this.productProvider}) : super(key: key);
  final ProductProvider productProvider;
  final List<CartResponse> productPayList;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context)=>ProductProvider(ProductService(DioOption().createDio())),
        ),
        ChangeNotifierProvider(
          create: (context)=>AddressProvider(AddressService(DioOption().createDio())),
        ),
        ChangeNotifierProvider(
          create: (context)=>PaymentProvider(PayService(DioOption().createDio())),
        ),
      ],
      child: BodyUserPay(productProvider: productProvider , productPayList: productPayList),
      );
  }
}



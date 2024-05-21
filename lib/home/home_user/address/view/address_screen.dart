import 'package:doan_tn/home/controller/product_provider.dart';
import 'package:doan_tn/home/home_user/address/view/widget/body_address.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../base/services/dio_option.dart';
import '../../../../base/widget/SkeletonTab.dart';
import '../../../model/cart_response.dart';
import '../controller/address_provider.dart';
import '../service/address_service.dart';



class AddressScreen extends StatelessWidget {
  const AddressScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context)=>AddressProvider(AddressService(DioOption().createDio())),
        ),
      ],
      child:  SkeletonTab(
        title: 'Địa chỉ',
        // title: loginProvider.user!.token ?? '',
        bodyWidgets: BodyAddress(),
        isBack: true,
        isAddress: false,
      ),
    );
  }
}



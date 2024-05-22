import 'package:doan_tn/home/home_user/address/model/address_response.dart';
import 'package:doan_tn/home/home_user/address/view/widget/body_address.dart';
import 'package:doan_tn/home/home_user/address/view/widget/body_crud_address.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../base/services/dio_option.dart';
import '../../../../base/widget/SkeletonTab.dart';
import '../controller/address_provider.dart';
import '../service/address_service.dart';



class AddressCRUDScreen extends StatelessWidget {
  AddressCRUDScreen({Key? key , this.addressResponse}) : super(key: key);
  AddressResponse? addressResponse;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context)=>AddressProvider(AddressService(DioOption().createDio())),
        ),
      ],
      child:  SkeletonTab(
        title: addressResponse != null ? 'Chỉnh sửa địa chỉ' : 'Thêm mới địa chỉ',
        // title: loginProvider.user!.token ?? '',
        bodyWidgets: BodyCRUDAddress(addressResponse: addressResponse),
        isBack: true,
        isAddress: true,
      ),
    );
  }
}



import 'package:doan_tn/home/controller/product_provider.dart';
import 'package:doan_tn/home/home_admin/thongke_tab/view/widget/body_thongke.dart';
import 'package:doan_tn/home/home_user/address/view/widget/body_address.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../base/services/dio_option.dart';
import '../../../../base/widget/SkeletonTab.dart';
import '../controller/thongke_controller.dart';
import '../servicer/thongke_service.dart';




class ThongKeScreen extends StatelessWidget {
  const ThongKeScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context)=>ThongKeProvider(ThongKeService(DioOption().createDio())),
        ),
      ],
      child:  SkeletonTab(
        title: 'Thống kê',
        // title: loginProvider.user!.token ?? '',
        bodyWidgets: BodyThongKe(),
        isBack: false,
      ),
    );
  }
}



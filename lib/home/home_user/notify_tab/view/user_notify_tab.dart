import 'package:doan_tn/auth/login/controller/login_provider.dart';
import 'package:doan_tn/home/home_user/notify_tab/view/widget/body_notify_tab.dart';
import 'package:doan_tn/home/home_user/view/widget/body_user_product_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../base/services/dio_option.dart';
import '../../../../base/widget/SkeletonTab.dart';
import '../controller/notify_provider.dart';
import '../service/notify_service.dart';




class UserNotifyTab extends StatelessWidget {
  const UserNotifyTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context)=>NotifyProvider(NotifyService(DioOption().createDio())),
        ),
      ],
      child:  SkeletonTab(
        title: 'Thông báo',
        // title: loginProvider.user!.token ?? '',
        bodyWidgets: BodyNotifyTab(),
        isBack: false,
      ),
    );
  }
}

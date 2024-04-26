import 'package:doan_tn/base/widget/appbar_widget.dart';
import 'package:doan_tn/home/home_user/view/widget/body_home_user_view.dart';
import 'package:doan_tn/values/styles.dart';
import 'package:flutter/material.dart';

class HomeUserView extends StatelessWidget {
  const HomeUserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBarWidget(
      tittle: Text('Trang chủ User' , style: AppStyles.h5,),
        child: const BodyHomeUserScreen());
  }
}

import 'package:doan_tn/base/widget/appbar_widget.dart';
import 'package:doan_tn/home/view/widget/body_home_view.dart';
import 'package:doan_tn/values/styles.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBarWidget(
      tittle: Text('Trang chủ' , style: AppStyles.h5,),
        child: const BodyHomeScreen());
  }
}

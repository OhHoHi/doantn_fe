
import 'package:doan_tn/auth/login/view/widget/body_login_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../base/services/dio_option.dart';
import '../controller/login_provider.dart';
import '../services/login_services.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginProvider(LoginServices(DioOption().createDio(addToken: false))),
        ),
      ],
      child: const LoginBodyWidget(),
    );
  }
}

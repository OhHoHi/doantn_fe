import 'package:doan_tn/auth/register/controller/register_provider.dart';
import 'package:doan_tn/auth/register/services/register_services.dart';
import 'package:doan_tn/auth/register/view/widget/body_register_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../base/services/dio_option.dart';
class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              RegisterProvider(
                  RegisterService(DioOption().createDio(addToken: false))),
        ),
      ],
      child: const BodyRegister(),
    );
  }
}

import 'package:doan_tn/home/home_admin/view/admin_product_tab.dart';
import 'package:doan_tn/values/route.dart';
import 'package:flutter/material.dart';
import 'auth/login/view/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/',
      onGenerateRoute: AppRoute.onGenerateRoutes,
    );
  }
}



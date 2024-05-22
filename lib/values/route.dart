import 'package:doan_tn/auth/login/view/login_screen.dart';
import 'package:doan_tn/auth/register/view/register_view.dart';
import 'package:doan_tn/home/home_admin/view/widget/product_detail.dart';
import 'package:doan_tn/home/model/product_reponse.dart';
import 'package:flutter/material.dart';

import '../home/home_admin/view/crud_product_tab.dart';
import '../home/home_admin/view/admin_page.dart';
import '../home/home_user/view/user_page.dart';


class AppRoute {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(const LoginScreen());

      // case '/Register':
      //   return _materialRoute(const RegisterView());

      // case '/Admin':
      //   return _materialRoute(const AdminPage());

      // case '/User':
      //   return _materialRoute(const UserPage());

      // case '/Product':
      //   return _materialRoute(ProductDetailScreen(
      //       arguments: settings.arguments as ProductDetailArguments));
      //
      // case '/ProductCrud':
      //   return _materialRoute(
      //       const AddProductScreen());

      default:
        return _materialRoute(const ErrorPage());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Error'),
      ),
    );
  }
}

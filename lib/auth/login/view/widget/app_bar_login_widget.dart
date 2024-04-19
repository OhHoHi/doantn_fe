import 'package:doan_tn/values/colors.dart';
import 'package:flutter/material.dart';


class AppBarLoginWidget extends StatefulWidget {
  const AppBarLoginWidget({super.key});

  @override
  State<AppBarLoginWidget> createState() => _AppBarLoginWidgetState();
}

class _AppBarLoginWidgetState extends State<AppBarLoginWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/logocaulong.png',
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          padding: const EdgeInsets.only(top: 60,right: 16),
          color: Color(0xff10B77B),
        ),


      ],
    );
  }
}


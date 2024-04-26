import 'package:flutter/material.dart';

import '../../../../auth/login/view/login_screen.dart';
import '../../../../values/colors.dart';


class BodyHomeUserScreen extends StatefulWidget {
  const BodyHomeUserScreen({Key? key}) : super(key: key);

  @override
  State<BodyHomeUserScreen> createState() => _BodyHomeViewState();
}

class _BodyHomeViewState extends State<BodyHomeUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: ColorApp.backgroundColor,
        child:GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => LoginScreen(
                  // data: loginProvider.user!,
                )));
          },
          child: Container(
            height: 40,
            margin: EdgeInsets.only(left: 19, right: 19),
            decoration: BoxDecoration(
              color: ColorApp.buttonColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                'đăng xuất',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
    );
  }
}

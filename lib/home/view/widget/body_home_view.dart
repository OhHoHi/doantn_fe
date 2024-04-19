import 'package:flutter/material.dart';

import '../../../values/colors.dart';

class BodyHomeScreen extends StatefulWidget {
  const BodyHomeScreen({Key? key}) : super(key: key);

  @override
  State<BodyHomeScreen> createState() => _BodyHomeViewState();
}

class _BodyHomeViewState extends State<BodyHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      color: ColorApp.backgroundColor,
    );
  }
}

import 'package:flutter/material.dart';

class FontFamily {
  static final san = 'Open Sans';
  static final inter = 'Inter';
  static final nutino = 'Nuntio';
  static final nutino1 = 'Nuntio1';



}

class AppStyles {
  static TextStyle h1 = TextStyle(
      fontFamily: FontFamily.san, fontSize: 28, color: Colors.white);

  static TextStyle h2 = TextStyle(
      fontFamily: FontFamily.san, fontSize: 22, color: Colors.white);

  static TextStyle nuntio_14 = TextStyle(
      fontFamily: FontFamily.nutino, fontSize: 14, color: Colors.white);
  static TextStyle nuntio_14_black = TextStyle(
      fontFamily: FontFamily.nutino, fontSize: 14, color: Colors.black);
  static TextStyle nuntio1_14 = TextStyle(
      fontFamily: FontFamily.nutino1, fontSize: 14, color: Colors.white);
  static TextStyle nuntio_18 = TextStyle(
      fontFamily: FontFamily.nutino, fontSize: 18, color: Colors.black);
  static TextStyle nuntio_30 = TextStyle(
      fontFamily: FontFamily.nutino, fontSize: 30, color: Colors.black);
  static TextStyle nuntio_20 = TextStyle(
      fontFamily: FontFamily.nutino, fontSize: 20, color: Colors.black);
  static TextStyle nuntio_25 = TextStyle(
      fontFamily: FontFamily.nutino, fontSize: 25, color: Colors.black);

  static TextStyle h4 = TextStyle(
      fontFamily: FontFamily.san, fontSize: 12, color: Colors.white);
  static TextStyle h4Inter = TextStyle(
      fontFamily: FontFamily.inter, fontSize: 12, color: Colors.white);
  static TextStyle h4Inter11 = TextStyle(
      fontFamily: FontFamily.inter, fontSize: 11, color: Colors.white);

  static TextStyle subTitle = TextStyle(
      fontFamily: FontFamily.san, fontSize: 13, color: Colors.black38);

  static TextStyle subTitle2 = TextStyle(
      fontFamily: FontFamily.san, fontSize: 14, color: Colors.black38,fontWeight: FontWeight.w400);

  static TextStyle h5 = TextStyle(
      fontFamily: FontFamily.inter, fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600);

  static TextStyle h6 = TextStyle(
      fontFamily: FontFamily.san, fontSize: 14, color: Color(0xFF00313E), fontWeight: FontWeight.w600);

  static TextStyle h7 = TextStyle(
      fontFamily: FontFamily.san, fontSize: 14, color: Color(0xFF00313E), fontWeight: FontWeight.w400);
  static TextStyle h8 = TextStyle(
      fontFamily: FontFamily.san, fontSize: 14, color: Color(0xFF006885), fontWeight: FontWeight.w600);
  static TextStyle h9 = TextStyle(
      fontFamily: FontFamily.san, fontSize: 12, color: Color(0xFF547933), fontWeight: FontWeight.w600);

}
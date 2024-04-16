import 'package:flutter/material.dart';

abstract class AppColors {
  // primary color should be like rgba(66, 0, 255, 1)
  // static const Color primary = Color.fromRGBO(66, 0, 255, 1);
  static const Color primary = Color(0xFF300080);

  static const Color secondary = Color.fromRGBO(246, 12, 12, 1);
  static const Color fields = Color.fromRGBO(236, 244, 249, 1);
  static const Color success = Color.fromRGBO(34, 139, 34, 1);

  static const Color background = Color.fromRGBO(255, 255, 249, 1);
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color black = Color.fromRGBO(0, 0, 0, 1);
  static const Color danger = Color.fromRGBO(255, 0, 0, 1);
  static const Color transparentColor = Color.fromRGBO(0, 0, 0, 0.5);

  static const Color transparent = Colors.transparent;
  static const Color grey = Colors.grey;

  //background: rgba(15, 181, 218, 1);
  static const Color skyBlue = Color.fromRGBO(15, 181, 218, 1);

  //background: rgba(224, 34, 102, 1);
  static const Color pink = Color.fromRGBO(224, 34, 102, 1);

  //background: rgba(29, 174, 17, 1);
  static const Color green = Color.fromRGBO(29, 174, 17, 1);
}

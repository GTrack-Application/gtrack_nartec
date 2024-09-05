import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class AppSnackbars {
  static void danger(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    toast(
      message.replaceAll("Exception:", ""),
      bgColor: Colors.red,
      textColor: Colors.white,
    );
  }

  static void normal(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    toast(
      message.replaceAll("Exception:", ""),
      bgColor: Colors.red,
      textColor: Colors.white,
    );
  }

  static void success(
    BuildContext context,
    String message,
    int? duration,
  ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    toast(
      message.replaceAll("Exception:", ""),
      bgColor: Colors.red,
      textColor: Colors.white,
    );
  }
}

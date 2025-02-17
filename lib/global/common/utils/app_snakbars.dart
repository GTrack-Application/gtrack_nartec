import 'package:flutter/material.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';

class AppSnackbars {
  static void danger(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message.replaceAll("Exception:", "")),
        backgroundColor: Colors.red,
      ),
    );
  }

  static void normal(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message.replaceAll("Exception:", "")),
        backgroundColor: AppColors.grey,
      ),
    );
  }

  static void success(BuildContext context, String message, [int? duration]) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message.replaceAll("Exception:", "")),
        backgroundColor: Colors.green,
      ),
    );
  }
}

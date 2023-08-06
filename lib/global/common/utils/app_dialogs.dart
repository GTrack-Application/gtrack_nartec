import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/global/widgets/loading/loading_widget.dart';

class AppDialogs {
  static BuildContext? dialogueContext;
  static Future<dynamic> loadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        dialogueContext = ctx;
        return const LoadingWidget();
      },
    );
  }

  static void closeDialog() {
    Navigator.pop(dialogueContext!);
  }

  // static bool exitDialog(BuildContext context) {
  //   bool? exitStatus = false;
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Exit App'),
  //       content: const Text('Are you sure you want to exit the app?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('No'),
  //         ),
  //         TextButton(
  //           onPressed: () async {
  //             loadingDialog(context);
  //             exitStatus = await FlutterExitApp.exitApp();
  //             closeDialog();
  //           },
  //           child: const Text('Yes'),
  //         ),
  //       ],
  //     ),
  //   );
  //   return exitStatus ?? false;
  // }
}

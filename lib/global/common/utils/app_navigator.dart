import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class AppNavigator {
  static goToPage({required BuildContext context, required Widget screen}) {
    return Navigator.push(
      context,
      PageTransition(
        duration: const Duration(milliseconds: 400),
        type: PageTransitionType.fade,
        child: screen,
      ),
    );
  }

  static replaceTo({required BuildContext context, required Widget screen}) {
    return Navigator.pushReplacement(
      context,
      PageTransition(
        duration: const Duration(milliseconds: 400),
        type: PageTransitionType.fade,
        child: screen,
      ),
    );
  }

  static pushAndRemoveUntil(
      {required BuildContext context, required Widget screen}) {
    return Navigator.pushAndRemoveUntil(
      context,
      PageTransition(
        duration: const Duration(milliseconds: 400),
        type: PageTransitionType.fade,
        child: screen,
      ),
      (route) => false,
    );
  }
}

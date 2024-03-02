import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_images.dart';

class AppLogo extends StatelessWidget {
  final double? height;
  final double? width;
  const AppLogo({
    super.key,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        AppImages.logo,
        height: height,
        width: width,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gtrack_mobile_app/constants/app_images.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        ScaleEffect(
          duration: Duration(seconds: 3),
        )
      ],
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          child: Image.asset(
            AppImages.logo,
            width: 256,
            height: 256,
          ),
        ),
      ),
    );
  }
}

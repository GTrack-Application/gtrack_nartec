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
          duration: Duration(seconds: 2),
        )
      ],
      child: Center(
        child: Image.asset(AppImages.logo),
      ),
    );
  }
}

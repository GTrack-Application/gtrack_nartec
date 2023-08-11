import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitCircle(color: AppColors.primary),
    );
  }
}

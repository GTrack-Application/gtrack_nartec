import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:nb_utils/nb_utils.dart';

class AppToast {
  static success(message) {
    _appToast(message, AppColors.success);
  }

  static danger(message) {
    _appToast(message, AppColors.danger);
  }

  static normal(message) {
    _appToast(message, AppColors.black);
  }
}

void _appToast(message, color) {
  toast(
    message.toString().replaceAll("Exception:", ""),
    bgColor: color,
    length: Toast.LENGTH_LONG,
  );
}

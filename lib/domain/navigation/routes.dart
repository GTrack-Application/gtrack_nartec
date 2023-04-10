import 'package:get/get.dart';
import 'package:gtrack_mobile_app/pages/gtrack-menu/menu_page.dart';
import 'package:gtrack_mobile_app/pages/gtrack-menu/receipts-management/receipt_management_page.dart';
import 'package:gtrack_mobile_app/pages/login/activities_and_password_page.dart';
import 'package:gtrack_mobile_app/pages/login/otp_page.dart';
import 'package:gtrack_mobile_app/pages/login/user_login_page.dart';

class AppPages {
  static List<GetPage> pages = [
    GetPage(
      name: '/',
      page: () => const ReceiptManagementPage(),
    ),
    GetPage(
      name: MenuPage.pageName,
      page: () => const MenuPage(),
    ),
    GetPage(
      name: ActivitiesAndPasswordPage.pageName,
      page: () => const ActivitiesAndPasswordPage(),
    ),
    GetPage(
      name: OtpPage.pageName,
      page: () => const OtpPage(),
    ),
    GetPage(
      name: ReceiptManagementPage.pageName,
      page: () => const ReceiptManagementPage(),
    ),
  ];
}

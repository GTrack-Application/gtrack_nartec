import 'package:get/get.dart';
import 'package:gtrack_mobile_app/old/pages/gtrack-menu/dispatch_management/dispatch_management_one_page.dart';
import 'package:gtrack_mobile_app/old/pages/gtrack-menu/dispatch_management/dispatch_management_two_page.dart';
import 'package:gtrack_mobile_app/old/pages/gtrack-menu/menu_page.dart';
import 'package:gtrack_mobile_app/old/pages/gtrack-menu/receipts-management/receipt_management_page.dart';
import 'package:gtrack_mobile_app/old/pages/login/user_login_page.dart';

class AppPages {
  static List<GetPage> pages = [
    GetPage(
      name: '/',
      page: () => const UserLoginPage(),
    ),
    GetPage(
      name: MenuPage.pageName,
      page: () => const MenuPage(),
    ),
    // GetPage(
    //   name: ActivitiesAndPasswordPage.pageName,
    //   page: () => const ActivitiesAndPasswordPage(),
    // ),
    // GetPage(
    //   name: OtpPage.pageName,
    //   page: () => const OtpPage(),
    // ),
    GetPage(
      name: ReceiptManagementPage.pageName,
      page: () => const ReceiptManagementPage(),
    ),
    GetPage(
      name: DispatchManagementOnePage.pageName,
      page: () => const DispatchManagementOnePage(),
    ),
    GetPage(
      name: DispatchManagementTwoPage.pageName,
      page: () => const DispatchManagementTwoPage(),
    ),
  ];
}

import 'package:get/get.dart';
import 'package:gtrack_mobile_app/pages/login/user_login_page.dart';

class AppPages {
  static List<GetPage> pages = [
    GetPage(
      name: '/',
      page: () => const UserLoginPage(),
    ),
  ];
}

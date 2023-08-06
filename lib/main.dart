import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gtrack_mobile_app/domain/routes/routes.dart';
import 'package:gtrack_mobile_app/providers/dispatch_management/gln_provider.dart';
import 'package:gtrack_mobile_app/providers/login/login_provider.dart';
import 'package:gtrack_mobile_app/themes/themes.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => GlnProvider(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: Size(context.screenWidth, context.screenHeight),
        builder: (context, child) => GestureDetector(
          onTap: () {
            hideKeyboard(context);
          },
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Gtrack',
            theme: Themes.lightTheme(),
            darkTheme: Themes.darkTheme(),
            themeMode: ThemeMode.system,
            initialRoute: '/',
            getPages: AppPages.pages,
          ),
        ),
      ),
    );
  }
}

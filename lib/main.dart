import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtrack_mobile_app/config/themes/themes.dart';
import 'package:gtrack_mobile_app/domain/navigation/routes.dart';
import 'package:gtrack_mobile_app/providers/login/login_provider.dart';
import 'package:provider/provider.dart';

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
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gtrack',
        theme: Themes.lightTheme(),
        darkTheme: Themes.darkTheme(),
        themeMode: ThemeMode.system,
        initialRoute: '/',
        getPages: AppPages.pages,
      ),
    );
  }
}

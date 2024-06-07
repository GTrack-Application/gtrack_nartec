import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gtrack_mobile_app/cubit/capture/agregation/packing/packed_items/packed_items_cubit.dart';
import 'package:gtrack_mobile_app/cubit/capture/association/receiving/raw_materials/item_details/item_details_cubit.dart';
import 'package:gtrack_mobile_app/cubit/capture/capture_cubit.dart';
import 'package:gtrack_mobile_app/global/themes/themes.dart';
import 'package:gtrack_mobile_app/old/pages/login/user_login_page.dart';
import 'package:gtrack_mobile_app/old/providers/dispatch_management/gln_provider.dart';
import 'package:gtrack_mobile_app/old/providers/login/login_provider.dart';
import 'package:nb_utils/nb_utils.dart';
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
        ChangeNotifierProvider(
          create: (context) => GlnProvider(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: Size(MediaQuery.sizeOf(context).width,
            MediaQuery.sizeOf(context).height),
        builder: (context, child) => GestureDetector(
          onTap: () {
            hideKeyboard(context);
          },
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => CaptureCubit()),
              BlocProvider(create: (context) => PackedItemsCubit()),
              BlocProvider(create: (context) => ItemDetailsCubit()),
            ],
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Gtrack',
              theme: Themes.lightTheme(),
              home: const UserLoginPage(),
            ),
          ),
        ),
      ),
    );
  }
}

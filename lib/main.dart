import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gtrack_nartec/blocs/Identify/gln/gln_cubit.dart';
import 'package:gtrack_nartec/blocs/Identify/gtin/gtin_cubit.dart';
import 'package:gtrack_nartec/blocs/Identify/sscc/sscc_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/agregation/packing/packed_items/packed_items_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/receiving/raw_materials/item_details/item_details_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/capture_cubit.dart';
import 'package:gtrack_nartec/cubit/share/share_cubit.dart';
import 'package:gtrack_nartec/global/themes/themes.dart';
import 'package:gtrack_nartec/old/pages/login/user_login_page.dart';
import 'package:gtrack_nartec/old/providers/dispatch_management/gln_provider.dart';
import 'package:gtrack_nartec/old/providers/login/login_provider.dart';
import 'package:provider/provider.dart';

extension ColorExtension on Color {
  Color withValues({double? alpha}) {
    return withValues(alpha: alpha ?? 1.0);
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => GlnProvider()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => CaptureCubit()),
          BlocProvider(create: (context) => PackedItemsCubit()),
          BlocProvider(create: (context) => ItemDetailsCubit()),
          BlocProvider(create: (context) => ShareCubit()),
          BlocProvider(create: (context) => GtinCubit()..getGtinData()),
          BlocProvider(create: (context) => GlnCubit()..identifyGln()),
          BlocProvider(create: (context) => SsccCubit()..getSsccData()),
        ],
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Gtrack',
          theme: Themes.lightTheme(),
          home: const UserLoginPage(),
        ),
      ),
    );
  }
}

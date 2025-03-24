import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gtrack_nartec/blocs/Identify/gln/gln_cubit.dart';
import 'package:gtrack_nartec/blocs/Identify/gtin/gtin_cubit.dart';
import 'package:gtrack_nartec/blocs/Identify/sscc/sscc_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/agregation/packaging/packaging_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/agregation/packing/packed_items/packed_items_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/receiving/purchase_order_receipt/purchase_order_receipt_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/receiving/raw_materials/item_details/item_details_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/shipping/sales_order/sales_order_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/transfer/goods_receipt/job_order_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/transfer/production_job_order/production_job_order_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/capture_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/transformation/transformation_cubit.dart';
import 'package:gtrack_nartec/cubit/share/share_cubit.dart';
import 'package:gtrack_nartec/global/themes/themes.dart';
import 'package:gtrack_nartec/screens/home/auth/providers/dispatch_management/gln_provider.dart';
import 'package:gtrack_nartec/screens/home/auth/providers/login/login_provider.dart';
import 'package:gtrack_nartec/screens/home/auth/user_login_page.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/cubit/aggregation_cubit_v2.dart';
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
          BlocProvider(create: (context) => GtinCubit()),
          BlocProvider(create: (context) => GlnCubit()),
          BlocProvider(create: (context) => SsccCubit()..getSsccData()),
          BlocProvider(create: (context) => ProductionJobOrderCubit()),
          BlocProvider(create: (context) => PurchaseOrderReceiptCubit()),
          BlocProvider(create: (context) => PackagingCubit()),
          // Goods Receipt --> Job Order
          BlocProvider(create: (context) => JobOrderCubit()),
          BlocProvider(create: (context) => SalesOrderCubit()),
          BlocProvider(create: (context) => TransformationCubit()),
          BlocProvider(create: (context) => AggregationCubit()),
        ],
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Gtrack',
          theme: Themes.lightTheme(),
          home: const UserLoginPage(),
          // home: const ProductionJobOrderScreen(),
          // home: const PurchaseOrderReceiptScreen(),
        ),
      ),
    );
  }
}

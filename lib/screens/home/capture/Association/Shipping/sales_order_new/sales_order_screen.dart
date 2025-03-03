import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/association/shipping/sales_order/sales_order_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/shipping/sales_order/sales_order_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/sales_order/sales_order_model.dart';

class SalesOrderScreen extends StatefulWidget {
  const SalesOrderScreen({super.key});

  @override
  State<SalesOrderScreen> createState() => _SalesOrderScreenState();
}

class _SalesOrderScreenState extends State<SalesOrderScreen> {
  final SalesOrderCubit salesOrderCubit = SalesOrderCubit();

  @override
  void initState() {
    super.initState();
    salesOrderCubit.getSalesOrder();
  }

  List<SalesOrderModel> salesOrder = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.pink,
        title: const Text('Sales Order'),
      ),
      body: BlocConsumer<SalesOrderCubit, SalesOrderState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is SalesOrderLoading) {}
          if (state is SalesOrderError) {}
          if (state is SalesOrderLoaded) {
            salesOrder = state.salesOrder;
          }
          return Column(
            children: [],
          );
        },
      ),
    );
  }
}

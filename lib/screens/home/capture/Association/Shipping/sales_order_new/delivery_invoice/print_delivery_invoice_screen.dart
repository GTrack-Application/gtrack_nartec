// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/features/capture/cubits/association/shipping/sales_order/sales_order_cubit.dart';
import 'package:gtrack_nartec/features/capture/cubits/association/shipping/sales_order/sales_order_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/features/capture/models/Association/Receiving/sales_order/map_model.dart';
import 'package:gtrack_nartec/features/capture/models/Association/Receiving/sales_order/sub_sales_order_model.dart';

class PrintDeliveryInvoiceScreen extends StatefulWidget {
  const PrintDeliveryInvoiceScreen({
    super.key,
    required this.customerId,
    required this.salesOrderId,
    required this.mapModel,
    required this.subSalesOrder,
  });

  final String customerId;
  final String salesOrderId;
  final List<MapModel> mapModel;
  final List<SubSalesOrderModel> subSalesOrder;

  @override
  State<PrintDeliveryInvoiceScreen> createState() =>
      _PrintDeliveryInvoiceScreenState();
}

class _PrintDeliveryInvoiceScreenState
    extends State<PrintDeliveryInvoiceScreen> {
  final SalesOrderCubit salesOrderCubit = SalesOrderCubit();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SalesOrderCubit, SalesOrderState>(
      bloc: salesOrderCubit,
      listener: (context, state) {
        if (state is StatusUpdateLoaded) {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          AppSnackbars.success(context, "Sales Invoice updated successfully.");

          salesOrderCubit.getSalesOrder();
        }
        if (state is StatusUpdateError) {
          AppSnackbars.danger(
            context,
            state.message.replaceAll("Exception: ", ""),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.pink,
            title: const Text('Delivery Invoice'),
          ),
          body: Container(
            color: AppColors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Implement e-invoice generation
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.pink,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.receipt_long, size: 24),
                              SizedBox(width: 10),
                              Text(
                                'Generate E-Invoice',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            final now = DateTime.now();
                            await salesOrderCubit.statusUpdate(
                              widget.salesOrderId,
                              {
                                'endJourneyTime': now.toIso8601String(),
                                'status': 'Completed'
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: state is StatusUpdateLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.check_circle, size: 24),
                                    SizedBox(width: 10),
                                    Text(
                                      'Completed',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

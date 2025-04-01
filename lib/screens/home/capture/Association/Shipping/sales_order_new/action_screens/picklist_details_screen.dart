// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/features/capture/cubits/association/shipping/sales_order/sales_order_cubit.dart';
import 'package:gtrack_nartec/features/capture/cubits/association/shipping/sales_order/sales_order_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/features/capture/models/Association/Receiving/sales_order/map_model.dart';
import 'package:gtrack_nartec/features/capture/models/Association/Receiving/sales_order/sub_sales_order_model.dart';

class PicklistDetailsScreen extends StatefulWidget {
  const PicklistDetailsScreen({
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
  State<PicklistDetailsScreen> createState() => _PicklistDetailsScreenState();
}

class _PicklistDetailsScreenState extends State<PicklistDetailsScreen> {
  @override
  void initState() {
    super.initState();
    print(widget.subSalesOrder.length);
  }

  final SalesOrderCubit salesOrderCubit = SalesOrderCubit();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SalesOrderCubit, SalesOrderState>(
      bloc: salesOrderCubit,
      listener: (context, state) {
        if (state is StatusUpdateLoaded) {
          Navigator.pop(context);
          AppSnackbars.success(context, "Sales Invoice updated successfully.");
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
          backgroundColor: AppColors.white,
          appBar: AppBar(
            title: const Text('Picklist Details'),
            elevation: 2,
            backgroundColor: AppColors.pink,
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                final now = DateTime.now();
                await salesOrderCubit.statusUpdate(
                  widget.salesOrderId,
                  {'unloadingTime': now.toIso8601String()},
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pink,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: state is StatusUpdateLoading
                  ? CircularProgressIndicator(color: AppColors.white)
                  : const Text(
                      'Unloading Complete',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: AppColors.white,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Order Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.local_shipping,
                            size: 40,
                            color: AppColors.green,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.subSalesOrder.length,
                        itemBuilder: (context, index) {
                          final item = widget.subSalesOrder[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 5,
                            color: AppColors.white,
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(
                                item.salesInvoiceMaster?.salesInvoiceNumber ??
                                    'N/A',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoRow(
                                      'Sales Invoice Number',
                                      item.salesInvoiceMaster
                                              ?.salesInvoiceNumber ??
                                          'N/A'),
                                  _buildInfoRow('Delivery Status',
                                      item.salesInvoiceMaster?.status ?? 'N/A'),
                                  _buildInfoRow(
                                      'Delivery Date',
                                      item.salesInvoiceMaster?.deliveryDate ??
                                          'N/A'),
                                  _buildInfoRow(
                                      'Delivery Time',
                                      item.salesInvoiceMaster
                                              ?.startJourneyTime ??
                                          'N/A'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

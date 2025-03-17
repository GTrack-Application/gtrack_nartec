// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/association/shipping/sales_order/sales_order_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/shipping/sales_order/sales_order_state.dart';
import 'package:gtrack_nartec/cubit/capture/association/transfer/production_job_order/production_job_order_cubit.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/sales_order/sub_sales_order_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Shipping/sales_order_new/route_screen.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Transfer/goods_issue/production_job_order/job_order_bom_details_screen.dart';

class SubSalesOrderScreen extends StatefulWidget {
  const SubSalesOrderScreen({super.key, required this.salesOrderId});

  final String salesOrderId;

  @override
  State<SubSalesOrderScreen> createState() => _SubSalesOrderScreenState();
}

class _SubSalesOrderScreenState extends State<SubSalesOrderScreen> {
  late SalesOrderCubit salesOrderCubit;

  @override
  void initState() {
    super.initState();
    salesOrderCubit = context.read<SalesOrderCubit>();
    salesOrderCubit.getSubSalesOrder(widget.salesOrderId);
  }

  List<SubSalesOrderModel> subSalesOrder = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Order'),
        backgroundColor: AppColors.pink,
      ),
      body: BlocConsumer<SalesOrderCubit, SalesOrderState>(
        bloc: salesOrderCubit,
        listener: (context, state) {
          if (state is SubSalesOrderLoaded) {
            subSalesOrder = state.subSalesOrder;
          } else if (state is SubSalesOrderError) {
            AppSnackbars.danger(context, state.message.toString());
          }
        },
        builder: (context, state) {
          if (state is SubSalesOrderLoading) {
            return ListView.builder(
              itemCount: 5, // Show 5 placeholder items
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  color: AppColors.white,
                  shadowColor: AppColors.black.withOpacity(0.3),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120,
                          height: 14,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 12),
                        for (int i = 0; i < 4; i++) ...[
                          Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 200,
                                height: 12,
                                color: Colors.grey[300],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is SubSalesOrderError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 100,
                  color: AppColors.pink,
                ),
                Center(
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            );
          }

          final isPicked = subSalesOrder
              .where(
                (element) => element.quantityPicked == element.quantity,
              )
              .isNotEmpty;

          return ListView.builder(
            itemCount:
                subSalesOrder.length + 1, // Increased by 1 for the button
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              if (index == 0) {
                // Start Journey button at the top

                return Visibility(
                  visible: isPicked,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: PrimaryButtonWidget(
                        text: isPicked ? "View Journey" : "Pick Goods",
                        backgroundColor: AppColors.pink,
                        onPressed: () {
                          if (isPicked) {
                            AppNavigator.replaceTo(
                              context: context,
                              screen: RouteScreen(
                                customerId: subSalesOrder[index]
                                        .salesInvoiceMaster
                                        ?.customerId ??
                                    '',
                                salesOrderId: widget.salesOrderId,
                                subSalesOrder: subSalesOrder,
                              ),
                            );
                          } else {
                            AppSnackbars.warning(
                              context,
                              'Please pick the goods first',
                            );
                          }
                        }),
                  ),
                );
              }

              final order =
                  subSalesOrder[index - 1]; // Adjust index for the list items
              return GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => SalesOrderDetailScreen(
                  //       salesOrder: order,
                  //     ),
                  //   ),
                  // );
                },
                child: Card(
                  color: AppColors.white,
                  shadowColor: AppColors.black.withOpacity(0.3),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invoice #${order.salesInvoiceMaster?.salesInvoiceNumber ?? ''}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.pink,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          icon: Icons.attach_money,
                          label: 'Amount:',
                          value: 'SAR ${order.totalPrice ?? ''}',
                        ),
                        _buildInfoRow(
                          icon: Icons.local_shipping,
                          label: 'Delivery:',
                          value: _formatDate(
                              order.salesInvoiceMaster?.deliveryDate ?? ''),
                        ),
                        _buildInfoRow(
                          icon: Icons.calendar_today,
                          label: 'Order:',
                          value: _formatDate(
                              order.salesInvoiceMaster?.pickDate ?? ''),
                        ),
                        _buildInfoRow(
                          icon: Icons.info_outline,
                          label: 'Status:',
                          value: order.salesInvoiceMaster?.status ?? '',
                          valueColor: _getStatusColor(
                              order.salesInvoiceMaster?.status ?? ''),
                        ),
                        _buildInfoRow(
                          icon: Icons.info_outline,
                          label: 'Quantity Picked:',
                          value: order.quantityPicked?.toString() ?? '',
                        ),
                        _buildInfoRow(
                          icon: Icons.info_outline,
                          label: 'Quantity:',
                          value: order.quantity?.toString() ?? '',
                        ),
                        Visibility(
                          visible: !isPicked,
                          child: Row(
                            children: [
                              const Spacer(),
                              PrimaryButtonWidget(
                                text: 'Pick Goods',
                                height: 30,
                                width: 150,
                                backgroundColor: AppColors.pink,
                                onPressed: () {
                                  context
                                      .read<ProductionJobOrderCubit>()
                                      .selectedSubSalesOrder = order;
                                  AppNavigator.goToPage(
                                    context: context,
                                    screen: JobOrderBomDetailsScreen(
                                      isSalesOrder: true,
                                      barcode: order.productId ?? '',
                                      jobOrderNumber: order.salesInvoiceMaster
                                              ?.salesInvoiceNumber ??
                                          '',
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.grey),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final DateTime dateTime = DateTime.parse(date);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return date;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.black;
    }
  }
}

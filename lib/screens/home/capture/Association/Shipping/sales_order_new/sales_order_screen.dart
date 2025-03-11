import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/association/shipping/sales_order/sales_order_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/shipping/sales_order/sales_order_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/sales_order/sales_order_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Shipping/sales_order_new/sub_sales_order_screen.dart';

class SalesOrderScreen extends StatefulWidget {
  const SalesOrderScreen({super.key});

  @override
  State<SalesOrderScreen> createState() => _SalesOrderScreenState();
}

class _SalesOrderScreenState extends State<SalesOrderScreen> {
  late SalesOrderCubit salesOrderCubit;

  @override
  void initState() {
    super.initState();
    salesOrderCubit = context.read<SalesOrderCubit>();
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
        bloc: salesOrderCubit,
        listener: (context, state) {
          if (state is SalesOrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is SalesOrderLoaded) {
            salesOrder = state.salesOrder;
          }
        },
        builder: (context, state) {
          if (state is SalesOrderLoading) {
            return ListView.builder(
              itemCount: 5, // Show 5 placeholder items
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  color: AppColors.white,
                  shadowColor: AppColors.black.withValues(alpha: 0.3),
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
          }

          if (salesOrder.isEmpty) {
            return const Center(
              child: Text('No sales order found'),
            );
          }

          return ListView.builder(
            itemCount: salesOrder.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final order = salesOrder[index];
              return GestureDetector(
                onTap: () {
                  AppNavigator.goToPage(
                    context: context,
                    screen: SubSalesOrderScreen(
                      salesOrderId: order.id ?? '',
                    ),
                  );
                },
                child: Card(
                  color: AppColors.white,
                  shadowColor: AppColors.black.withValues(alpha: 0.3),
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
                          'Invoice #${order.salesInvoiceNumber ?? ''}',
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
                          value: 'SAR ${order.totalAmount ?? ''}',
                        ),
                        _buildInfoRow(
                          icon: Icons.local_shipping,
                          label: 'Delivery:',
                          value: _formatDate(order.deliveryDate ?? ''),
                        ),
                        _buildInfoRow(
                          icon: Icons.calendar_today,
                          label: 'Order:',
                          value: _formatDate(order.orderDate ?? ''),
                        ),
                        _buildInfoRow(
                          icon: Icons.info_outline,
                          label: 'Status:',
                          value: order.status ?? '',
                          valueColor: _getStatusColor(order.status ?? ''),
                        ),
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

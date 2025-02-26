// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/association/transfer/production_job_order/production_job_order_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/transfer/production_job_order/production_job_order_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/widgets/text_field/text_form_field_widget.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/ProductionJobOrder/production_job_order.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Transfer/goods_issue/production_job_order/job_order_bom_screen.dart';
import 'package:intl/intl.dart';

class ProductionJobOrderScreen extends StatefulWidget {
  const ProductionJobOrderScreen({super.key});

  @override
  State<ProductionJobOrderScreen> createState() =>
      _ProductionJobOrderScreenState();
}

class _ProductionJobOrderScreenState extends State<ProductionJobOrderScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<ProductionJobOrderCubit>().getProductionJobOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Goods Issue Production Job Order",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.pink,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                spacing: 8.0,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormFieldWidget(
                      controller: _searchController,
                      hintText: "Search job orders",
                      onChanged: (value) {
                        context
                            .read<ProductionJobOrderCubit>()
                            .searchProductionJobOrders(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocConsumer<ProductionJobOrderCubit,
                  ProductionJobOrderState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is ProductionJobOrderLoading) {
                    return ListView.builder(
                      itemCount: 5,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.grey.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: AppColors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    width: 80,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: AppColors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: 150,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: AppColors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color:
                                              AppColors.grey.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 24),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color:
                                              AppColors.grey.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                width: 150,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: AppColors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  if (state is ProductionJobOrderError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 60,
                            color: AppColors.pink.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is ProductionJobOrderLoaded) {
                    return ListView.builder(
                      itemCount: state.orders.length,
                      itemBuilder: (context, index) => JobOrderCard(
                        order: state.orders[index],
                      ),
                      padding: const EdgeInsets.all(16),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JobOrderCard extends StatelessWidget {
  const JobOrderCard({super.key, required this.order});

  final ProductionJobOrder order;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.grey.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          AppNavigator.goToPage(
            context: context,
            screen: JobOrderBomScreen(
              jobOrderDetailsId: order.id!,
              jobOrderNumber: order.jobOrderMaster?.jobOrderNumber ?? 'N/A',
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.pink.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      DateFormat('dd MMM yyyy').format(
                        DateTime.parse(order.jobOrderMaster?.orderDate ?? ''),
                      ),
                      style: TextStyle(
                        color: AppColors.pink,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: order.jobOrderMaster?.status == "pending"
                          ? AppColors.skyBlue.withOpacity(0.1)
                          : AppColors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      order.jobOrderMaster?.status?.toUpperCase() ?? 'N/A',
                      style: TextStyle(
                        color: order.jobOrderMaster?.status == "pending"
                            ? AppColors.skyBlue
                            : AppColors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                order.jobOrderMaster?.jobOrderNumber ?? "N/A",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildInfoItem(
                    icon: Icons.inventory,
                    label: "Items",
                    value: order.quantity ?? "N/A",
                  ),
                  const SizedBox(width: 24),
                  _buildInfoItem(
                    icon: Icons.attach_money,
                    label: "Cost",
                    value: order.jobOrderMaster?.totalCost ?? "N/A",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoItem(
                icon: Icons.calendar_today,
                label: "Delivery",
                value: DateFormat('dd MMM yyyy').format(
                  DateTime.parse(order.jobOrderMaster?.deliveryDate ?? ''),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.grey,
        ),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 13,
            color: AppColors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/association/transfer/goods_receipt/job_order_cubit.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/goods_receipt/job_order/job_order_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Transfer/goods_receipt/job_order/job_order_item_details_screen.dart';
import 'package:intl/intl.dart';

class JobOrderScreen extends StatefulWidget {
  const JobOrderScreen({super.key});

  @override
  State<JobOrderScreen> createState() => _JobOrderScreenState();
}

class _JobOrderScreenState extends State<JobOrderScreen> {
  late JobOrderCubit jobOrderCubit;
  @override
  void initState() {
    super.initState();
    jobOrderCubit = JobOrderCubit.get(context);
    jobOrderCubit.getJobOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Job Orders',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.pink,
      ),
      body: BlocBuilder<JobOrderCubit, JobOrderState>(
        bloc: jobOrderCubit,
        builder: (context, state) {
          if (state is JobOrderLoading) {
            return _buildLoadingPlaceholder();
          }
          if (state is JobOrderError) {
            return Center(child: Text(state.message));
          }
          return RefreshIndicator(
            onRefresh: () => jobOrderCubit.getJobOrders(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: jobOrderCubit.orders.length,
              itemBuilder: (context, index) {
                final order = jobOrderCubit.orders[index];
                return _buildJobOrderCard(order);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          color: AppColors.background,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with product name and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildShimmerContainer(width: 180, height: 22),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.skyBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: _buildShimmerContainer(width: 60, height: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Product details
                _buildShimmerContainer(width: 150, height: 16),
                const SizedBox(height: 8),
                _buildShimmerContainer(width: 180, height: 16),
                const SizedBox(height: 8),
                _buildShimmerContainer(width: 140, height: 16),
                const SizedBox(height: 8),
                _buildShimmerContainer(width: 200, height: 16),

                // Bill of materials section
                const SizedBox(height: 16),
                _buildShimmerContainer(width: 120, height: 18),
                const SizedBox(height: 12),

                // BOM item
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildShimmerContainer(width: 160, height: 16),
                      const SizedBox(height: 6),
                      _buildShimmerContainer(width: 140, height: 14),
                      const SizedBox(height: 6),
                      _buildShimmerContainer(width: 120, height: 14),
                    ],
                  ),
                ),

                // Button placeholder
                Row(
                  children: [
                    const Spacer(),
                    Container(
                      width: 160,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.pink.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerContainer(
      {required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildJobOrderCard(JobOrderModel order) {
    return Card(
      color: AppColors.background,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4.0,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.productName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: order.status == "pending"
                        ? AppColors.skyBlue.withValues(alpha: 0.1)
                        : AppColors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      color: order.status == "pending"
                          ? AppColors.skyBlue
                          : AppColors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'Product ID: ${order.productId}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              'Quantity: ${order.quantity} ${order.unitOfMeasure}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              'Total Price: SAR ${order.totalPrice}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              'Picked Date: ${DateFormat('dd/MM/yyyy HH:mm').format(order.pickedDate)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            if (order.billOfMaterials.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Bill of Materials',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ...order.billOfMaterials.map((bom) => _buildBOMItem(bom)),
              Row(
                children: [
                  const Spacer(),
                  FilledButton(
                    onPressed: () {
                      AppNavigator.goToPage(
                        context: context,
                        screen: JobOrderItemDetailsScreen(order: order),
                      );
                    },
                    child: const Text('Assign to Production'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBOMItem(JobOrderBillOfMaterial bom) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bom.productName,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            'Picked: ${bom.quantityPicked}/${bom.quantity} ${bom.unitOfMeasure}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          Text(
            'Location: ${bom.binLocation}',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/association/transfer/production_job_order/production_job_order_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/transfer/production_job_order/production_job_order_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Transfer/goods_issue/production_job_order/job_order_bom_details_screen.dart';

class JobOrderBomScreen extends StatefulWidget {
  final String jobOrderDetailsId;
  final String jobOrderNumber;

  const JobOrderBomScreen({
    super.key,
    required this.jobOrderDetailsId,
    required this.jobOrderNumber,
  });

  @override
  State<JobOrderBomScreen> createState() => _JobOrderBomScreenState();
}

class _JobOrderBomScreenState extends State<JobOrderBomScreen> {
  late ProductionJobOrderCubit _productionJobOrderCubit;

  @override
  void initState() {
    super.initState();
    _productionJobOrderCubit = ProductionJobOrderCubit();
    _productionJobOrderCubit.getProductionJobOrderBom(widget.jobOrderDetailsId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Picklist Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.pink,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
        ),
        child: BlocBuilder<ProductionJobOrderCubit, ProductionJobOrderState>(
          bloc: _productionJobOrderCubit,
          builder: (context, state) {
            if (state is ProductionJobOrderBomLoading) {
              return _buildShimmer();
            }

            if (state is ProductionJobOrderBomError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            if (state is ProductionJobOrderBomLoaded) {
              if (state.bomItems.isEmpty) {
                return Center(
                  child: Card(
                    color: AppColors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined,
                              size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          const Text(
                            'No BOM items found',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.bomItems.length,
                itemBuilder: (context, index) {
                  final bom = state.bomItems[index];
                  final isPicked = bom.quantity == bom.quantityPicked ||
                      bom.status == 'picked';
                  return Card(
                    color: Colors.white,
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  bom.productName ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: bom.status == 'pending'
                                      ? Colors.orange
                                      : Colors.green,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  bom.status?.toUpperCase() ?? 'N/A',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(Icons.qr_code, 'Product ID',
                              bom.productId ?? 'N/A'),
                          _buildInfoRow(Icons.description, 'Description',
                              bom.productDescription ?? 'N/A'),
                          _buildInfoRow(Icons.shopping_basket, 'Quantity',
                              '${bom.quantity} ${bom.unitOfMeasure}'),
                          _buildInfoRow(Icons.check_circle_outline, 'Picked',
                              '${bom.quantityPicked}'),
                          _buildInfoRow(Icons.location_on, 'Location',
                              bom.binLocation ?? 'N/A'),
                          const SizedBox(height: 16),
                          Center(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (isPicked) return;
                                  // if Item is not picked
                                  context
                                      .read<ProductionJobOrderCubit>()
                                      .bomStartData = bom;
                                  AppNavigator.goToPage(
                                    context: context,
                                    screen: JobOrderBomDetailsScreen(
                                      barcode: bom.productId ?? '',
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isPicked
                                      ? AppColors.grey
                                      : AppColors.pink,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Start Picking',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(child: Text('No BOM items found'));
          },
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      height: 16,
                      color: Colors.white,
                    ),
                    Container(
                      width: 80,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...List.generate(
                    5,
                    (i) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 80,
                                height: 12,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 120,
                                height: 12,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )),
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

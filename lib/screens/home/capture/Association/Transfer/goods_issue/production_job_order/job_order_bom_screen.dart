import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/capture/association/transfer/production_job_order/production_job_order_cubit.dart';
import 'package:gtrack_nartec/blocs/capture/association/transfer/production_job_order/production_job_order_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';

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
        title: Text('BOM - ${widget.jobOrderNumber}'),
        backgroundColor: AppColors.pink,
      ),
      body: BlocBuilder<ProductionJobOrderCubit, ProductionJobOrderState>(
        bloc: _productionJobOrderCubit,
        builder: (context, state) {
          if (state is ProductionJobOrderBomLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductionJobOrderBomError) {
            return Center(child: Text(state.message));
          }

          if (state is ProductionJobOrderBomLoaded) {
            return ListView.builder(
              itemCount: state.bomItems.length,
              itemBuilder: (context, index) {
                final bom = state.bomItems[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(bom.productName ?? 'N/A'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Product ID: ${bom.productId}'),
                        Text('Description: ${bom.productDescription ?? 'N/A'}'),
                        Text('Quantity: ${bom.quantity} ${bom.unitOfMeasure}'),
                        Text('Picked: ${bom.quantityPicked}'),
                        Text('Location: ${bom.binLocation ?? 'N/A'}'),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: bom.status == 'pending'
                                ? Colors.orange
                                : Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            bom.status?.toUpperCase() ?? 'N/A',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Add start picking logic here
                      },
                      child: const Text('Start'),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('No BOM items found'));
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/association/transfer/goods_receipt/job_order_cubit.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/goods_receipt/job_order/job_order_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Transfer/goods_receipt/job_order/job_order_scan_asset_screen.dart';

class JobOrderItemDetailsScreen extends StatefulWidget {
  final JobOrderModel order;
  const JobOrderItemDetailsScreen({super.key, required this.order});

  @override
  State<JobOrderItemDetailsScreen> createState() =>
      _JobOrderItemDetailsScreenState();
}

class _JobOrderItemDetailsScreenState extends State<JobOrderItemDetailsScreen> {
  final jobOrderCubit = JobOrderCubit();

  @override
  void initState() {
    super.initState();
    jobOrderCubit.getJobOrderBomDetails(widget.order.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Job Order Item Details'),
        backgroundColor: AppColors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<JobOrderCubit, JobOrderState>(
                bloc: jobOrderCubit,
                builder: (context, state) {
                  if (state is JobOrderDetailsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is JobOrderDetailsError) {
                    return Center(child: Text(state.message));
                  }
                  return ListView.builder(
                    itemCount: jobOrderCubit.items.length,
                    itemBuilder: (context, index) => buildJobOrderItemDetails(
                        jobOrderCubit.items[index], index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          spacing: 8.0,
          children: [
            Expanded(
              child: PrimaryButtonWidget(
                text: "Back",
                onPressed: () {},
                backgroungColor: AppColors.danger,
              ),
            ),
            Expanded(
              flex: 2,
              child: BlocListener<JobOrderCubit, JobOrderState>(
                listener: (context, state) {
                  if (state is AddToProductionError) {
                    AppSnackbars.danger(context, state.message);
                  }
                },
                child: PrimaryButtonWidget(
                  text: "Assign to Production",
                  onPressed: () {
                    JobOrderCubit.get(context).addToProduction();
                  },
                  backgroungColor: AppColors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildJobOrderItemDetails(JobOrderBillOfMaterial bom, int index) {
    final picked =
        (bom.quantityPicked != bom.quantityPicked) && bom.status != 'picked';
    return GestureDetector(
      onTap: () {
        jobOrderCubit.selectJobOrderItem(index);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: bom.isSelected == 1 ? AppColors.pink : AppColors.grey,
              width: bom.isSelected == 1 ? 2.0 : 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8.0,
            children: [
              Text(bom.productId, style: TextStyle(fontSize: 16)),
              Text(
                bom.productName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildRow('Unit of measure', bom.unitOfMeasure),
              _buildRow('Quantity', bom.quantity.toString()),
              _buildRow('Quantity picked', bom.quantityPicked.toString()),
              _buildRow('Bin location', bom.binLocation),
              _buildRow('Status', bom.status, status: true),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(flex: 3, child: Container()),
                  Expanded(
                    child: PrimaryButtonWidget(
                      text: "Start",
                      onPressed: () {
                        if (!picked) {
                          // navigate to scan asset screen
                          AppNavigator.goToPage(
                            context: context,
                            screen: JobOrderScanAssetScreen(),
                          );
                        }
                        return;
                      },
                      backgroungColor: picked ? AppColors.grey : AppColors.pink,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String a, String b, {bool status = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(a),
        Text(b,
            style: TextStyle(
              fontWeight: status ? FontWeight.bold : null,
              color: status
                  ? b == "picked"
                      ? AppColors.green
                      : AppColors.pink
                  : null,
            )),
      ],
    );
  }
}

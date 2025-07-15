import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/features/capture/cubits/association_internal_goodsIssue_productionJobOrder/production_job_order_cubit.dart';
import 'package:gtrack_nartec/features/capture/cubits/association_internal_goodsIssue_productionJobOrder/production_job_order_state.dart';
import 'package:gtrack_nartec/features/capture/view/association_internal_goodsIssue_productionJobOrder/job_order_bom_details_screen.dart';
import 'package:gtrack_nartec/features/capture/view/association_internal_goodsIssue_productionJobOrder/widgets/empty_state_widget.dart';
import 'package:gtrack_nartec/features/capture/view/association_internal_goodsIssue_productionJobOrder/widgets/error_state_widget.dart';
import 'package:gtrack_nartec/features/capture/view/association_internal_goodsIssue_productionJobOrder/widgets/info_row_widget.dart';
import 'package:gtrack_nartec/features/capture/view/association_internal_goodsIssue_productionJobOrder/widgets/shimmer_loading_widget.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';

class GoodsIssueJobOrderDetailsScreen extends StatefulWidget {
  final String jobOrderDetailsId;
  final String jobOrderNumber;

  const GoodsIssueJobOrderDetailsScreen({
    super.key,
    required this.jobOrderDetailsId,
    required this.jobOrderNumber,
  });

  @override
  State<GoodsIssueJobOrderDetailsScreen> createState() =>
      _GoodsIssueJobOrderDetailsScreenState();
}

class _GoodsIssueJobOrderDetailsScreenState
    extends State<GoodsIssueJobOrderDetailsScreen> {
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
              return const ShimmerLoadingWidget();
            }

            if (state is ProductionJobOrderBomError) {
              return ErrorStateWidget(message: state.message);
            }

            if (state is ProductionJobOrderBomLoaded) {
              if (state.bomItems.isEmpty) {
                return const EmptyStateWidget(
                  message: 'No Order Details Found!',
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
                    elevation: 8,
                    margin: const EdgeInsets.only(bottom: 20),
                    color: Colors.white,
                    shadowColor: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: Colors.grey.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            Colors.grey.shade50,
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: bom.status == 'pending'
                                        ? Colors.orange.shade400
                                        : Colors.green.shade400,
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (bom.status == 'pending'
                                                ? Colors.orange
                                                : Colors.green)
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
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
                            const SizedBox(height: 16),
                            InfoRowWidget(
                              icon: Icons.qr_code,
                              label: 'Product ID',
                              value: bom.productId ?? 'N/A',
                            ),
                            InfoRowWidget(
                              icon: Icons.description,
                              label: 'Description',
                              value: bom.productDescription ?? 'N/A',
                            ),
                            InfoRowWidget(
                              icon: Icons.shopping_basket,
                              label: 'Quantity',
                              value: '${bom.quantity} ${bom.unitOfMeasure}',
                            ),
                            InfoRowWidget(
                              icon: Icons.check_circle_outline,
                              label: 'Picked',
                              value: '${bom.quantityPicked}',
                            ),
                            InfoRowWidget(
                              icon: Icons.location_on,
                              label: 'Location',
                              value: bom.binLocation ?? 'N/A',
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.pink.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: PrimaryButtonWidget(
                                text: "Start Picking",
                                backgroundColor: AppColors.pink,
                                height: 45,
                                onPressed: () {
                                  if (isPicked) return;
                                  // if Item is not picked
                                  context
                                      .read<ProductionJobOrderCubit>()
                                      .jobOrderDetail = bom;
                                  AppNavigator.goToPage(
                                    context: context,
                                    screen: JobOrderBomDetailsScreen(
                                      barcode: bom.productId ?? '',
                                    ),
                                  );
                                },
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

            return const Center(child: Text('No BOM items found'));
          },
        ),
      ),
    );
  }
}

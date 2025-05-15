import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/features/capture/cubits/association_internal_goodsIssue_productionJobOrder/production_job_order_cubit.dart';
import 'package:gtrack_nartec/features/capture/cubits/association_internal_goodsIssue_productionJobOrder/production_job_order_state.dart';
import 'package:gtrack_nartec/features/capture/view/association_internal_goodsIssue_productionJobOrder/goods_issue_job_order_details_screen.dart';
import 'package:gtrack_nartec/features/capture/view/association_internal_goodsIssue_productionJobOrder/widgets/job_order_card.dart';
import 'package:gtrack_nartec/features/capture/view/association_internal_goodsIssue_productionJobOrder/widgets/shimmer_loading_widget.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/widgets/text_field/text_form_field_widget.dart';

class GoodsIssueJobOrdersScreen extends StatefulWidget {
  const GoodsIssueJobOrdersScreen({super.key});

  @override
  State<GoodsIssueJobOrdersScreen> createState() =>
      _GoodsIssueJobOrdersScreenState();
}

class _GoodsIssueJobOrdersScreenState extends State<GoodsIssueJobOrdersScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final ProductionJobOrderCubit _productionJobOrderCubit;

  @override
  void initState() {
    super.initState();
    _productionJobOrderCubit = ProductionJobOrderCubit();
    _productionJobOrderCubit.getProductionJobOrders();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _productionJobOrderCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _productionJobOrderCubit,
      child: Scaffold(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormFieldWidget(
                        controller: _searchController,
                        hintText: "Search job orders",
                        onChanged: (value) {
                          _productionJobOrderCubit
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
                      return const ShimmerLoadingWidget(itemCount: 5);
                    }

                    if (state is ProductionJobOrderError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 60,
                              color: AppColors.pink.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is ProductionJobOrderLoaded) {
                      if (state.orders.isEmpty) {
                        return const Center(
                          child: Text("No job orders found"),
                        );
                      }

                      return ListView.builder(
                        itemCount: state.orders.length,
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          final order = state.orders[index];
                          return JobOrderCard(
                            order: order,
                            status: order.status ?? "NA",
                            onTap: () {
                              // Store order in cubit for details screen
                              _productionJobOrderCubit.order = order;
                              AppNavigator.goToPage(
                                context: context,
                                screen: GoodsIssueJobOrderDetailsScreen(
                                  jobOrderDetailsId: order.id!,
                                  jobOrderNumber:
                                      order.jobOrderMaster?.jobOrderNumber ??
                                          'N/A',
                                ),
                              );
                            },
                          );
                        },
                      );
                    }

                    return const Center(child: Text("No job orders found"));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

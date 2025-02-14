import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/capture/association/transfer/production_job_order/production_job_order_cubit.dart';
import 'package:gtrack_nartec/blocs/capture/association/transfer/production_job_order/production_job_order_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/ProductionJobOrder/production_job_order.dart';
import 'package:intl/intl.dart';

class ProductionJobOrderScreen extends StatefulWidget {
  const ProductionJobOrderScreen({super.key});

  @override
  State<ProductionJobOrderScreen> createState() =>
      _ProductionJobOrderScreenState();
}

class _ProductionJobOrderScreenState extends State<ProductionJobOrderScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductionJobOrderCubit>().getProductionJobOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Production Job Order"),
        backgroundColor: AppColors.pink,
      ),
      body: Column(
        children: [
          Expanded(
            child:
                BlocConsumer<ProductionJobOrderCubit, ProductionJobOrderState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                if (state is ProductionJobOrderLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ProductionJobOrderError) {
                  return Center(child: Text(state.message));
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
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.0,
        children: [
          Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Order Date: ",
                      style: TextStyle(fontSize: 12, color: AppColors.black),
                    ),
                    TextSpan(
                      text:
                          "\t${DateFormat('dd-MM-yyyy').format(DateTime.parse(order.jobOrderMaster?.orderDate ?? ''))}",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: order.jobOrderMaster?.status == "pending"
                      ? AppColors.skyBlue
                      : AppColors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Status: ",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.white,
                        ),
                      ),
                      TextSpan(
                        text: order.jobOrderMaster?.status,
                        style: TextStyle(
                          fontSize: 12,
                          color: order.jobOrderMaster?.status == "pending"
                              ? AppColors.white
                              : AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Text(
            order.jobOrderMaster?.jobOrderNumber ?? "N/A",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Total Items: ",
                      style: TextStyle(fontSize: 12, color: AppColors.black),
                    ),
                    TextSpan(
                      text: order.quantity ?? "N/A",
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Total Cost: ",
                      style: TextStyle(fontSize: 12, color: AppColors.black),
                    ),
                    TextSpan(
                      text: order.jobOrderMaster?.totalCost ?? "N/A",
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Delivery Date: ",
                      style: TextStyle(fontSize: 12, color: AppColors.black),
                    ),
                    TextSpan(
                      text:
                          "\t${DateFormat('dd-MM-yyyy').format(DateTime.parse(order.jobOrderMaster?.deliveryDate ?? ''))}",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.grey),
        ],
      ),
    );
  }
}

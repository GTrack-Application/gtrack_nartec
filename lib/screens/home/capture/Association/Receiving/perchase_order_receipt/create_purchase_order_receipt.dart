// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/association/receiving/purchase_order_receipt/purchase_order_receipt_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/receiving/purchase_order_receipt/purchase_order_receipt_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/purchase_order_receipt/purchase_order_details_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Receiving/perchase_order_receipt/save_purchase_order_screen.dart';
import 'package:intl/intl.dart';

class CreatePurchaseOrderReceiptScreen extends StatefulWidget {
  const CreatePurchaseOrderReceiptScreen({super.key});

  @override
  State<CreatePurchaseOrderReceiptScreen> createState() =>
      _CreatePurchaseOrderReceiptScreenState();
}

class _CreatePurchaseOrderReceiptScreenState
    extends State<CreatePurchaseOrderReceiptScreen> {
  final PurchaseOrderReceiptCubit cubit = PurchaseOrderReceiptCubit();
  final List<PurchaseOrderDetailsModel> purchaseOrderDetails = [];
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.pink,
        title: const Text('Create Purchase Order Receipt'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocConsumer<PurchaseOrderReceiptCubit,
              PurchaseOrderReceiptState>(
            bloc: cubit,
            listener: (context, state) {
              if (state is PurchaseOrderDetailsLoaded) {
                setState(() {
                  purchaseOrderDetails.clear();
                  purchaseOrderDetails.addAll(state.purchaseOrderDetails);
                });
                print(
                    'Purchase Order Details loaded: ${purchaseOrderDetails.length}');
              } else if (state is PurchaseOrderReceiptError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message.replaceAll('Exception: ', '')),
                    backgroundColor: AppColors.pink,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is PurchaseOrderDetailsLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.pink,
                  ),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: TextField(
                              controller: searchController,
                              onSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  cubit.handleSearch(value.trim());
                                }
                              },
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search Purchase Order Number',
                                hintStyle: const TextStyle(
                                  color: AppColors.grey,
                                ),
                                filled: true,
                                fillColor: AppColors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: AppColors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.pink,
                            foregroundColor: AppColors.white,
                          ),
                          onPressed: () {
                            cubit.handleSearch(searchController.text.trim());
                          },
                          child: const Text('Search'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    state is PurchaseOrderDetailsFilterLoaded
                        ? state.purchaseOrderDetails.isNotEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.grey),
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.purchaseOrderDetails.length,
                                  itemBuilder: (context, index) {
                                    final order =
                                        state.purchaseOrderDetails[index];
                                    return Column(
                                      children: [
                                        Card(
                                          color: Colors.white,
                                          margin: const EdgeInsets.all(8),
                                          shadowColor: _getStatusColor(
                                              order.status ?? ''),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            side: BorderSide(
                                              color: _getStatusColor(
                                                  order.status ?? ''),
                                              width: 1,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Purchase Order Number',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Text(
                                                      order.purchaseOrderNumber ??
                                                          '',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 16),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'GDTI',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Text(
                                                      order.gdti ?? '',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 16),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Status',
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.yellow
                                                                .shade100,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          child: Text(
                                                            order.status ??
                                                                'pending',
                                                            style:
                                                                const TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Total Amount',
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        Text(
                                                          'SAR ${order.totalAmount ?? '0.00'}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          margin: const EdgeInsets.all(8),
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: AppColors.grey),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          order
                                                                  .purchaseOrderDetails
                                                                  ?.first
                                                                  .productId ??
                                                              '',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        Text(
                                                          order
                                                                  .purchaseOrderDetails
                                                                  ?.first
                                                                  .productName ??
                                                              '',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 16),
                                              Column(
                                                children: [
                                                  _buildInfoColumn(
                                                      'Quantity:',
                                                      order.purchaseOrderDetails
                                                              ?.first.quantity
                                                              .toString() ??
                                                          ''),
                                                  const SizedBox(height: 8),
                                                  _buildInfoColumn('Price:',
                                                      'SAR ${order.purchaseOrderDetails?.first.price?.toString() ?? ''}'),
                                                  const SizedBox(height: 8),
                                                  _buildInfoColumn(
                                                      'Expected Delivery:',
                                                      order.deliveryDate != null
                                                          ? DateFormat(
                                                                  'M/d/yyyy')
                                                              .format(DateTime
                                                                  .parse(order
                                                                      .deliveryDate
                                                                      .toString()))
                                                          : ''),
                                                ],
                                              ),
                                              const SizedBox(height: 16),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          const Color(
                                                              0xFF000066),
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      AppNavigator.goToPage(
                                                        context: context,
                                                        screen: SavePurchaseOrderScreen(
                                                            purchaseOrderDetails:
                                                                order),
                                                      );
                                                    },
                                                    child: const Text(
                                                        'Process Receipt'),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 16),
                                              Divider(
                                                color: AppColors.grey,
                                                thickness: 1,
                                              ),
                                              const SizedBox(height: 16),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  onPressed: () {},
                                                  child: const Text('Cancel'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.grey),
                                ),
                                child: Column(
                                  children: [
                                    const Text('No Purchase Orders Found'),
                                  ],
                                ),
                              )
                        : state is PurchaseOrderDetailsLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.pink,
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.grey),
                                ),
                                child: Column(
                                  children: [
                                    // No Purchase Orders Found Message
                                    const Text(
                                      'No Purchase Orders Found',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2D3142),
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 32),
                                      child: Text(
                                        'Search for a purchase order by entering the PO number above or use the Retrieve POs button to view all available purchase orders.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF666666),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 32),

                                    // Instructions
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: AppColors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              '1. Enter PO number in the search box',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFFE31C79),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: AppColors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              '2. Click Search to view order details',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFFE31C79),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: AppColors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              '3. Select items to process receipt',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFFE31C79),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.skyBlue;
      case 'complete':
        return AppColors.green;
      case 'cancel':
        return Colors.red;
      default:
        return AppColors.pink;
    }
  }
}

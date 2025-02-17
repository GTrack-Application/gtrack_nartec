// ignore_for_file: deprecated_member_use, unrelated_type_equality_checks, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/association/receiving/purchase_order_receipt/purchase_order_receipt_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/receiving/purchase_order_receipt/purchase_order_receipt_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/purchase_order_receipt/purchase_order_details_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Receiving/perchase_order_receipt/receiving_by_pallet_serial_screen.dart';

class PurchaseOrderDetailsScreen extends StatefulWidget {
  const PurchaseOrderDetailsScreen({super.key});

  @override
  State<PurchaseOrderDetailsScreen> createState() =>
      _PurchaseOrderDetailsScreenState();
}

class _PurchaseOrderDetailsScreenState
    extends State<PurchaseOrderDetailsScreen> {
  final TextEditingController _poNumberController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _poNumberController.dispose();
  }

  List<PurchaseOrderDetailsModel> purchaseOrderDetails = [];
  PurchaseOrderDetailsModel? selectedItem;

  PurchaseOrderReceiptCubit cubit = PurchaseOrderReceiptCubit();

  String _formatDate(String? date) {
    if (date == null) return 'N/A';
    try {
      final DateTime parsedDate = DateTime.parse(date);
      return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    } catch (e) {
      return date; // Return original string if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.pink,
        title: const Text('Purchase Order Details'),
      ),
      body: BlocConsumer<PurchaseOrderReceiptCubit, PurchaseOrderReceiptState>(
        bloc: cubit,
        listener: (context, state) {
          if (state is PurchaseOrderDetailsLoaded) {
            purchaseOrderDetails = state.purchaseOrderDetails;

            Future.delayed(const Duration(milliseconds: 100), () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.white,
                  title: Text(
                    'Select Purchase Order',
                    style: TextStyle(
                      color: AppColors.pink,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: purchaseOrderDetails.length,
                      itemBuilder: (context, index) {
                        final item = purchaseOrderDetails[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Card(
                            shadowColor: Colors.grey,
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Order Date:\n${_formatDate(item.orderDate)}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: item.status == 'Shipped'
                                              ? Colors.green
                                              : item.status == 'Delivered'
                                                  ? Colors.green
                                                  : item.status == 'Pending'
                                                      ? Colors.yellow
                                                      : item.status ==
                                                              'Approved'
                                                          ? Colors.blue
                                                          : Colors.red[200],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          'Status: ${item.status}',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${item.purchaseOrderNumber}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Items: ${item.purchaseOrderDetails?.first.quantity}',
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      Text(
                                        'Total: SAR ${item.totalAmount ?? "0.00"}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (item.deliveryDate != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Expected Delivery: ${_formatDate(item.deliveryDate)}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  selectedItem = null;
                                  selectedItem = item;
                                });
                                Navigator.pop(context);
                              },
                              selected: selectedItem == item,
                              selectedTileColor:
                                  AppColors.pink.withOpacity(0.1),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            });
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Search Box and Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          controller: _poNumberController,
                          onEditingComplete: () async {
                            await cubit
                                .handleSearch(_poNumberController.text.trim());
                          },
                          decoration: const InputDecoration(
                            hintText: 'Enter Purchase Order Number',
                            hintStyle: TextStyle(
                              color: AppColors.grey,
                              fontSize: 12,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_poNumberController.text.isEmpty) {
                            return;
                          }
                          await cubit
                              .handleSearch(_poNumberController.text.trim());
                        },
                        style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFE31C79)),
                        child: const Text(
                          'Search',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Retrieve POs Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state is PurchaseOrderDetailsLoading
                        ? null
                        : () async {
                            await cubit.handleRetrievePOs();
                          },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: state is PurchaseOrderDetailsLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Retrieve POs',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 32),

                selectedItem != null
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.grey),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selected Purchase Order Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.pink,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                color: const Color(
                                    0xFFF3F4FA), // Light purple/blue background
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    selectedItem?.purchaseOrderNumber ?? "N/A",
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Order Date: ${_formatDate(selectedItem?.orderDate)}',
                                    style: const TextStyle(
                                      fontSize: 13.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Product Id:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(selectedItem?.purchaseOrderDetails?.first
                                        .productId ??
                                    "N/A"),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Product Name:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(selectedItem?.purchaseOrderDetails?.first
                                        .productName ??
                                    "N/A"),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Unit of Measure:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(selectedItem?.purchaseOrderDetails?.first
                                        .unitOfMeasure ??
                                    "N/A"),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Quantity:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(selectedItem?.purchaseOrderDetails?.first
                                        .quantity ??
                                    "0"),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Price:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    'SAR ${selectedItem?.purchaseOrderDetails?.first.price ?? "0.00"}'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FilledButton(
                                  onPressed: () {
                                    AppNavigator.goToPage(
                                      context: context,
                                      screen: ReceivingByPalletSerialScreen(
                                        purchaseOrderDetails: selectedItem!,
                                      ),
                                    );
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                  ),
                                  child: const Text(
                                    'Receive',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                              padding: EdgeInsets.symmetric(horizontal: 32),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: AppColors.grey),
                                      borderRadius: BorderRadius.circular(8),
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
                                      border: Border.all(color: AppColors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '2. Click Search or Retrieve POs',
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

                const Spacer(),

                // Bottom Buttons
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              // Implement cancel functionality
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE53935)),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              // Implement continue functionality
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CAF50)),
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
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
    );
  }
}

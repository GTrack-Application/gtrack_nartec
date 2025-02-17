import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/association/receiving/purchase_order_receipt/purchase_order_receipt_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/receiving/purchase_order_receipt/purchase_order_receipt_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/purchase_order_receipt/pallet_number_details_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/purchase_order_receipt/purchase_order_details_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Receiving/perchase_order_receipt/create_batch_serial_screen.dart';

class ReceivingByPalletSerialScreen extends StatefulWidget {
  const ReceivingByPalletSerialScreen({
    super.key,
    required this.purchaseOrderDetails,
  });

  final PurchaseOrderDetailsModel purchaseOrderDetails;

  @override
  State<ReceivingByPalletSerialScreen> createState() =>
      _ReceivingByPalletSerialScreenState();
}

class _ReceivingByPalletSerialScreenState
    extends State<ReceivingByPalletSerialScreen> {
  bool isPalletSelected = true; // Default to BY PALLETE option

  List<PalletNumberDetailsModel> palletNumberDetails = [];

  TextEditingController palletNumberController = TextEditingController();
  FocusNode palletNumberFocusNode = FocusNode();

  PurchaseOrderReceiptCubit cubit = PurchaseOrderReceiptCubit();

  String selectedItemType = '';
  bool isBatchAvailable = false;

  @override
  void dispose() {
    palletNumberController.dispose();
    palletNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pink,
        title: Text('Receiving by ${isPalletSelected ? 'Pallet' : 'Serial'}'),
      ),
      body: BlocConsumer<PurchaseOrderReceiptCubit, PurchaseOrderReceiptState>(
        bloc: cubit,
        listener: (context, state) {
          if (state is PalletNumberDetailsLoaded) {
            palletNumberDetails.addAll(state.palletNumberDetails);

            palletNumberController.clear();
            palletNumberFocusNode.unfocus();

            // show a snackbar to show the message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Pallet Code Validated Successfully"),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(16),
              ),
            );
          } else if (state is PalletNumberDetailsError) {
            // isBatchSelected will be true here
            isBatchAvailable = true;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message.replaceAll('Exception: ', ''),
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(16),
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // GTIN Header
                  Text(
                    'GTIN : ${widget.purchaseOrderDetails.purchaseOrderDetails!.first.productId}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "\"${widget.purchaseOrderDetails.purchaseOrderDetails!.first.productName}\"",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quantity Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('Quantity'),
                                Text('*', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                            Text(
                                widget.purchaseOrderDetails
                                    .purchaseOrderDetails!.first.quantity
                                    .toString(),
                                style: Theme.of(context).textTheme.titleLarge),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('Received Quantity'),
                                Text('*', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                            Text('0',
                                style: Theme.of(context).textTheme.titleLarge),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Radio Buttons
                  Row(
                    children: [
                      Radio(
                        value: true,
                        groupValue: isPalletSelected,
                        fillColor: WidgetStateProperty.all(AppColors.pink),
                        onChanged: (value) =>
                            setState(() => isPalletSelected = value!),
                      ),
                      const Text('BY PALLETE'),
                      const SizedBox(width: 24),
                      Radio(
                        value: false,
                        groupValue: isPalletSelected,
                        hoverColor: Colors.grey,
                        fillColor: WidgetStateProperty.all(Colors.grey),
                        onChanged: (value) {},
                      ),
                      Text(
                        'BY SERIAL',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Scan Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Scan Pallete#',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text('*', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                border: Border.all(color: AppColors.primary),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                onSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    cubit.searchPalletNumber(value.trim());
                                  }
                                },
                                controller: palletNumberController,
                                focusNode: palletNumberFocusNode,
                                decoration: InputDecoration(
                                  hintText: 'Enter/Scan Pallete Number',
                                  hintStyle: TextStyle(fontSize: 14),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              if (isPalletSelected &&
                                  palletNumberController.text.isNotEmpty) {
                                cubit.searchPalletNumber(
                                    palletNumberController.text.trim());
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                border: Border.all(color: AppColors.primary),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: state is PalletNumberDetailsLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Icon(Icons.qr_code_scanner,
                                      color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Item Type Selection
                  Visibility(
                    visible: isBatchAvailable,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Item Type',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Radio(
                                value: 'batch',
                                groupValue: selectedItemType,
                                onChanged: (value) => setState(
                                    () => selectedItemType = value as String),
                                fillColor:
                                    WidgetStateProperty.all(AppColors.primary),
                              ),
                              const Text('Batch'),
                              const SizedBox(width: 32),
                              Radio(
                                value: 'serial',
                                groupValue: selectedItemType,
                                onChanged: (value) => setState(
                                    () => selectedItemType = value as String),
                                fillColor:
                                    WidgetStateProperty.all(AppColors.primary),
                              ),
                              const Text('Serial'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: selectedItemType.isNotEmpty
                                  ? () {
                                      if (palletNumberController.text.isEmpty) {
                                        // show a dialog to select the batch
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Please enter a pallet code first'),
                                          ),
                                        );
                                      } else {
                                        AppNavigator.goToPage(
                                          context: context,
                                          screen: CreateBatchSerialScreen(
                                            purchaseOrderDetails:
                                                widget.purchaseOrderDetails,
                                            itemType: selectedItemType,
                                            palletNo: palletNumberController
                                                .text
                                                .toString()
                                                .trim(),
                                          ),
                                        );
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Continue',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // No Items Section
                  Container(
                    width: double.infinity,
                    height: 400,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        //Row for batch and serial
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                'Scanned Items (${palletNumberDetails.length}) Pallet',
                                style: Theme.of(context).textTheme.bodySmall),
                            TextButton(
                              onPressed: () {
                                palletNumberDetails.clear();
                                setState(() {});
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: Text('Clear All'),
                            ),
                          ],
                        ),
                        Expanded(
                          child: palletNumberDetails.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.inventory_2_outlined,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No Items Scanned',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Scan a pallet code to get started',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: palletNumberDetails.length +
                                      (state is PalletNumberDetailsLoading
                                          ? 1
                                          : 0),
                                  itemBuilder: (context, index) {
                                    if (index == palletNumberDetails.length) {
                                      return const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: palletNumberDetails[index]
                                                    .itemType ==
                                                "batch"
                                            ? Colors.green.shade50
                                            : palletNumberDetails[index]
                                                        .itemType ==
                                                    "serial"
                                                ? Colors.blue.shade50
                                                : Colors.grey.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: palletNumberDetails[index]
                                                      .itemType ==
                                                  "batch"
                                              ? Colors.green
                                              : palletNumberDetails[index]
                                                          .itemType ==
                                                      "serial"
                                                  ? Colors.blue
                                                  : Colors.grey,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            palletNumberDetails[index]
                                                    .productName ??
                                                'Product Name',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Item Code: ${palletNumberDetails[index].productId ?? ''}',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _buildInfoItem(
                                                  'GTIN',
                                                  palletNumberDetails[index]
                                                          .productId ??
                                                      '',
                                                ),
                                              ),
                                              Expanded(
                                                child: _buildInfoItem(
                                                  'Barcode',
                                                  palletNumberDetails[index]
                                                          .palletNumber ??
                                                      '',
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _buildInfoItem(
                                                  'Quantity',
                                                  palletNumberDetails[index]
                                                          .quantity
                                                          ?.toString() ??
                                                      '0',
                                                ),
                                              ),
                                              Expanded(
                                                child: _buildInfoItem(
                                                  'Received',
                                                  palletNumberDetails[index]
                                                          .receivedQuantity
                                                          ?.toString() ??
                                                      '0',
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _buildInfoItem(
                                                  'Net Weight',
                                                  palletNumberDetails[index]
                                                          .netWeight ??
                                                      '0',
                                                ),
                                              ),
                                              Expanded(
                                                child: _buildInfoItem(
                                                  'Expiry Date',
                                                  palletNumberDetails[index]
                                                          .expiryDate ??
                                                      '',
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          _buildInfoItem(
                                            'Pallet Code',
                                            palletNumberDetails[index]
                                                    .palletNumber ??
                                                '',
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

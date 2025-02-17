import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/association/receiving/purchase_order_receipt/purchase_order_receipt_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/receiving/purchase_order_receipt/purchase_order_receipt_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/purchase_order_receipt/purchase_order_details_model.dart';
import 'package:intl/intl.dart';

class CreateBatchSerialScreen extends StatefulWidget {
  const CreateBatchSerialScreen({
    super.key,
    required this.purchaseOrderDetails,
    required this.itemType,
    required this.palletNo,
  });

  final PurchaseOrderDetailsModel purchaseOrderDetails;
  final String itemType;
  final String palletNo;

  @override
  State<CreateBatchSerialScreen> createState() =>
      _CreateBatchSerialScreenState();
}

class _CreateBatchSerialScreenState extends State<CreateBatchSerialScreen> {
  // Text field controllers
  final TextEditingController batchNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController netWeightController = TextEditingController();
  final TextEditingController sourceGlnController = TextEditingController();
  final TextEditingController destinationGlnController =
      TextEditingController();
  final TextEditingController shipmentDateController = TextEditingController();
  final TextEditingController expectedDeliveryDateController =
      TextEditingController();

  final FocusNode batchNumberFocusNode = FocusNode();
  final FocusNode expiryDateFocusNode = FocusNode();
  final FocusNode netWeightFocusNode = FocusNode();
  final FocusNode sourceGlnFocusNode = FocusNode();
  final FocusNode destinationGlnFocusNode = FocusNode();
  final FocusNode shipmentDateFocusNode = FocusNode();
  final FocusNode expectedDeliveryDateFocusNode = FocusNode();

  @override
  void dispose() {
    batchNumberController.dispose();
    expiryDateController.dispose();
    netWeightController.dispose();
    sourceGlnController.dispose();
    destinationGlnController.dispose();
    shipmentDateController.dispose();
    expectedDeliveryDateController.dispose();
    batchNumberFocusNode.dispose();
    expiryDateFocusNode.dispose();
    netWeightFocusNode.dispose();
    sourceGlnFocusNode.dispose();
    destinationGlnFocusNode.dispose();
    shipmentDateFocusNode.dispose();
    expectedDeliveryDateFocusNode.dispose();
    super.dispose();
  }

  PurchaseOrderReceiptCubit cubit = PurchaseOrderReceiptCubit();

  String formatDateForDisplay(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String formatDateForApi(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String convertDisplayDateToApiFormat(String? displayDate) {
    if (displayDate == null || displayDate.isEmpty) return '';
    try {
      final date = DateFormat('dd/MM/yyyy').parse(displayDate);
      return formatDateForApi(date);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.pink,
        title: Text('Create Batch Serial'),
      ),
      body: BlocConsumer<PurchaseOrderReceiptCubit, PurchaseOrderReceiptState>(
        bloc: cubit,
        listener: (context, state) {
          if (state is CreateBatchSerialLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                duration: const Duration(seconds: 2),
                content: const Text('Batch serial created successfully'),
              ),
            );
            Navigator.pop(context);
          } else if (state is CreateBatchSerialError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                duration: const Duration(seconds: 2),
                content: Text(state.message.replaceAll('Exception:', '')),
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
                  const SizedBox(height: 10),

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
                            Text(
                                widget.purchaseOrderDetails
                                        .purchaseOrderDetails![0].quantity ??
                                    "0",
                                style: Theme.of(context).textTheme.titleLarge),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.itemType == "batch" ? "Batch" : "Serial",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Form Fields
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Batch/Lot Number
                      const Text(
                        'BATCH / LOT NUMBER',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: batchNumberController,
                        focusNode: batchNumberFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Enter batch number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onEditingComplete: () {
                          batchNumberFocusNode.unfocus();
                          expiryDateFocusNode.requestFocus();
                        },
                      ),
                      const SizedBox(height: 10),

                      // Expiry Date
                      const Text(
                        'EXPIRY DATE',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: expiryDateController,
                        focusNode: expiryDateFocusNode,
                        onEditingComplete: () {
                          expiryDateFocusNode.unfocus();
                          netWeightFocusNode.requestFocus();
                        },
                        decoration: InputDecoration(
                          hintText: 'dd/mm/yyyy',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () async {
                              DateTime now = DateTime.now();
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: now,
                                firstDate: now,
                                lastDate: DateTime(now.year + 10),
                              );

                              if (picked != null) {
                                expiryDateController.text =
                                    DateFormat('dd/MM/yyyy').format(picked);
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Net Weight
                      const Text(
                        'NET WEIGHT',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: netWeightController,
                        focusNode: netWeightFocusNode,
                        onEditingComplete: () {
                          netWeightFocusNode.unfocus();
                          sourceGlnFocusNode.requestFocus();
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter net weight',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Source GLN
                      Row(
                        children: [
                          const Text(
                            'SOURCE GLN',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          Text(
                            '*',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: sourceGlnController,
                        focusNode: sourceGlnFocusNode,
                        onEditingComplete: () {
                          sourceGlnFocusNode.unfocus();
                          destinationGlnFocusNode.requestFocus();
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter source GLN',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Destination GLN
                      Row(
                        children: [
                          const Text(
                            'DESTINATION GLN',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          Text(
                            '*',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: destinationGlnController,
                        focusNode: destinationGlnFocusNode,
                        onEditingComplete: () {
                          destinationGlnFocusNode.unfocus();
                          shipmentDateFocusNode.requestFocus();
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter destination GLN',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Shipment Date
                      Row(
                        children: [
                          const Text(
                            'SHIPMENT DATE',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          Text(
                            '*',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: shipmentDateController,
                        focusNode: shipmentDateFocusNode,
                        onEditingComplete: () {
                          shipmentDateFocusNode.unfocus();
                          expectedDeliveryDateFocusNode.requestFocus();
                        },
                        decoration: InputDecoration(
                          hintText: 'dd/mm/yyyy',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () async {
                              DateTime now = DateTime.now();
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: now,
                                firstDate: now.subtract(Duration(days: 365)),
                                lastDate: now.add(Duration(days: 365)),
                              );

                              if (picked != null) {
                                shipmentDateController.text =
                                    DateFormat('dd/MM/yyyy').format(picked);
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Expected Delivery Date
                      Row(
                        children: [
                          const Text(
                            'EXPECTED DELIVERY DATE',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          Text(
                            '*',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: expectedDeliveryDateController,
                        focusNode: expectedDeliveryDateFocusNode,
                        onEditingComplete: () {
                          expectedDeliveryDateFocusNode.unfocus();
                        },
                        decoration: InputDecoration(
                          hintText: 'dd/mm/yyyy',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () async {
                              DateTime now = DateTime.now();
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: now,
                                firstDate: now,
                                lastDate: now.add(Duration(days: 365)),
                              );

                              if (picked != null) {
                                expectedDeliveryDateController.text =
                                    DateFormat('dd/MM/yyyy').format(picked);
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Action Buttons
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Back',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (batchNumberController.text.isNotEmpty ||
                                      expiryDateController.text.isNotEmpty ||
                                      netWeightController.text.isNotEmpty ||
                                      sourceGlnController.text.isNotEmpty ||
                                      destinationGlnController
                                          .text.isNotEmpty ||
                                      shipmentDateController.text.isNotEmpty ||
                                      expectedDeliveryDateController
                                          .text.isNotEmpty) {
                                    await cubit.createBatchSerial(
                                      widget.purchaseOrderDetails,
                                      widget.itemType,
                                      widget.palletNo,
                                      batchNumberController.text.trim(),
                                      convertDisplayDateToApiFormat(
                                          expiryDateController.text.trim()),
                                      netWeightController.text.trim(),
                                      sourceGlnController.text.trim(),
                                      destinationGlnController.text.trim(),
                                      convertDisplayDateToApiFormat(
                                          shipmentDateController.text.trim()),
                                      convertDisplayDateToApiFormat(
                                          expectedDeliveryDateController.text
                                              .trim()),
                                    );

                                    print("Pallet No: ${widget.palletNo}");
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                        duration: Duration(seconds: 2),
                                        content: Text('Please fill all fields'),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: state is CreateBatchSerialLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Save',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

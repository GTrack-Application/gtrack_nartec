import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/association/transfer/production_job_order/production_job_order_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/transfer/production_job_order/production_job_order_state.dart';
import 'package:gtrack_nartec/cubit/capture/capture_cubit.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_nartec/global/widgets/text_field/text_form_field_widget.dart';
import 'package:gtrack_nartec/models/capture/serialization/serialization_model.dart';

class PackagingScanItemScreen extends StatefulWidget {
  const PackagingScanItemScreen({super.key});

  @override
  State<PackagingScanItemScreen> createState() =>
      _PackagingScanItemScreenState();
}

class _PackagingScanItemScreenState extends State<PackagingScanItemScreen> {
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? selectedBinLocation;
  String? selectedBatch;
  List<SerializationModel> scannedItems = [];
  Map<String, List<SerializationModel>> batchGroups = {};
  List<String> uniqueBatches = [];

  @override
  void initState() {
    super.initState();
    // Fetch bin locations when screen initializes
    context.read<ProductionJobOrderCubit>().getBinLocations();
    context.read<CaptureCubit>().scannedBarcodes.clear();
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _scanBarcode() {
    final barcode = _barcodeController.text.trim();
    if (barcode.isNotEmpty) {
      context.read<CaptureCubit>().getSerializationData(barcode);
    } else {
      AppSnackbars.danger(context, 'Please enter a barcode');
    }
  }

  void _showBatchDetailsDialog(BuildContext context, String batchName,
      List<SerializationModel> batchItems) {
    // Get the first item to extract common batch information
    final firstItem = batchItems.first;
    final expiryDate = firstItem.eXPIRYDATE != null
        ? DateTime.parse(firstItem.eXPIRYDATE!).toLocal()
        : null;
    final manufacturingDate = firstItem.mANUFACTURINGDATE != null
        ? DateTime.parse(firstItem.mANUFACTURINGDATE!).toLocal()
        : null;

    final TextEditingController recordsController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Batch Details: $batchName',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Available Items: ${batchItems.length}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Manufacturing Date: ${manufacturingDate != null ? "${manufacturingDate.day.toString().padLeft(2, '0')}/${manufacturingDate.month.toString().padLeft(2, '0')}/${manufacturingDate.year}" : "N/A"}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expiry Date: ${expiryDate != null ? "${expiryDate.day.toString().padLeft(2, '0')}/${expiryDate.month.toString().padLeft(2, '0')}/${expiryDate.year}" : "N/A"}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Stakeholder: N/A',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: recordsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Enter number of records to add',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Enter a number between 1 and ${batchItems.length}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Available Serial Numbers:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: batchItems.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: index % 2 == 0
                              ? Colors.grey.shade100
                              : Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          child: Text(
                            batchItems[index].serialNo ?? 'No Serial',
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CANCEL'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A1172),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          // Add records logic
                          final recordCount =
                              int.tryParse(recordsController.text);
                          if (recordCount != null &&
                              recordCount > 0 &&
                              recordCount <= batchItems.length) {
                            // Add the first 'recordCount' items to scannedItems
                            setState(() {
                              scannedItems =
                                  batchItems.take(recordCount).toList();
                            });
                            Navigator.pop(context);
                          } else {
                            // Show error
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please enter a valid number of records'),
                              ),
                            );
                          }
                        },
                        child: const Text('ADD RECORDS'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _processSerializationData(List<SerializationModel> data) {
    setState(() {
      // Clear previous data
      batchGroups.clear();
      uniqueBatches.clear();

      // Group items by batch
      for (var item in data) {
        if (item.bATCH != null) {
          if (!batchGroups.containsKey(item.bATCH)) {
            batchGroups[item.bATCH!] = [];
            uniqueBatches.add(item.bATCH!);
          }
          batchGroups[item.bATCH]!.add(item);
        }
      }

      // Reset selected batch
      selectedBatch = null;
      scannedItems = [];

      // Debug print to verify data
      print('Found ${uniqueBatches.length} unique batches');
      print('Batch groups: ${batchGroups.keys.join(', ')}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Item Barcode (GTIN)'),
        backgroundColor: AppColors.pink,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aggregation by Box/Carton',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),

            // Bin Location Dropdown
            const Text(
              'Suggested Bin Locations',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            BlocConsumer<ProductionJobOrderCubit, ProductionJobOrderState>(
              listener: (context, state) {
                if (state is ProductionJobOrderError) {
                  AppSnackbars.danger(context, state.message);
                }
              },
              builder: (context, state) {
                final binLocations =
                    context.read<ProductionJobOrderCubit>().binLocations;
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text('Select Bin Location'),
                      ),
                      value: selectedBinLocation,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      items: binLocations.map((location) {
                        return DropdownMenuItem<String>(
                          value: location.binNumber ?? '',
                          child: Text(
                            location.binNumber ?? '',
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedBinLocation = value;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Scan Barcode Field
            const Text(
              'Scan Barcode',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormFieldWidget(
                    controller: _barcodeController,
                    hintText: 'Enter/Scan Serial Number',
                    onFieldSubmitted: (value) => _scanBarcode(),
                    height: 40,
                  ),
                ),
                const SizedBox(width: 8),
                BlocBuilder<CaptureCubit, CaptureState>(
                  builder: (context, state) {
                    return CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.darkNavy,
                      child: state is CaptureSerializationLoading
                          ? const CircularProgressIndicator(
                              color: AppColors.white,
                              strokeWidth: 1,
                            )
                          : Center(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.qr_code_scanner,
                                  color: AppColors.white,
                                  size: 20,
                                ),
                                onPressed: _scanBarcode,
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Batch Selection - Only show after barcode is scanned
            BlocConsumer<CaptureCubit, CaptureState>(
              listener: (context, state) {
                if (state is CaptureSerializationSuccess) {
                  // Process the data when serialization is successful
                  _processSerializationData(state.data);

                  // Show success message
                  AppSnackbars.success(context, 'Items loaded successfully');
                } else if (state is CaptureSerializationError) {
                  AppSnackbars.danger(context, state.message);
                } else if (state is CaptureSerializationEmpty) {
                  AppSnackbars.warning(
                      context, 'No items found for this barcode');
                }
              },
              builder: (context, state) {
                return Visibility(
                  visible:
                      context.read<CaptureCubit>().scannedBarcodes.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Batch',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  hint: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.0),
                                    child: Text('Select Batch'),
                                  ),
                                  value: selectedBatch,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  items: uniqueBatches.map((batch) {
                                    return DropdownMenuItem<String>(
                                      value: batch,
                                      child: Text(batch),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedBatch = value;
                                      if (value != null &&
                                          batchGroups.containsKey(value)) {
                                        scannedItems = batchGroups[value]!;
                                      } else {
                                        scannedItems = [];
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkNavy,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(120, 56),
                            ),
                            onPressed: selectedBatch != null &&
                                    batchGroups.containsKey(selectedBatch)
                                ? () => _showBatchDetailsDialog(
                                      context,
                                      selectedBatch!,
                                      batchGroups[selectedBatch]!,
                                    )
                                : null,
                            child: const Text('VIEW DETAILS'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Box/Carton Description
            const Text(
              'Box/Carton Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Enter description for the box/carton',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Scanned Items Section
            Text(
              'Scanned Items (${scannedItems.length}) Serial',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            BlocConsumer<CaptureCubit, CaptureState>(
              listener: (context, state) {
                if (state is CaptureSerializationSuccess) {
                  // Process the data when serialization is successful
                  _processSerializationData(state.data);

                  // Show success message
                  AppSnackbars.success(context, 'Items loaded successfully');
                } else if (state is CaptureSerializationError) {
                  AppSnackbars.danger(context, state.message);
                } else if (state is CaptureSerializationEmpty) {
                  AppSnackbars.warning(
                      context, 'No items found for this barcode');
                }
              },
              builder: (context, state) {
                if (selectedBatch != null && scannedItems.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: scannedItems.length,
                    itemBuilder: (context, index) {
                      final item = scannedItems[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(item.serialNo ?? 'No Serial'),
                          subtitle: Text('Batch: ${item.bATCH ?? 'N/A'}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                scannedItems.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  );
                }

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'No Items Scanned Yet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Start by selecting a bin location and scanning items to add them to your aggregation list.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Instructions
                      _buildInstructionStep(
                          '1', 'Select a bin location from the dropdown'),
                      const SizedBox(height: 16),
                      _buildInstructionStep(
                          '2', 'Scan or enter the serial number'),
                      const SizedBox(height: 16),
                      _buildInstructionStep(
                          '3', 'Select the appropriate batch'),
                      const SizedBox(height: 16),
                      _buildInstructionStep('4', 'View scanned items below'),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Total Scanned
            Text(
              'Total Scanned: (${scannedItems.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: PrimaryButtonWidget(
                text: 'Cancel',
                onPressed: () {
                  Navigator.pop(context);
                },
                backgroundColor: Colors.red,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PrimaryButtonWidget(
                text: 'Save',
                onPressed: () {
                  // Implement save functionality
                  if (selectedBinLocation == null) {
                    AppSnackbars.danger(
                        context, 'Please select a bin location');
                    return;
                  }

                  if (scannedItems.isEmpty) {
                    AppSnackbars.danger(context, 'No items scanned');
                    return;
                  }

                  // Save logic here
                  AppSnackbars.success(context, 'Items saved successfully');
                },
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.primary),
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}

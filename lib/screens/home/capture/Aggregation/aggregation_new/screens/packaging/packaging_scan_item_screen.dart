import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/association/transfer/production_job_order/production_job_order_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/transfer/production_job_order/production_job_order_state.dart';
import 'package:gtrack_nartec/cubit/capture/capture_cubit.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/global/utils/date_time_format.dart';
import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_nartec/global/widgets/text_field/text_form_field_widget.dart';
import 'package:gtrack_nartec/models/capture/serialization/serialization_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/cubit/aggregation_cubit_v2.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/cubit/aggregation_state_v2.dart';

class PackagingScanItemScreen extends StatefulWidget {
  final String type;
  final bool isGtinPackaging;
  const PackagingScanItemScreen({
    super.key,
    required this.type,
    this.isGtinPackaging = false,
  });

  @override
  State<PackagingScanItemScreen> createState() =>
      _PackagingScanItemScreenState();
}

class _PackagingScanItemScreenState extends State<PackagingScanItemScreen> {
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Cubits
  late AggregationCubit cubit;
  late ProductionJobOrderCubit productionJobOrderCubit;
  late CaptureCubit captureCubit;

  @override
  void initState() {
    super.initState();
    initCubits();
  }

  void initCubits() {
    cubit = context.read<AggregationCubit>();
    productionJobOrderCubit = context.read<ProductionJobOrderCubit>();
    captureCubit = context.read<CaptureCubit>();

    // Fetch bin locations when screen initializes
    productionJobOrderCubit.getBinLocations();
    captureCubit.scannedBarcodes.clear();
    cubit.scannedItems.clear();
    cubit.selectedBatch = null;
    cubit.selectedBinLocation = null;
    cubit.selectedBinLocationId = null;
    cubit.batchGroups.clear();
    cubit.uniqueBatches.clear();
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
      captureCubit.getSerializationData(barcode);
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
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: AppColors.background,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gradient header
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.pink, AppColors.danger],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.batch_prediction,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Batch: $batchName',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Batch info cards
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      // Batch information cards
                      Row(
                        children: [
                          // Expiry date card
                          Expanded(
                            child: Card(
                              elevation: 2,
                              color: Colors.orange.shade50,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.event_available,
                                            color: Colors.orange.shade700),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: const Text(
                                            'Expiry Date',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      expiryDate != null
                                          ? formatDate(expiryDate)
                                          : 'N/A',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Manufacturing date card
                          Expanded(
                            child: Card(
                              elevation: 2,
                              color: Colors.blue.shade50,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.date_range,
                                            color: AppColors.primary),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: const Text(
                                            'Manufacturing Date',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      manufacturingDate == null
                                          ? "N/A"
                                          : formatDate(manufacturingDate),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Records input
                      Card(
                        color: AppColors.background,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.inventory_2,
                                    color: AppColors.green,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Records to Add',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              TextFormFieldWidget(
                                controller: recordsController,
                                hintText: 'Enter number of records',
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            icon: const Icon(Icons.cancel),
                            label: const Text('CANCEL'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            icon: const Icon(
                              Icons.add_circle,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'ADD RECORDS',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: AppColors.pink,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () {
                              final recordCount = int.tryParse(
                                recordsController.text,
                              );

                              if (recordCount != null &&
                                  recordCount > 0 &&
                                  recordCount <= batchItems.length) {
                                setState(() {
                                  // Take the first 'recordCount' items and append to scannedItems
                                  cubit.scannedItems.addAll(
                                    batchItems.take(recordCount).toList(),
                                  );
                                });
                                Navigator.pop(context);
                              } else {
                                // Show error
                                AppSnackbars.danger(
                                  context,
                                  'Please enter a valid number of records',
                                );
                              }
                            },
                          ),
                        ],
                      ),

                      // Serial numbers
                      Card(
                        color: AppColors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.format_list_numbered,
                                    color: Colors.pinkAccent,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Serial Numbers (${batchItems.length})',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),
                            Container(
                              constraints: const BoxConstraints(
                                maxHeight: 200,
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: batchItems.length,
                                itemBuilder: (context, index) {
                                  final item = batchItems[index];
                                  return Container(
                                    color: index % 2 == 0
                                        ? Colors.grey.shade50
                                        : Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.qr_code,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            item.serialNo ?? 'N/A',
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
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
              ],
            ),
          ),
        );
      },
    );
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
            Text(
              'Aggregation by ${widget.type}',
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
                final binLocations = productionJobOrderCubit.binLocations;
                return Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey),
                    borderRadius: BorderRadius.circular(4),
                    color: AppColors.background,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text('Select Bin Location'),
                      ),
                      value: context
                          .watch<AggregationCubit>()
                          .selectedBinLocationId,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      items: binLocations.map((location) {
                        return DropdownMenuItem<String>(
                          value: location.id,
                          child: Text(
                            "${location.binNumber}-${location.groupWarehouse} (${location.availableQty})",
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          cubit.setSelectedBinLocation(value);
                        }
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
                              color: Colors.white,
                              strokeWidth: 1,
                            )
                          : Center(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.qr_code_scanner,
                                  color: Colors.white,
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
                  cubit.processSerializationData(state.data);

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
                return BlocBuilder<AggregationCubit, AggregationState>(
                  builder: (context, aggState) {
                    final uniqueBatches = cubit.uniqueBatches;

                    return Visibility(
                      visible: uniqueBatches.isNotEmpty,
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
                                flex: 2,
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppColors.background,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      hint: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        child: Text('Select Batch'),
                                      ),
                                      value: cubit.selectedBatch,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      items: uniqueBatches.map((batch) {
                                        return DropdownMenuItem<String>(
                                          value: batch,
                                          child: Text(
                                            batch,
                                            style: const TextStyle(
                                              fontSize: 11,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          cubit.setSelectedBatch(value);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: PrimaryButtonWidget(
                                text: "Details",
                                height: 40,
                                backgroundColor: AppColors.darkNavy,
                                onPressed: cubit.selectedBatch != null &&
                                        cubit.batchGroups
                                            .containsKey(cubit.selectedBatch!)
                                    ? () => _showBatchDetailsDialog(
                                          context,
                                          cubit.selectedBatch!,
                                          cubit.batchGroups[
                                              cubit.selectedBatch]!,
                                        )
                                    : null,
                              ))
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            // Box/Carton Description
            Text(
              '${widget.type} Description',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextFormFieldWidget(
              controller: _descriptionController,
              hintText: 'Enter description for the box/carton',
              height: 40,
            ),
            const SizedBox(height: 24),

            // Scanned Items Section
            BlocBuilder<AggregationCubit, AggregationState>(
              builder: (context, state) {
                final scannedItems = cubit.scannedItems;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scanned Items (${scannedItems.length}) Serial',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    scannedItems.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 2,
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
                                _buildInstructionStep('1',
                                    'Select a bin location from the dropdown'),
                                const SizedBox(height: 16),
                                _buildInstructionStep(
                                    '2', 'Scan or enter the serial number'),
                                const SizedBox(height: 16),
                                _buildInstructionStep(
                                    '3', 'Select the appropriate batch'),
                                const SizedBox(height: 16),
                                _buildInstructionStep(
                                    '4', 'View scanned items below'),
                              ],
                            ),
                          )
                        : ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: scannedItems.length,
                            separatorBuilder: (context, index) => const Divider(
                                height: 1, color: Colors.transparent),
                            itemBuilder: (context, index) {
                              final item = scannedItems[index];
                              return buildScannedItemCard(item);
                            },
                          ),

                    // Total Scanned
                    const SizedBox(height: 24),
                    Text(
                      'Total Scanned: (${scannedItems.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              },
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
              child: BlocConsumer<AggregationCubit, AggregationState>(
                listener: (context, state) {
                  if (state is PackagingSaved) {
                    AppSnackbars.success(context, state.message);
                    if (widget.isGtinPackaging) {
                      cubit.fetchGtinPackaging(widget.type);
                    } else {
                      context.read<AggregationCubit>().getPackaging(
                            widget.type == "box_carton"
                                ? "box_carton"
                                : widget.type == "grouping"
                                    ? "grouping"
                                    : "batching",
                          );
                    }
                    Navigator.pop(context);
                  } else if (state is AggregationError) {
                    AppSnackbars.danger(context, state.message);
                  }
                },
                builder: (context, state) {
                  return PrimaryButtonWidget(
                    text: 'Save',
                    isLoading: state is AggregationLoading,
                    onPressed: () {
                      if (cubit.selectedBinLocationId == null) {
                        AppSnackbars.danger(
                            context, 'Please select a bin location');
                        return;
                      }

                      if (cubit.scannedItems.isEmpty) {
                        AppSnackbars.danger(context, 'No items scanned');
                        return;
                      }

                      // Save logic here
                      cubit.savePackaging(
                        _descriptionController.text,
                        type: widget.type,
                        isGtinPackaging: widget.isGtinPackaging,
                      );
                    },
                    backgroundColor: Colors.green,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildScannedItemCard(SerializationModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 1,
            blurRadius: 2,
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GTIN and Stakeholder
            Text(
              'GTIN: ${item.gTIN ?? "N/A"}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Stakeholder: N/A',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),

            // Serial No and Location
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Serial No',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.serialNo ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 15,
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
                        'Location',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.bATCH ?? 'N/A', // Add actual location if available
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Expiry Date and Manufacturing Date
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expiry Date',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.eXPIRYDATE != null
                            ? _formatDate(item.eXPIRYDATE!)
                            : 'N/A',
                        style: const TextStyle(
                          fontSize: 15,
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
                        'Manufacturing Date',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.mANUFACTURINGDATE != null
                            ? _formatDate(item.mANUFACTURINGDATE!)
                            : 'N/A',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(height: 32),

            // Record and Batch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Record #1',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Batch: ${item.bATCH ?? "N/A"}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        cubit.removeItem(item);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to format dates in DD/MM/YYYY format
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    } catch (e) {
      return dateString;
    }
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
            color: Colors.white,
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

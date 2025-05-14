import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/association/transfer/production_job_order/production_job_order_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/transfer/production_job_order/production_job_order_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_nartec/screens/home_screen.dart';

class JobOrderBomStartScreen2 extends StatefulWidget {
  const JobOrderBomStartScreen2({super.key});

  @override
  State<JobOrderBomStartScreen2> createState() =>
      _JobOrderBomStartScreen2State();
}

class _JobOrderBomStartScreen2State extends State<JobOrderBomStartScreen2> {
  final cubit = ProductionJobOrderCubit();
  final locationController = TextEditingController();
  final palletController = TextEditingController();
  final serialController = TextEditingController();
  String selectedType = 'pallet';

  @override
  void initState() {
    super.initState();
    setState(() {
      cubit.quantityPicked = cubit.bomStartData?.quantityPicked ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bom = context.watch<ProductionJobOrderCubit>().bomStartData;
    cubit.bomStartData = bom;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan By Serial | Pallet'),
        backgroundColor: AppColors.pink,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<ProductionJobOrderCubit, ProductionJobOrderState>(
            bloc: cubit,
            listener: (context, state) {
              if (state is ProductionJobOrderMappedBarcodesError) {
                AppSnackbars.danger(context, state.message);
              } else if (state is ProductionJobOrderMappedBarcodesLoaded) {
                // AppSnackbars.success(
                //   context,
                //   state.mappedBarcodes.message ?? '',
                // );
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quantity information
                  _buildInfoRow('Quantity:', '${bom?.quantity ?? 0}'),
                  const SizedBox(height: 8),
                  _buildInfoRow('Picked Quantity:', '${cubit.quantityPicked}'),
                  const SizedBox(height: 16),

                  // Radio Buttons for scanning mode
                  _buildScanTypeSelector(),
                  const SizedBox(height: 16),

                  // Conditional form based on selected type
                  if (selectedType == 'pallet')
                    _buildPalletForm()
                  else
                    _buildSerialForm(),
                  const SizedBox(height: 16),

                  // Scanned items display
                  //   if ((state is ProductionJobOrderMappedBarcodesError) ||
                  //       (state is ProductionJobOrderMappedBarcodesLoaded &&
                  //           state.mappedBarcodes.data?.isNotEmpty == true))
                  _buildScannedItems(),
                  const SizedBox(height: 16),

                  // WIP Location input
                  const Text("Scan WIP Location"),
                  TextFormField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      hintText: 'WIP Location',
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save button
                  _buildSaveButton(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Builds a simple information row with a label and value
  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(label),
        const SizedBox(width: 4),
        Text(value),
      ],
    );
  }

  /// Builds the scan type selector (Pallet vs Serial)
  Widget _buildScanTypeSelector() {
    return Row(
      children: [
        Radio<String>(
          value: 'pallet',
          groupValue: selectedType,
          onChanged: (value) {
            setState(() {
              selectedType = value!;
            });
          },
          activeColor: AppColors.pink,
        ),
        const Text('BY PALLET'),
        const SizedBox(width: 16),
        Radio<String>(
          value: 'serial',
          groupValue: selectedType,
          onChanged: (value) {
            setState(() {
              selectedType = value!;
            });
          },
          activeColor: AppColors.pink,
        ),
        const Text('BY SERIAL'),
      ],
    );
  }

  /// Builds the save button with validation logic
  Widget _buildSaveButton() {
    return BlocConsumer<ProductionJobOrderCubit, ProductionJobOrderState>(
      listener: (context, state) {
        if (state is ProductionJobOrderUpdateMappedBarcodesLoaded) {
          AppSnackbars.success(context, state.message);
          AppNavigator.pushAndRemoveUntil(
            context: context,
            screen: const HomeScreen(),
          );
        }
      },
      builder: (context, state) {
        final isLoading =
            state is ProductionJobOrderUpdateMappedBarcodesLoading;
        return PrimaryButtonWidget(
          text: "Save",
          backgroundColor: AppColors.pink,
          onPressed: () {
            if (locationController.text.isEmpty) {
              AppSnackbars.normal(
                  context, "Please Enter WIP Location in order to proceed");
              return;
            } else if (cubit.items.isEmpty) {
              AppSnackbars.normal(
                  context, "Please scan at least one item in order to proceed");
              return;
            } else if (isLoading) {
              return;
            }

            context.read<ProductionJobOrderCubit>().updateMappedBarcodes(
                  locationController.text,
                  cubit.items,
                  oldOrder: context.read<ProductionJobOrderCubit>().order!,
                  qty: cubit.quantityPicked,
                );
          },
          isLoading: isLoading,
        );
      },
    );
  }

  Widget _buildPalletForm() {
    final productionJobOrderCubit = context.read<ProductionJobOrderCubit>();
    return BlocBuilder<ProductionJobOrderCubit, ProductionJobOrderState>(
      bloc: cubit,
      builder: (context, state) {
        return Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Scan Pallet Number",
                  style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextFormField(
                controller: palletController,
                decoration: InputDecoration(
                  hintText: 'Pallet Number',
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      cubit.scanPackagingBySscc(
                        palletCode: palletController.text,
                      );
                    },
                    icon: Icon(state is PackagingScanLoading
                        ? Icons.hourglass_empty
                        : Icons.qr_code),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScannedItems() {
    final items = cubit.packagingScanResults;
    final packages = cubit.packagingScanResults.entries;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Scanned Items (${items.length}) ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                if (cubit.selectedpackagingScanResults.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.pink.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${cubit.selectedpackagingScanResults.length} selected',
                      style: TextStyle(
                        color: AppColors.pink,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            Row(
              children: [
                if (cubit.selectedpackagingScanResults.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      cubit.clearSelectedItems();
                    },
                    child: const Text(
                      'Clear Selection',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                TextButton(
                  onPressed: () {
                    cubit.clearItems();
                  },
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...packages.map(
          (package) => Card(
            color: AppColors.white,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Package SSCC header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SSCC: ${package.key}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Remove this SSCC entry
                          cubit.packagingScanResults.remove(package.key);
                          setState(() {});
                        },
                        icon: const Icon(Icons.close),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),

                  Text(
                    'Total items: ${package.value.length}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Individual package details
                  ...package.value
                      .map((item) => _buildSelectionItem(item))
                      .toList(),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSelectionItem(Map item) {
    final isSelected = cubit.isItemSelected(item);

    return GestureDetector(
      onTap: () {
        cubit.toggleItemSelection(item);
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.pink.withOpacity(0.05)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.pink : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox for selection
            Padding(
              padding: const EdgeInsets.only(right: 12, top: 4),
              child: SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: isSelected,
                  activeColor: AppColors.pink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: (value) {
                    cubit.toggleItemSelection(item);
                    setState(() {});
                  },
                ),
              ),
            ),

            // Item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item['description'] != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        item['description'] ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: isSelected ? AppColors.pink : Colors.black,
                        ),
                      ),
                    ),

                  // First row
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoField(
                            'GTIN', item['serialGTIN'] ?? 'N/A'),
                      ),
                      Expanded(
                        child: _buildInfoField(
                            'Serial', item['serialNo'] ?? 'N/A'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Second row
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoField(
                            'Member ID', item['memberId'] ?? 'N/A'),
                      ),
                      Expanded(
                        child: _buildInfoField(
                            'Location', item['binLocationId'] ?? 'N/A'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSerialForm() {
    return BlocBuilder<ProductionJobOrderCubit, ProductionJobOrderState>(
      bloc: cubit,
      builder: (context, state) {
        return Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Scan Serial Number",
                  style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextFormField(
                controller: serialController,
                decoration: InputDecoration(
                  hintText: 'Serial Number',
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      //   cubit.getMappedBarcodes(
                      //     context
                      //             .read<ProductionJobOrderCubit>()
                      //             .bomStartData
                      //             ?.productId ??
                      //         '',
                      //     serialNo: serialController.text,
                      //   );
                      cubit.scanPackagingBySscc(
                        serialNo: serialController.text,
                      );
                    },
                    icon: Icon(state is ProductionJobOrderMappedBarcodesLoading
                        ? Icons.hourglass_empty
                        : Icons.qr_code),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
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

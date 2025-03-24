import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/association/transfer/production_job_order/production_job_order_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/transfer/production_job_order/production_job_order_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';

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

  @override
  void initState() {
    super.initState();
    // Fetch bin locations when screen initializes
    context.read<ProductionJobOrderCubit>().getBinLocations();
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
                          child: Text(location.binNumber ?? ''),
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
                  child: TextField(
                    controller: _barcodeController,
                    decoration: const InputDecoration(
                      hintText: 'Enter/Scan Serial Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: AppColors.darkNavy,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Implement barcode scanning functionality
                    },
                  ),
                ),
              ],
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
            const Text(
              'Scanned Items (0) Serial',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
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
                  _buildInstructionStep('2', 'Scan or enter the serial number'),
                  const SizedBox(height: 16),
                  _buildInstructionStep('3', 'Select the appropriate batch'),
                  const SizedBox(height: 16),
                  _buildInstructionStep('4', 'View scanned items below'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Total Scanned
            const Text(
              'Total Scanned: (0)',
              style: TextStyle(
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
                backgroundColor: AppColors.pink,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PrimaryButtonWidget(
                text: 'Save',
                onPressed: () {
                  // Implement save functionality
                },
                backgroundColor: AppColors.green,
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

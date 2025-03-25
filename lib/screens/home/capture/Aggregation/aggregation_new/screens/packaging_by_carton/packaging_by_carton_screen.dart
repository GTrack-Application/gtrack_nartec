import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/cubit/aggregation_state_v2.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/screens/packaging_by_carton/packaging_scan_item_screen.dart';

import '../../cubit/aggregation_cubit_v2.dart';
import '../../model/packaging_model.dart';

class PackagingByCartonScreen extends StatefulWidget {
  final String type;
  final String description;
  final String floatingActionButtonText;
  const PackagingByCartonScreen({
    super.key,
    required this.type,
    required this.description,
    required this.floatingActionButtonText,
  });

  @override
  State<PackagingByCartonScreen> createState() =>
      _PackagingByCartonScreenState();
}

class _PackagingByCartonScreenState extends State<PackagingByCartonScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AggregationCubit>().getPackaging(
          widget.type == "box_carton"
              ? "box_carton"
              : widget.type == "grouping"
                  ? "grouping"
                  : "batching",
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(widget.description),
        backgroundColor: AppColors.pink,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          AppNavigator.goToPage(
            context: context,
            screen: PackagingScanItemScreen(type: widget.type),
          );
        },
        backgroundColor: AppColors.pink,
        label: Text(
          widget.floatingActionButtonText,
          style: const TextStyle(color: AppColors.white),
        ),
      ),
      body: BlocConsumer<AggregationCubit, AggregationState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is AggregationLoading) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5, // Show 5 placeholder items
              itemBuilder: (context, index) {
                return const PackageCardPlaceholder();
              },
            );
          } else if (state is AggregationError) {
            return Center(
                child: Text(
              state.message,
              style: const TextStyle(
                color: AppColors.danger,
              ),
            ));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: context.read<AggregationCubit>().packaging.length,
            itemBuilder: (context, index) {
              final package = context.read<AggregationCubit>().packaging[index];
              return PackageCard(package: package);
            },
          );
        },
      ),
    );
  }
}

class PackageCard extends StatelessWidget {
  final PackagingModel package;

  const PackageCard({super.key, required this.package});

  void _showPackageDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.pink,
                      AppColors.pink.withValues(alpha: 0.8)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Package Details',
                        style: const TextStyle(
                          fontSize: 18,
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
              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SSCC Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SSCC Number',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SelectableText(
                            package.sSCCNo ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Packaging Information Section
                    _buildInfoSection('Packaging Information'),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        children: [
                          _buildEnhancedInfoRow(
                            'Packaging Type',
                            package.packagingType ?? 'N/A',
                            Icons.inventory_2,
                          ),
                          const Divider(height: 24),
                          _buildEnhancedInfoRow(
                            'Description',
                            package.description ?? 'N/A',
                            Icons.description,
                          ),
                          const Divider(height: 24),
                          _buildEnhancedInfoRow(
                            'Status',
                            package.status ?? 'N/A',
                            Icons.info,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Pallet Items Section
                    _buildInfoSection('Pallet Items'),
                    if (package.details != null)
                      ...package.details!
                          .map((item) => _buildEnhancedPalletItemCard(item)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: AppColors.pink,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEnhancedInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.pink),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedPalletItemCard(Details item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(Icons.qr_code, color: AppColors.pink),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Serial GTIN: ${item.serialGTIN}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEnhancedInfoRow(
                        'Serial No.',
                        item.serialNo ?? 'N/A',
                        Icons.numbers,
                      ),
                      const SizedBox(height: 10),
                      _buildEnhancedInfoRow(
                        'Serial Number',
                        item.serialNo ?? 'N/A',
                        Icons.confirmation_number,
                      ),
                      const SizedBox(height: 12),
                      BarcodeWidget(
                        data: item.serialGTIN ?? '',
                        barcode: Barcode.code128(),
                        height: 80,
                        width: 120,
                      ),
                      const SizedBox(height: 12),
                      BarcodeWidget(
                        data: item.serialGTIN ?? '',
                        barcode: Barcode.qrCode(),
                        height: 80,
                        width: 80,
                      ),
                    ],
                  ),
                ),
                // Barcodes
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isCreatedToday() {
    if (package.createdAt == null) return false;

    try {
      final creationDate = DateTime.parse(package.createdAt!).toLocal();
      final today = DateTime.now();

      return creationDate.year == today.year &&
          creationDate.month == today.month &&
          creationDate.day == today.day;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isToday = _isCreatedToday();

    return Card(
      color: isToday ? Colors.blue.shade50 : Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Created Date: ${package.createdAt?.split('T')[0] ?? ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isToday ? Colors.blue.shade700 : Colors.grey[600],
                    fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    package.status ?? 'Active',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SelectableText(
              package.sSCCNo ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Description: ${package.description ?? ''}',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Packaging Type: ${package.packagingType ?? ''}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.visibility, color: Colors.blue),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => _showPackageDetails(context),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    // Handle delete action
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PackageCardPlaceholder extends StatelessWidget {
  const PackageCardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 200,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 150,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

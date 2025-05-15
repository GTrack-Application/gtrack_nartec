// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/features/capture/cubits/association_internal_goodsIssue_productionJobOrder/production_job_order_cubit.dart';
import 'package:gtrack_nartec/features/capture/cubits/association_internal_goodsIssue_productionJobOrder/production_job_order_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_nartec/global/widgets/drop_down/drop_down_widget.dart';
import 'package:gtrack_nartec/global/widgets/text_field/text_form_field_widget.dart';
import 'package:gtrack_nartec/features/capture/models/association_internal_goodsIssue_productionJobOrder/bin_locations_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/cubit/aggregation_cubit_v2.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/cubit/aggregation_state_v2.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/model/packaging_model.dart';

class PalletizationContainerizationAggregationScreen extends StatefulWidget {
  final AggregationType type;
  const PalletizationContainerizationAggregationScreen({
    super.key,
    required this.type,
  });

  @override
  State<PalletizationContainerizationAggregationScreen> createState() =>
      _PalletizationContainerizationAggregationScreenState();
}

class _PalletizationContainerizationAggregationScreenState
    extends State<PalletizationContainerizationAggregationScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _containerCodeController =
      TextEditingController();

  // Cubits
  late AggregationCubit cubit;
  late ProductionJobOrderCubit productionJobOrderCubit;

  @override
  void initState() {
    super.initState();
    // Initialize cubits
    cubit = context.read<AggregationCubit>();
    productionJobOrderCubit = context.read<ProductionJobOrderCubit>();

    // Load bin locations and SSCC packages when screen initializes
    initCubit();
  }

  initCubit() {
    cubit.resetPalletization();
    productionJobOrderCubit.getBinLocations();
    cubit.fetchAvailableSSCCPackages();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final type =
        widget.type == AggregationType.palletization ? 'Pallet' : 'Container';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pink,
        foregroundColor: AppColors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scan Item Barcode (GTIN)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Aggregation $type',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<AggregationCubit, AggregationState>(
        listener: (context, state) {
          if (state is PalletCreated) {
            AppSnackbars.success(context, state.message);
            if (widget.type == AggregationType.palletization) {
              cubit.fetchPalletizationData();
            } else {
              cubit.fetchAvailableContainers();
            }
            Navigator.pop(context);
          } else if (state is PalletizationError) {
            AppSnackbars.danger(context, state.message);
          } else if (state is SSCCPackagesError) {
            AppSnackbars.danger(context, state.message);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Suggested Bin Locations
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
                  return DropDownWidget<dynamic>(
                    width: double.infinity,
                    height: 40,
                    items: binLocations,
                    value: cubit.selectedBinLocationId != null
                        ? binLocations.firstWhere(
                            (loc) => loc.id == cubit.selectedBinLocationId,
                            orElse: () => BinLocation(),
                          )
                        : null,
                    displayItemFn: (location) =>
                        "${location.binNumber}-${location.groupWarehouse} (${location.availableQty})",
                    hintText: "Select bin location",
                    onChanged: (value) {
                      if (value != null) {
                        cubit.setSelectedBinLocation(value.id);
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: 24),

              // Pallet Description
              const Text(
                'Pallet Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextFormFieldWidget(
                controller: _descriptionController,
                hintText: 'Enter description for the Pallet',
                height: 40,
              ),

              const SizedBox(height: 24),

              // Container Code
              if (widget.type == AggregationType.containerization) ...[
                const Text(
                  'Container Code',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormFieldWidget(
                  controller: _containerCodeController,
                  hintText: 'Enter container code',
                  height: 40,
                ),
                const SizedBox(height: 24),
              ],

              // Select SSCC Packages
              const Text(
                'Select SSCC Packages',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              BlocBuilder<AggregationCubit, AggregationState>(
                buildWhen: (previous, current) => current is SSCCPackagesLoaded,
                builder: (context, state) {
                  final packages = cubit.availableSSCCPackages;

                  return DropDownWidget<PackagingModel>(
                    width: double.infinity,
                    height: 40,
                    items: packages,
                    value: cubit.selectedSSCCPackage,
                    displayItemFn: (pkg) =>
                        "${pkg.sSCCNo} - ${pkg.packagingType}",
                    hintText: "Select SSCC package",
                    onChanged: (value) {
                      if (value != null) {
                        cubit.setSelectedSSCCPackage(value);
                        cubit.addSSCCPackageToSelection(value);
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              // Selected SSCC Packages
              BlocBuilder<AggregationCubit, AggregationState>(
                buildWhen: (previous, current) =>
                    current is SSCCPackageSelectionChanged,
                builder: (context, state) {
                  final selectedCount = cubit.selectedSSCCNumbers.length;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected SSCC Packages ($selectedCount)',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: cubit.selectedSSCCNumbers.isEmpty
                            ? _buildInstructions()
                            : Column(
                                children: cubit.selectedSSCCNumbers
                                    .map((sscc) => _buildPackageItem(sscc))
                                    .toList(),
                              ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),
              // Total Scanned
              BlocBuilder<AggregationCubit, AggregationState>(
                builder: (context, state) {
                  return Text(
                    'Total Scanned: (${cubit.selectedSSCCNumbers.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Row(
          children: [
            Expanded(
              child: PrimaryButtonWidget(
                onPressed: () => Navigator.pop(context),
                text: 'Cancel',
                backgroundColor: AppColors.gold,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: BlocBuilder<AggregationCubit, AggregationState>(
                builder: (context, state) {
                  final isLoading = state is PalletizationLoading;
                  final canSave = cubit.selectedSSCCNumbers.isNotEmpty &&
                      cubit.selectedBinLocationId != null;
                  return PrimaryButtonWidget(
                    onPressed: !canSave || isLoading
                        ? null
                        : () {
                            cubit.createPallet(
                              _descriptionController.text,
                              cubit.selectedSSCCNumbers,
                              _containerCodeController.text,
                              widget.type,
                            );
                          },
                    text: isLoading ? 'Saving...' : 'Save',
                    backgroundColor: AppColors.pink,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.info_outline,
          color: Colors.grey,
          size: 36,
        ),
        const SizedBox(height: 8),
        const Text(
          'No SSCC packages selected',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Select SSCC packages from the dropdown above',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPackageItem(String ssccNo) {
    final package = cubit.availableSSCCPackages.firstWhere(
      (p) => p.sSCCNo == ssccNo,
      orElse: () => PackagingModel(sSCCNo: ssccNo, packagingType: 'Unknown'),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.fields),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ssccNo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                if (package.packagingType != null)
                  Text(
                    package.packagingType!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                if (package.description != null &&
                    package.description!.isNotEmpty)
                  Text(
                    package.description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.red,
              size: 20,
            ),
            onPressed: () {
              cubit.removeSSCCPackageFromSelection(ssccNo);
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  // Shimmer loading placeholder widget
  Widget _buildLoadingPlaceholder() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // Pallet header placeholder
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title placeholder
              _buildShimmerBox(height: 24, width: 200),
              const SizedBox(height: 16),

              // Description input placeholder
              _buildShimmerBox(height: 50, width: double.infinity),
              const SizedBox(height: 16),

              // Divider
              Divider(color: Colors.grey.shade200),
              const SizedBox(height: 16),

              // Packages count placeholder
              _buildShimmerBox(height: 20, width: 150),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Package list placeholders
        for (int i = 0; i < 6; i++) ...[
          _buildPackagePlaceholder(),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  // Single package item placeholder
  Widget _buildPackagePlaceholder() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Row(
        children: [
          // Checkbox placeholder
          _buildShimmerBox(height: 24, width: 24, borderRadius: 12),
          const SizedBox(width: 12),

          // Package info placeholder
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShimmerBox(height: 16, width: double.infinity),
                const SizedBox(height: 8),
                _buildShimmerBox(height: 14, width: 180),
                const SizedBox(height: 8),
                _buildShimmerBox(height: 14, width: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Generic shimmer box with animation
  Widget _buildShimmerBox({
    required double height,
    required double width,
    double borderRadius = 4,
  }) {
    return ShimmerEffect(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

// Add this class at the end of the file (outside the main class)
class ShimmerEffect extends StatefulWidget {
  final Widget child;

  const ShimmerEffect({
    super.key,
    required this.child,
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.4, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

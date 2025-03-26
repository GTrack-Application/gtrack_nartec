import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/cubit/aggregation_cubit_v2.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/cubit/aggregation_state_v2.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/model/palletization_model.dart';
import 'package:intl/intl.dart';

import 'palletization_aggregation_screen.dart';

class PalletizationContainerizationScreen extends StatefulWidget {
  const PalletizationContainerizationScreen({super.key});

  @override
  State<PalletizationContainerizationScreen> createState() =>
      _PalletizationContainerizationScreenState();
}

class _PalletizationContainerizationScreenState
    extends State<PalletizationContainerizationScreen> {
  final TextEditingController _searchController = TextEditingController();

  late final AggregationCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<AggregationCubit>();
    cubit.fetchPalletizationData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final dateTime = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy, HH:mm:ss').format(dateTime);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aggregation by Palletization'),
        backgroundColor: AppColors.pink,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to perform aggregation screen
          AppNavigator.goToPage(
            context: context,
            screen: const PalletizationAggregationScreen(),
          );
        },
        icon: const Icon(Icons.inventory),
        label: const Text('Perform Aggregation by Palletization'),
        backgroundColor: AppColors.pink,
        foregroundColor: AppColors.white,
      ),
      body: Column(
        children: [
          // Padding(
          //     padding: const EdgeInsets.all(16),
          //     child: TextFormFieldWidget(
          //       controller: _searchController,
          //       hintText: 'Search purchase orders...',
          //     )),
          Expanded(
            child: BlocBuilder<AggregationCubit, AggregationState>(
              builder: (context, state) {
                if (state is PalletizationLoading) {
                  return _buildLoadingPlaceholder();
                } else if (state is PalletizationError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    cubit.fetchPalletizationData();
                  },
                  child: ListView.builder(
                    itemCount: cubit.pallets.length,
                    itemBuilder: (context, index) {
                      final pallet = cubit.pallets[index];
                      return PalletCard(
                        pallet: pallet,
                        formatDate: formatDate,
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8, // Show 8 placeholder items
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Pallet header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Pallet icon placeholder
                    ShimmerEffect(
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Pallet info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SSCC title
                          ShimmerEffect(
                            child: Container(
                              height: 18,
                              width: 180,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Date
                          ShimmerEffect(
                            child: Container(
                              height: 14,
                              width: 140,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Status tag
                    ShimmerEffect(
                      child: Container(
                        height: 28,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Divider(height: 1, color: Colors.grey.shade200),

              // Pallet details section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section title
                    ShimmerEffect(
                      child: Container(
                        height: 16,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Details row 1
                    Row(
                      children: [
                        // Label
                        ShimmerEffect(
                          child: Container(
                            height: 14,
                            width: 90,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Value
                        Expanded(
                          child: ShimmerEffect(
                            child: Container(
                              height: 14,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Details row 2
                    Row(
                      children: [
                        // Label
                        ShimmerEffect(
                          child: Container(
                            height: 14,
                            width: 70,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Value
                        Expanded(
                          child: ShimmerEffect(
                            child: Container(
                              height: 14,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ShimmerEffect(
                      child: Container(
                        height: 36,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ShimmerEffect(
                      child: Container(
                        height: 36,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(18),
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
    );
  }
}

class PalletCard extends StatelessWidget {
  final PalletizationModel pallet;
  final Function(String?) formatDate;

  const PalletCard({
    super.key,
    required this.pallet,
    required this.formatDate,
  });

  void _showPalletDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'List of SSCC Boxes: ${pallet.sSCCNo ?? "N/A"}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(),

              // Pallet Information Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pallet Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pallet SSCC:',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text(pallet.sSCCNo ?? 'N/A'),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Status: ${pallet.status ?? "N/A"}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Description: ',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(pallet.description ?? 'N/A'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Created At: ',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(formatDate(pallet.createdAt)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                'Pallet Items',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // SSCC Packages List
              Expanded(
                child: pallet.ssccPackages == null ||
                        pallet.ssccPackages!.isEmpty
                    ? const Center(
                        child: Text(
                          'No packages in this pallet',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: pallet.ssccPackages!.length,
                        itemBuilder: (context, index) {
                          final package = pallet.ssccPackages![index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'SSCC: ${package.sSCCNo ?? "N/A"}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: package.status == 'active'
                                              ? Colors.green
                                              : Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          package.status ?? 'N/A',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Description: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Expanded(
                                            child: Text(
                                              package.description ??
                                                  'No description',
                                              style: const TextStyle(
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Text(
                                            'Packaging Type: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            package.packagingType ?? 'N/A',
                                            style: const TextStyle(
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Created At: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            formatDate(package.createdAt),
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Updated At: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            formatDate(package.updatedAt),
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Add barcodes in the future if needed
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Created Date: ${formatDate(pallet.createdAt)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    pallet.status ?? 'unknown',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              pallet.sSCCNo ?? 'No SSCC',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Description: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(pallet.description ?? 'No description'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text(
                  'Group Warehouse: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(pallet.binLocation?.groupWarehouse ?? 'Unknown'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text('Zoned: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(pallet.binLocation?.zoned ?? 'Unknown'),
                const Text(' - '),
                Text(pallet.binLocation?.zoneCode ?? ''),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility, color: Colors.blue),
                  onPressed: () => _showPalletDetails(context),
                ),
                IconButton(
                  icon: const Icon(Icons.print, color: Colors.blue),
                  onPressed: () {
                    // Print action
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Delete action
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

// Add the ShimmerEffect class if it doesn't exist in this file
class ShimmerEffect extends StatefulWidget {
  final Widget child;

  const ShimmerEffect({
    Key? key,
    required this.child,
  }) : super(key: key);

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

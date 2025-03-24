import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/association/transfer/production_job_order/production_job_order_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/transfer/production_job_order/production_job_order_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Shipping/sales_order_new/sales_order_transfer_by_pallet_screen.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Transfer/goods_issue/production_job_order/job_order_bom_start_screen2.dart';

class JobOrderBomStartScreen1 extends StatefulWidget {
  final String gtin;
  final String productName;
  final bool? isSalesOrder;

  const JobOrderBomStartScreen1({
    super.key,
    required this.gtin,
    required this.productName,
    this.isSalesOrder = false,
  });

  @override
  State<JobOrderBomStartScreen1> createState() =>
      _JobOrderBomStartScreen1State();
}

class _JobOrderBomStartScreen1State extends State<JobOrderBomStartScreen1> {
  late ProductionJobOrderCubit _cubit;

  final _locationController = TextEditingController();
  final _groupCodeController = TextEditingController();
  final _availableQuantityController = TextEditingController();
  final _whLocationCodeController = TextEditingController();
  final _minQtyController = TextEditingController();
  final _maxQtyController = TextEditingController();
  final _itemBinTypeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _groupCodeController.text = 'Riyadh';
    _minQtyController.text = '0';
    _itemBinTypeController.text = 'x';
    _whLocationCodeController.text = '1106';
    _cubit = ProductionJobOrderCubit();
    _cubit.getBinLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suggested Bin Number'),
        backgroundColor: AppColors.pink,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 16.0,
            children: [
              Column(
                children: [
                  Text(
                    widget.gtin,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.productName,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              BlocBuilder<ProductionJobOrderCubit, ProductionJobOrderState>(
                bloc: _cubit,
                builder: (context, state) {
                  if (state is ProductionJobOrderBinLocationsLoading) {
                    return _buildShimmer();
                  }
                  if (state is ProductionJobOrderBinLocationsLoaded) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16.0,
                        children: [
                          const Text(
                            'Suggested Bin Locations',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              fillColor: AppColors.background,
                              focusColor: AppColors.background,
                              labelText: 'Select Bin Location',
                              border: OutlineInputBorder(),
                            ),
                            items: state.binLocations.map((location) {
                              return DropdownMenuItem(
                                value:
                                    "${location.binNumber}:${location.availableQty}",
                                child: Text(
                                  '${location.binNumber} (${location.availableQty})',
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              _locationController.text =
                                  value?.split(':')[0] ?? '';
                              _availableQuantityController.text =
                                  value?.split(':')[1] ?? '';
                              _maxQtyController.text =
                                  value?.split(':')[1] ?? '';
                              _cubit.selectedGLN = state.binLocations
                                  .firstWhere((location) =>
                                      location.binNumber ==
                                      value?.split(':')[0])
                                  .gln;
                            },
                          ),
                          _buildKeyValue("Group Code:", _groupCodeController),
                          _buildKeyValue("Available Quantity:",
                              _availableQuantityController),
                          _buildKeyValue(
                              "WH Location Code:", _whLocationCodeController),
                          _buildKeyValue("Min Qty:", _minQtyController),
                          _buildKeyValue("Max Qty:", _maxQtyController),
                          _buildKeyValue(
                              "Item Bin Type:", _itemBinTypeController),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _locationController,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Location Code is required';
                                    } else if (_locationController
                                        .text.isEmpty) {
                                      return 'Location Code is required';
                                    } else if (value !=
                                        _locationController.text) {
                                      return 'Invalid Location Code';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Enter / Scan Location Code',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.qr_code),
                            ],
                          ),
                          FilledButton(
                            onPressed: () {
                              final isValidated =
                                  _formKey.currentState!.validate();

                              if (isValidated) {
                                // Add next button functionality
                                if (widget.isSalesOrder == true) {
                                  AppNavigator.goToPage(
                                    context: context,
                                    screen: SalesOrderTransferByPalletScreen(),
                                  );
                                } else {
                                  AppNavigator.goToPage(
                                    context: context,
                                    screen: JobOrderBomStartScreen2(),
                                  );
                                }
                              }
                              return;
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.pink,
                            ),
                            child: const Text("Next"),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is ProductionJobOrderBinLocationsError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 24,
          width: 200,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Container(
          height: 56,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        ...List.generate(
          7,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Container(
                  height: 16,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 56,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        Container(
          height: 48,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }

  Widget _buildKeyValue(String key, TextEditingController controller) {
    return Row(
      children: [
        Text(key),
        const Spacer(),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.black),
            borderRadius: BorderRadius.circular(8),
          ),
          width: 200,
          height: 40,
          child: TextField(
            controller: controller,
            enabled: false,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.black,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}

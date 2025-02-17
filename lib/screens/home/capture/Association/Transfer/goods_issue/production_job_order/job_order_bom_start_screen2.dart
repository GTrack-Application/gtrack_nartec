import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/capture/association/transfer/production_job_order/production_job_order_cubit.dart';
import 'package:gtrack_nartec/blocs/capture/association/transfer/production_job_order/production_job_order_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/global/common/utils/app_toast.dart';
import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Transfer/goods_issue/production_job_order/production_job_order_screen.dart';

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
  Widget build(BuildContext context) {
    final bom = context.read<ProductionJobOrderCubit>().bomStartData;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Order BOM Start'),
        backgroundColor: AppColors.pink,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<ProductionJobOrderCubit, ProductionJobOrderState>(
            bloc: cubit,
            listener: (context, state) {
              if (state is ProductionJobOrderMappedBarcodesError) {
                AppToast.danger(context, state.message);
              } else if (state is ProductionJobOrderMappedBarcodesLoaded) {
                AppToast.success(context, state.mappedBarcodes.message);
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Row(
                    children: [
                      const Text('Quantity: '),
                      Text(bom?.quantity ?? '0'),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Picked Quantity: '),
                      Text(bom?.quantityPicked ?? '0'),
                    ],
                  ),
                  // Radio Buttons for BY PALLET or BY SERIAL
                  Row(
                    spacing: 8,
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
                  ),

                  if (selectedType == 'pallet')
                    _buildPalletForm()
                  else
                    _buildSerialForm(),
                  if ((state is ProductionJobOrderMappedBarcodesError) ||
                      (state is ProductionJobOrderMappedBarcodesLoaded &&
                          state.mappedBarcodes.data?.isNotEmpty == true))
                    _buildScannedItems(),
                  // if (state is ProductionJobOrderMappedBarcodesError)
                  //   Text(state.message,
                  //       style: const TextStyle(color: Colors.red)),

                  const Text("Scan WIP Location"),
                  TextFormField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      hintText: 'WIP Location',
                    ),
                  ),
                  BlocConsumer<ProductionJobOrderCubit,
                      ProductionJobOrderState>(
                    listener: (context, state) {
                      if (state
                          is ProductionJobOrderUpdateMappedBarcodesLoaded) {
                        AppSnackbars.success(context, state.message);
                        AppNavigator.pushAndRemoveUntil(
                          context: context,
                          screen: ProductionJobOrderScreen(),
                        );
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state
                          is ProductionJobOrderUpdateMappedBarcodesLoading;
                      return PrimaryButtonWidget(
                        text: "Save",
                        onPressed: () {
                          if (locationController.text.isEmpty) {
                            AppSnackbars.normal(context,
                                "Please Enter WIP Location in order to proceed");
                            return;
                          } else if (cubit.items.isEmpty) {
                            AppSnackbars.normal(context,
                                "Please scan at least one item in order to proceed");
                            return;
                          } else if (isLoading) {
                            return;
                          }

                          context
                              .read<ProductionJobOrderCubit>()
                              .updateMappedBarcodes(
                                locationController.text,
                                cubit.items,
                              );
                        },
                        isLoading: isLoading,
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPalletForm() {
    return BlocBuilder<ProductionJobOrderCubit, ProductionJobOrderState>(
      bloc: cubit,
      builder: (context, state) {
        return Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              const Text("Scan Pallet Number"),
              TextFormField(
                controller: palletController,
                decoration: InputDecoration(
                  hintText: 'Pallet Number',
                  suffixIcon: IconButton(
                    onPressed: () {
                      cubit.getMappedBarcodes(
                        context
                                .read<ProductionJobOrderCubit>()
                                .bomStartData
                                ?.productId ??
                            '',
                        palletCode: palletController.text,
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

  Widget _buildScannedItems() {
    final items = cubit.items;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        const SizedBox(height: 8),
        ...items.map((item) => Card(
              color: AppColors.white,
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
                          item.itemDesc ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Remove individual item
                            cubit.removeItem(item);
                          },
                          icon: const Icon(Icons.close),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    Text(
                      'Item Code: ${item.itemCode}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'GTIN',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                item.gtin ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
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
                              const Text(
                                'Serial No',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                item.itemSerialNo ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Location',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          item.binLocation ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pallet Code',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          item.palletCode ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Record #${items.indexOf(item) + 1}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'SDFADSFADS',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildSerialForm() {
    return BlocBuilder<ProductionJobOrderCubit, ProductionJobOrderState>(
      bloc: cubit,
      builder: (context, state) {
        return Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8.0,
            children: [
              Text("Scan Serial Number"),
              TextFormField(
                controller: serialController,
                decoration: InputDecoration(
                  hintText: 'Serial Number',
                  suffixIcon: IconButton(
                    onPressed: () {
                      cubit.getMappedBarcodes(
                        context
                                .read<ProductionJobOrderCubit>()
                                .bomStartData
                                ?.productId ??
                            '',
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
}

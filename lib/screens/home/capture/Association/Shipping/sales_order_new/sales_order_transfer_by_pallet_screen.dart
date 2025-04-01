import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/features/capture/cubits/association/transfer/production_job_order/production_job_order_cubit.dart';
import 'package:gtrack_nartec/features/capture/cubits/association/transfer/production_job_order/production_job_order_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Shipping/sales_order_new/sales_order_screen.dart';

class SalesOrderTransferByPalletScreen extends StatefulWidget {
  const SalesOrderTransferByPalletScreen({super.key});

  @override
  State<SalesOrderTransferByPalletScreen> createState() =>
      _SalesOrderTransferByPalletScreenState();
}

class _SalesOrderTransferByPalletScreenState
    extends State<SalesOrderTransferByPalletScreen> {
  late final ProductionJobOrderCubit cubit;

  final locationController = TextEditingController();
  final palletController = TextEditingController();
  final serialController = TextEditingController();
  String selectedType = 'pallet';

  @override
  void initState() {
    super.initState();
    cubit = context.read<ProductionJobOrderCubit>();
    cubit.clearAll();
    setState(() {
      cubit.quantityPicked = cubit.selectedSubSalesOrder?.quantityPicked as int;
    });
    // Fetch vehicles when the screen initializes
    cubit.getVehicles();
  }

  @override
  Widget build(BuildContext context) {
    final bom = context.watch<ProductionJobOrderCubit>().bomStartData;
    cubit.bomStartData = bom;
    final order = cubit.selectedSubSalesOrder;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer By Pallet'),
        backgroundColor: AppColors.pink,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<ProductionJobOrderCubit, ProductionJobOrderState>(
            bloc: cubit,
            buildWhen: (previous, current) {
              return current is ProductionJobOrderMappedBarcodesLoaded;
            },
            listener: (context, state) {
              print(state);
              if (state is ProductionJobOrderMappedBarcodesError) {
                AppSnackbars.danger(context, state.message);
              } else if (state is ProductionJobOrderMappedBarcodesLoaded) {
                if (state.mappedBarcodes.message != null) {
                  AppSnackbars.success(
                    context,
                    state.mappedBarcodes.message ?? '',
                  );
                }
              } else if (state is ProductionJobOrderUpdateMappedBarcodesError) {
                AppSnackbars.danger(context, state.message);
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
                      Text("${order?.quantity ?? 0}"),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Picked Quantity: '),
                      Text("${order?.quantityPicked ?? 0}"),
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

                  const Text("Select Vehicle"),
                  BlocBuilder<ProductionJobOrderCubit, ProductionJobOrderState>(
                    bloc: cubit,
                    builder: (context, state) {
                      if (state is VehiclesLoading) {
                        // placeholder

                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: CircularProgressIndicator(
                              color: AppColors.pink,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: cubit.selectedVehicle?.id,
                              isExpanded: true,
                              dropdownColor: AppColors.background,
                              hint: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text('Select a vehicle'),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              items: cubit.vehicles.map((vehicle) {
                                return DropdownMenuItem<String>(
                                  value: vehicle.id,
                                  child: Text(
                                    '${vehicle.plateNumber} - ${vehicle.make} ${vehicle.model}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (vehicleId) {
                                if (vehicleId != null) {
                                  final vehicle = cubit.vehicles.firstWhere(
                                    (v) => v.id == vehicleId,
                                  );
                                  cubit.setSelectedVehicle(vehicle);
                                }
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  buildSaveButton(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  BlocConsumer<ProductionJobOrderCubit, ProductionJobOrderState>
      buildSaveButton() {
    return BlocConsumer<ProductionJobOrderCubit, ProductionJobOrderState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is ProductionJobOrderUpdateMappedBarcodesLoaded) {
          AppSnackbars.success(context, state.message);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          AppNavigator.replaceTo(
            context: context,
            screen: SalesOrderScreen(),
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
            if (cubit.selectedVehicle == null) {
              AppSnackbars.warning(
                  context, "Please select a vehicle to proceed");
              return;
            } else if (cubit.items.isEmpty) {
              // Show warning dialog when no items scanned
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.amber),
                        SizedBox(width: 10),
                        Text(
                          'No Items Scanned',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    content: Text(
                      'You haven\'t scanned any items yet. Are you sure you want to proceed without scanning?',
                      style: TextStyle(fontSize: 16),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                        },
                        child: Text(
                          'Go Back',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.pink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                          // Proceed with the operation
                          cubit.updateMappedBarcodesByVehicle(
                            cubit.selectedVehicle?.glnIdNumber ?? '',
                            cubit.items,
                            qty: cubit.quantityPicked,
                          );
                        },
                        child: Text(
                          "Proceed Anyway",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    actionsPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  );
                },
              );
            } else if (isLoading) {
              return;
            } else {
              cubit.updateMappedBarcodesByVehicle(
                cubit.selectedVehicle?.glnIdNumber ?? '',
                cubit.items,
                qty: cubit.quantityPicked,
              );
            }
          },
          isLoading: isLoading,
        );
      },
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
                      cubit.getMappedBarcodesByVehicle(
                        cubit.selectedSubSalesOrder?.productId ?? '',
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
                      cubit.getMappedBarcodesByVehicle(
                        cubit.selectedSubSalesOrder?.productId ?? '',
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

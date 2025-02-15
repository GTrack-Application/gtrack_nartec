import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/capture/association/transfer/production_job_order/production_job_order_cubit.dart';
import 'package:gtrack_nartec/blocs/capture/association/transfer/production_job_order/production_job_order_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';

class JobOrderBomStartScreen2 extends StatefulWidget {
  const JobOrderBomStartScreen2({super.key});

  @override
  State<JobOrderBomStartScreen2> createState() =>
      _JobOrderBomStartScreen2State();
}

class _JobOrderBomStartScreen2State extends State<JobOrderBomStartScreen2> {
  final cubit = ProductionJobOrderCubit();
  @override
  Widget build(BuildContext context) {
    final bom = context.read<ProductionJobOrderCubit>().bomStartData;
    String selectedType = context.read<ProductionJobOrderCubit>().bomStartType;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Order BOM Start'),
        backgroundColor: AppColors.pink,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Quantity: '),
                  Text(bom?.quantity ?? '0'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Picked Quantity: '),
                  Text(bom?.quantityPicked ?? '0'),
                ],
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  context.read<ProductionJobOrderCubit>().bomStartType =
                      selectedType;
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPalletForm() {
    final palletController = TextEditingController();
    final locationController = TextEditingController();

    return BlocBuilder<ProductionJobOrderCubit, ProductionJobOrderState>(
      bloc: cubit,
      builder: (context, state) {
        return Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Scan Pallet Number"),
              TextFormField(
                controller: palletController,
                decoration: InputDecoration(
                  hintText: 'Pallet Number',
                  suffixIcon: IconButton(
                    onPressed: () {
                      cubit.getMappedBarcodes(
                          palletController.text,
                          context
                                  .read<ProductionJobOrderCubit>()
                                  .bomStartData
                                  ?.productId ??
                              '');
                    },
                    icon: Icon(state is ProductionJobOrderMappedBarcodesLoading
                        ? Icons.hourglass_empty
                        : Icons.qr_code),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Scan WIP Location"),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  hintText: 'WIP Location',
                ),
              ),
              const SizedBox(height: 16),
              if (state is ProductionJobOrderMappedBarcodesLoaded &&
                  state.mappedBarcodes.data?.isNotEmpty == true)
                _buildScannedItems(),
              if (state is ProductionJobOrderMappedBarcodesError)
                Text(state.message, style: const TextStyle(color: Colors.red)),
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
            Text('Scanned Items (${items.length})',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {
                cubit.clearItems();
              },
              child:
                  const Text('Clear All', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
        ...items.map((item) => Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.itemDesc ?? '',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Item Code: ${item.itemCode}'),
                    Row(
                      children: [
                        Expanded(child: Text('GTIN: ${item.gtin}')),
                        Expanded(
                            child: Text('Serial No: ${item.itemSerialNo}')),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text('Location: ${item.binLocation}')),
                        Expanded(
                            child: Text('Pallet Code: ${item.palletCode}')),
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
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.0,
        children: [
          Text("Scan Serial Number"),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Serial Number',
            ),
          ),
          Text("Scan WIP Location"),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'WIP Location',
            ),
          ),
        ],
      ),
    );
  }
}

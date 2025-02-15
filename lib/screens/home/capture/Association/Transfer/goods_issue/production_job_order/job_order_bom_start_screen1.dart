import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/capture/association/transfer/production_job_order/production_job_order_cubit.dart';
import 'package:gtrack_nartec/blocs/capture/association/transfer/production_job_order/production_job_order_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';

class JobOrderBomStartScreen1 extends StatefulWidget {
  final String gtin;
  final String productName;

  const JobOrderBomStartScreen1({
    super.key,
    required this.gtin,
    required this.productName,
  });

  @override
  State<JobOrderBomStartScreen1> createState() =>
      _JobOrderBomStartScreen1State();
}

class _JobOrderBomStartScreen1State extends State<JobOrderBomStartScreen1> {
  late ProductionJobOrderCubit _cubit;
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cubit = ProductionJobOrderCubit();
    _cubit.getBinLocations(widget.gtin);
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
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ProductionJobOrderBinLocationsLoaded) {
                    return Column(
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
                            labelText: 'Select Bin Location',
                            border: OutlineInputBorder(),
                          ),
                          items: state.binLocations.data?.map((location) {
                            return DropdownMenuItem(
                              value: location.binLocation,
                              child: Text(
                                '${location.binLocation}',
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            _locationController.text = value ?? '';
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _locationController,
                                decoration: const InputDecoration(
                                  labelText: 'Enter / Scan Location Code',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                // Add scanner functionality
                              },
                              icon: const Icon(Icons.qr_code),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Add next button functionality
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Next'),
                          ),
                        ),
                      ],
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
}

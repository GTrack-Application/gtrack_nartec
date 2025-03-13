import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/transformation/transformation_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/transformation/transformation_states.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_nartec/models/capture/transformation/event_station_model.dart';

class SelectedEventStationScreen extends StatefulWidget {
  final EventStation station;

  const SelectedEventStationScreen({
    super.key,
    required this.station,
  });

  @override
  State<SelectedEventStationScreen> createState() =>
      _SelectedEventStationScreenState();
}

class _SelectedEventStationScreenState
    extends State<SelectedEventStationScreen> {
  late SelectedEventStationCubit _selectedEventStationCubit;

  @override
  void initState() {
    super.initState();
    _selectedEventStationCubit = SelectedEventStationCubit();
    _selectedEventStationCubit.getStationAttributes(
      widget.station.id,
      widget.station,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: widget.station.id,
          child: Text(widget.station.eventStationName),
        ),
        backgroundColor: AppColors.pink,
      ),
      body: BlocProvider(
        create: (context) => _selectedEventStationCubit,
        child:
            BlocBuilder<SelectedEventStationCubit, SelectedEventStationState>(
          builder: (context, state) {
            if (state is SelectedEventStationLoadingState) {
              return _buildLoadingPlaceholders();
            } else if (state is SelectedEventStationErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    Text(
                      'Error: ${state.message}',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return _buildAttributesList();
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: PrimaryButtonWidget(
          text: "Save Transaction",
          backgroungColor: AppColors.pink,
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildLoadingPlaceholders() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 8,
      itemBuilder: (context, index) => Card(
        color: AppColors.background,
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 20,
                width: 150,
                decoration: BoxDecoration(
                  color: AppColors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttributesList() {
    final attributes = _selectedEventStationCubit.attributes;

    if (attributes.isEmpty) {
      return const Center(child: Text('No attributes found for this station'));
    }

    // Flatten the nested attributes to show a list of all field inputs
    final allFields = <AttributeInfo>[];
    for (var master in attributes) {
      for (var detail in master.details) {
        allFields.add(detail.attribute);
      }
    }

    // Remove duplicates
    final uniqueFields = <AttributeInfo>[];
    final fieldNames = <String>{};
    for (var field in allFields) {
      if (!fieldNames.contains(field.fieldName)) {
        fieldNames.add(field.fieldName);
        uniqueFields.add(field);
      }
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: uniqueFields.length,
      itemBuilder: (context, index) {
        final attribute = uniqueFields[index];
        return Card(
          color: AppColors.background,
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attribute.fieldName.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

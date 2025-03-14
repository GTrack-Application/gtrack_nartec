import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/transformation/transformation_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/transformation/transformation_states.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/global/utils/date_time_format.dart';
import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_nartec/global/widgets/text_field/text_field_widget.dart';
import 'package:gtrack_nartec/global/widgets/text_field/text_form_field_widget.dart';
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
  late TransformationCubit _transformationCubit;
  final Map<String, dynamic> _formValues = {};
  final Map<String, List<String>> _arrayValues = {};
  final Map<String, TextEditingController> _controllers = {};
  final TextEditingController _arrayInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _transformationCubit = context.read<TransformationCubit>();
    _transformationCubit.getStationAttributes(
      widget.station.id,
      widget.station,
    );
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    _arrayInputController.dispose();
    super.dispose();
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
      body: BlocBuilder<TransformationCubit, EventStationState>(
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
      bottomNavigationBar: BlocConsumer<TransformationCubit, EventStationState>(
        listener: (context, state) {
          if (state is TransactionSavedState) {
            AppSnackbars.success(context, 'Transaction saved successfully');
            Navigator.pop(context);
          } else if (state is TransactionSaveErrorState) {
            AppSnackbars.danger(context, state.message);
          }
        },
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: PrimaryButtonWidget(
              text: "Save Transaction",
              backgroungColor: AppColors.pink,
              isLoading: state is TransactionSavingState,
              onPressed: _saveTransaction,
            ),
          );
        },
      ),
    );
  }

  void _saveTransaction() {
    _transformationCubit.saveTransaction(_formValues, _arrayValues);
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
                  color: AppColors.grey.withAlpha(50),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.grey.withAlpha(30),
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
    final attributes = _transformationCubit.attributes;

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

        // Initialize controllers for each field
        if (!_controllers.containsKey(field.fieldName)) {
          _controllers[field.fieldName] = TextEditingController();
        }

        // Initialize array values
        if (field.fieldType == 'Array' &&
            !_arrayValues.containsKey(field.fieldName)) {
          _arrayValues[field.fieldName] = [];
        }
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
              spacing: 12,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        attribute.fieldName.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      attribute.fieldType,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                _buildInputField(attribute),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField(AttributeInfo attribute) {
    switch (attribute.fieldType) {
      case 'DateTime':
        return _buildDateTimeField(attribute);
      case 'Array':
        return _buildArrayField(attribute);
      case 'String':
      default:
        return _buildStringField(attribute);
    }
  }

  Widget _buildDateTimeField(AttributeInfo attribute) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => _selectDateTime(context, attribute.fieldName),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.fields,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: AppColors.fields, width: 2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _formValues[attribute.fieldName] != null
                        ? formatDate(_formValues[attribute.fieldName],
                            isDateTime: true)
                        : 'Select date and time',
                    style: TextStyle(
                      color: _formValues[attribute.fieldName] != null
                          ? Colors.black
                          : AppColors.grey,
                      fontSize: 13,
                    ),
                  ),
                ),
                const Icon(Icons.calendar_today, color: AppColors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDateTime(BuildContext context, String fieldName) async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _formValues[fieldName] ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.pink,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_formValues[fieldName] ?? now),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.pink,
                onPrimary: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _formValues[fieldName] = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Widget _buildArrayField(AttributeInfo attribute) {
    final items = _arrayValues[attribute.fieldName] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFieldWidget(
                controller: _controllers[attribute.fieldName]!,
                hintText: 'Scan or enter item',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add_circle, color: AppColors.pink),
                  onPressed: () {
                    final value =
                        _controllers[attribute.fieldName]!.text.trim();
                    if (value.isNotEmpty) {
                      setState(() {
                        _arrayValues[attribute.fieldName]!.add(value);
                        _controllers[attribute.fieldName]!.clear();
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.qr_code_scanner, color: AppColors.pink),
              onPressed: () {
                // TODO: Implement barcode scanning
                setState(() {
                  // Simulate a scan for demo purposes
                  _controllers[attribute.fieldName]!.text =
                      'SCANNED_ITEM_${DateTime.now().millisecondsSinceEpoch}';
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'User input as an array of items or SKU or GTIN',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        if (items.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.fields.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Items (${items.length}):',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: items
                      .map((item) => _buildChip(item, attribute.fieldName))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildChip(String label, String fieldName) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: AppColors.pink.withValues(alpha: 0.2),
      deleteIconColor: AppColors.pink,
      onDeleted: () {
        setState(() {
          _arrayValues[fieldName]!.remove(label);
        });
      },
    );
  }

  Widget _buildStringField(AttributeInfo attribute) {
    return TextFormFieldWidget(
      controller: _controllers[attribute.fieldName]!,
      hintText: 'Enter ${attribute.fieldName}',
      onChanged: (p0) {
        _formValues[attribute.fieldName] = p0;
      },
      onFieldSubmitted: (value) {
        _formValues[attribute.fieldName] = value;
      },
    );
  }
}

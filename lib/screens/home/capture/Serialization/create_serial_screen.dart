import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';

class CreateSerialScreen extends StatefulWidget {
  const CreateSerialScreen({super.key});

  @override
  _CreateSerialScreenState createState() => _CreateSerialScreenState();
}

class _CreateSerialScreenState extends State<CreateSerialScreen> {
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _batchNumberController = TextEditingController();
  DateTime? _manufactureDate;
  DateTime? _expiryDate;

  Future<void> _selectDate(BuildContext context, bool isManufactureDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null &&
        pickedDate != (isManufactureDate ? _manufactureDate : _expiryDate)) {
      setState(() {
        if (isManufactureDate) {
          _manufactureDate = pickedDate;
        } else {
          _expiryDate = pickedDate;
        }
      });
    }
  }

  void _createSerial() {
    // Implement serial creation logic here
    final String serialNumber = _serialNumberController.text;
    final String batchNumber = _batchNumberController.text;

    if (serialNumber.isEmpty ||
        batchNumber.isEmpty ||
        _manufactureDate == null ||
        _expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Proceed with the creation process
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Serial"),
        backgroundColor: AppColors.pink,
        foregroundColor: AppColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controller: _serialNumberController,
              labelText: 'Serial Number',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _batchNumberController,
              labelText: 'Batch Number',
            ),
            const SizedBox(height: 16),
            _buildDateField(
                context, 'Manufacture Date', _manufactureDate, true),
            const SizedBox(height: 16),
            _buildDateField(context, 'Expiry Date', _expiryDate, false),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createSerial,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pink,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Create Serial'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String labelText}) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context, String label,
      DateTime? selectedDate, bool isManufactureDate) {
    return SizedBox(
      height: 45,
      child: InkWell(
        onTap: () => _selectDate(context, isManufactureDate),
        child: InputDecorator(
          decoration: InputDecoration(
            // labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedDate == null
                    ? 'Select Date'
                    : '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                style: const TextStyle(color: Colors.black54),
              ),
              const Icon(Icons.calendar_today),
            ],
          ),
        ),
      ),
    );
  }
}

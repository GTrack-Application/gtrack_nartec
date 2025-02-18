import 'package:flutter/material.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';

class AssetVerificationScreen extends StatefulWidget {
  const AssetVerificationScreen({super.key});

  @override
  State<AssetVerificationScreen> createState() =>
      _AssetVerificationScreenState();
}

class _AssetVerificationScreenState extends State<AssetVerificationScreen> {
  final List<String> _images = [];
  String? _selectedEmployee;
  String? _selectedCondition;
  String? _selectedBought;

  // Add controllers
  final TextEditingController _locationTagController = TextEditingController();
  final TextEditingController _assetTagController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _phoneExtController = TextEditingController();
  final TextEditingController _otherTagController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  // Add focus nodes
  final FocusNode _locationTagFocus = FocusNode();
  final FocusNode _assetTagFocus = FocusNode();
  final FocusNode _serialNumberFocus = FocusNode();
  final FocusNode _employeeIdFocus = FocusNode();
  final FocusNode _phoneExtFocus = FocusNode();
  final FocusNode _otherTagFocus = FocusNode();
  final FocusNode _noteFocus = FocusNode();

  @override
  void dispose() {
    // Dispose controllers
    _locationTagController.dispose();
    _assetTagController.dispose();
    _serialNumberController.dispose();
    _employeeIdController.dispose();
    _phoneExtController.dispose();
    _otherTagController.dispose();
    _noteController.dispose();

    // Dispose focus nodes
    _locationTagFocus.dispose();
    _assetTagFocus.dispose();
    _serialNumberFocus.dispose();
    _employeeIdFocus.dispose();
    _phoneExtFocus.dispose();
    _otherTagFocus.dispose();
    _noteFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.skyBlue,
        title: const Text('Asset Verification'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildScanField('Location Tag', 'Type/Scan location tag'),
            const SizedBox(height: 10),
            _buildScanField('Asset Tag', 'Type/Scan asset tag'),
            const SizedBox(height: 10),
            _buildLabelText('Asset Location details'),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('Auto fill'),
            ),
            const SizedBox(height: 10),
            _buildScanField('Serial number', 'Enter/scan serial number'),
            const SizedBox(height: 10),
            _buildLabelText('Employee Name'),
            DropdownButtonFormField<String>(
              value: _selectedEmployee,
              decoration: const InputDecoration(
                hintText: 'Select employee',
                border: OutlineInputBorder(),
              ),
              items: const [], // Add your employee list items here
              onChanged: (value) => setState(() => _selectedEmployee = value),
            ),
            const SizedBox(height: 10),
            _buildTextField('Employee ID', 'Enter employee ID'),
            const SizedBox(height: 10),
            _buildTextField('Phone Extention', 'Enter Phone ext'),
            const SizedBox(height: 10),
            _buildTextField('Other Tag', 'Enter any existing tag'),
            const SizedBox(height: 10),
            _buildLabelText('Note'),
            TextField(
              controller: _noteController,
              focusNode: _noteFocus,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'type a comment of an asset',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            _buildLabelText('Insert/take photo (add up to4 images)'),
            SizedBox(
              height: 100,
              child: Row(
                children: [
                  _buildAddPhotoButton(),
                  ..._buildPhotoList(),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildLabelText('Asset Condition'),
            DropdownButtonFormField<String>(
              value: _selectedCondition,
              decoration: const InputDecoration(
                hintText: 'Excellent',
                border: OutlineInputBorder(),
              ),
              items: const [], // Add condition items here
              onChanged: (value) => setState(() => _selectedCondition = value),
            ),
            const SizedBox(height: 10),
            _buildLabelText('Bought'),
            DropdownButtonFormField<String>(
              value: _selectedBought,
              decoration: const InputDecoration(
                hintText: 'New',
                border: OutlineInputBorder(),
              ),
              items: const [], // Add bought status items here
              onChanged: (value) => setState(() => _selectedBought = value),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton(
                  onPressed: () {
                    // Add your button press logic here
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelText(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildScanField(String label, String hint) {
    final controller = label == 'Location Tag'
        ? _locationTagController
        : label == 'Asset Tag'
            ? _assetTagController
            : _serialNumberController;

    final focusNode = label == 'Location Tag'
        ? _locationTagFocus
        : label == 'Asset Tag'
            ? _assetTagFocus
            : _serialNumberFocus;

    final nextFocus = label == 'Location Tag'
        ? _assetTagFocus
        : label == 'Asset Tag'
            ? _serialNumberFocus
            : _employeeIdFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabelText(label),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: hint,
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (_) => nextFocus.requestFocus(),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.qr_code_scanner),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint) {
    final controller = label == 'Employee ID'
        ? _employeeIdController
        : label == 'Phone Extention'
            ? _phoneExtController
            : _otherTagController;

    final focusNode = label == 'Employee ID'
        ? _employeeIdFocus
        : label == 'Phone Extention'
            ? _phoneExtFocus
            : _otherTagFocus;

    final nextFocus = label == 'Employee ID'
        ? _phoneExtFocus
        : label == 'Phone Extention'
            ? _otherTagFocus
            : _noteFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabelText(label),
        TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
          onSubmitted: (_) => nextFocus.requestFocus(),
        ),
      ],
    );
  }

  Widget _buildAddPhotoButton() {
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: const Icon(Icons.camera_alt, color: Colors.blue),
        onPressed: () {
          // Add photo capture logic here
        },
      ),
    );
  }

  List<Widget> _buildPhotoList() {
    return _images.map((image) {
      return Stack(
        children: [
          Container(
            width: 80,
            height: 80,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.red, size: 20),
              onPressed: () {
                setState(() => _images.remove(image));
              },
            ),
          ),
        ],
      );
    }).toList();
  }
}

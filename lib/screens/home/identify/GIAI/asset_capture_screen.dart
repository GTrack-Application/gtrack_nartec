import 'package:flutter/material.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/send_barcode_screen.dart';

class AssetCaptureScreen extends StatefulWidget {
  const AssetCaptureScreen({super.key});

  @override
  State<AssetCaptureScreen> createState() => _AssetCaptureScreenState();
}

class _AssetCaptureScreenState extends State<AssetCaptureScreen> {
  // Add controllers
  final TextEditingController _deptCodeController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _buildingNameController = TextEditingController();
  final TextEditingController _buildingNumberController =
      TextEditingController();

  // Add focus nodes
  final FocusNode _deptCodeFocus = FocusNode();
  final FocusNode _businessNameFocus = FocusNode();
  final FocusNode _buildingNameFocus = FocusNode();
  final FocusNode _buildingNumberFocus = FocusNode();

  @override
  void dispose() {
    // Dispose controllers
    _deptCodeController.dispose();
    _businessNameController.dispose();
    _buildingNameController.dispose();
    _buildingNumberController.dispose();

    // Dispose focus nodes
    _deptCodeFocus.dispose();
    _businessNameFocus.dispose();
    _buildingNameFocus.dispose();
    _buildingNumberFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.skyBlue,
        title: const Text('Asset Capture'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Country'),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Select Country',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                ),
                items: const [],
                onChanged: (value) {},
              ),
              const SizedBox(height: 10),
              const Text('City'),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Select City',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                ),
                items: const [],
                onChanged: (value) {},
              ),
              const SizedBox(height: 10),
              const Text('Department'),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Select department',
                  border: OutlineInputBorder(),
                ),
                items: const [],
                onChanged: (value) {},
              ),
              const SizedBox(height: 10),
              const Text('Department Code'),
              TextFormField(
                controller: _deptCodeController,
                focusNode: _deptCodeFocus,
                onEditingComplete: () {
                  _deptCodeFocus.unfocus();
                  _businessNameFocus.requestFocus();
                },
                decoration: const InputDecoration(
                  hintText: 'Auto Dept code',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                ),
                style: const TextStyle(height: 1),
              ),
              const SizedBox(height: 10),
              const Text('Business Name'),
              TextFormField(
                controller: _businessNameController,
                focusNode: _businessNameFocus,
                onEditingComplete: () {
                  _businessNameFocus.unfocus();
                  _buildingNameFocus.requestFocus();
                },
                decoration: const InputDecoration(
                  hintText: 'Auto business name',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                ),
              ),
              const SizedBox(height: 10),
              const Text('Building Name'),
              TextFormField(
                controller: _buildingNameController,
                focusNode: _buildingNameFocus,
                onEditingComplete: () {
                  _buildingNameFocus.unfocus();
                  _buildingNumberFocus.requestFocus();
                },
                decoration: const InputDecoration(
                  hintText: 'Type bldg name',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                ),
              ),
              const SizedBox(height: 10),
              const Text('Building Number'),
              TextFormField(
                controller: _buildingNumberController,
                focusNode: _buildingNumberFocus,
                onEditingComplete: () {
                  _buildingNumberFocus.unfocus();
                },
                decoration: const InputDecoration(
                  hintText: 'type bldg number',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                ),
              ),
              const SizedBox(height: 10),
              const Text('Floor Number'),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'select floor',
                  border: OutlineInputBorder(),
                ),
                items: const [],
                onChanged: (value) {},
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () {
                    AppNavigator.goToPage(
                        context: context, screen: SendBarcodeScreen());
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

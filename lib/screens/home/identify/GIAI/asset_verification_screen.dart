// ignore_for_file: unused_field, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/features/identify/cubits/GIAI/giai_cubit.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/cubit/fats_cubit.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/cubit/fats_state.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/model/employee_name_model.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/model/tag_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AssetVerificationScreen extends StatefulWidget {
  const AssetVerificationScreen({super.key});

  @override
  State<AssetVerificationScreen> createState() =>
      _AssetVerificationScreenState();
}

class _AssetVerificationScreenState extends State<AssetVerificationScreen> {
  final List<File> _images = [];

  List<String> _employeeNames = [];
  String? _selectedEmployee;

  String _selectedCondition = 'Excelent';
  final List<String> _conditions = ['Excelent', 'Fair', 'Damage', 'Pack Piece'];

  String _selectedBought = 'New';
  final List<String> _bought = ['New', 'Existing Asset'];

  final FatsCubit fatsCubit = FatsCubit();

  // Add controllers
  final TextEditingController _locationTagController = TextEditingController();
  final TextEditingController _assetTagController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _phoneExtController = TextEditingController();
  final TextEditingController _otherTagController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  // Add new controllers
  final TextEditingController _daoNameController = TextEditingController();
  final TextEditingController _businessUnitController = TextEditingController();
  final TextEditingController _buildingNameController = TextEditingController();
  final TextEditingController _buildingNoController = TextEditingController();
  final TextEditingController _floorNoController = TextEditingController();

  // Add focus nodes
  final FocusNode _locationTagFocus = FocusNode();
  final FocusNode _assetTagFocus = FocusNode();
  final FocusNode _serialNumberFocus = FocusNode();
  final FocusNode _employeeIdFocus = FocusNode();
  final FocusNode _phoneExtFocus = FocusNode();
  final FocusNode _otherTagFocus = FocusNode();
  final FocusNode _noteFocus = FocusNode();
  final FocusNode _assetLocationDetailsFocus = FocusNode();
  @override
  void dispose() {
    // Dispose existing controllers
    _locationTagController.dispose();
    _assetTagController.dispose();
    _serialNumberController.dispose();
    _employeeIdController.dispose();
    _phoneExtController.dispose();
    _otherTagController.dispose();
    _noteController.dispose();
    // Dispose new controllers
    _daoNameController.dispose();
    _businessUnitController.dispose();
    _buildingNameController.dispose();
    _buildingNoController.dispose();
    _floorNoController.dispose();
    _assetLocationDetailsFocus.dispose();
    _images.clear();

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
  void initState() {
    super.initState();
    fatsCubit.getEmployeeNames();
  }

  TagModel? tag;
  List<EmployeeNameModel>? employeeData;
  String? employeeId;

  final GIAICubit giaiCubit = GIAICubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.skyBlue,
        title: const Text('Asset Verification'),
      ),
      body: BlocConsumer<FatsCubit, FatsState>(
        bloc: fatsCubit,
        listener: (context, state) {
          if (state is FatsGetEmployeeNamesLoaded) {
            _employeeNames =
                state.employeeNames.map((e) => e.userName ?? "").toList();
            employeeData = state.employeeNames;
            _selectedEmployee = state.employeeNames.first.userName;
            _employeeIdController.text = state.employeeNames.first.email ?? "";
            employeeId = state.employeeNames.first.id;
          }
          if (state is FatsGetTagDetailsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message.replaceAll("Exception:", ""),
                  style: const TextStyle(
                    color: AppColors.white,
                  ),
                ),
                backgroundColor: AppColors.danger,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(10),
              ),
            );
          }
          if (state is FatsGetTagDetailsLoaded) {
            tag = state.tag;
            _locationTagController.text = tag?.locationTag ?? "";
            _serialNumberController.text = tag?.serialNumber ?? "";
            _phoneExtController.text = tag?.phoneExtNo ?? "";
            _otherTagController.text = tag?.aTMNumber ?? "";
            _noteController.text = tag?.deliveryNoteNo ?? "";
            tag?.fullLocationDetails ?? "";
            _daoNameController.text = tag?.daoName ?? "";
            _businessUnitController.text = tag?.businessUnit ?? "";
            _buildingNameController.text = tag?.buildingName ?? "";
            _buildingNoController.text = tag?.buildingNo ?? "";
            _floorNoController.text = tag?.floorNo ?? "";
          }
          if (state is FatsHandleSubmitError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.danger,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(10),
                action: SnackBarAction(
                  label: 'Close',
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            );
          }
          if (state is FatsHandleSubmitLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(10),
                action: SnackBarAction(
                  label: 'Close',
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            );

            // empty the images and clear the text fields
            _images.clear();
            _locationTagController.clear();
            _assetTagController.clear();
            _serialNumberController.clear();
            _employeeIdController.clear();
            _phoneExtController.clear();
            _otherTagController.clear();
            _noteController.clear();

            giaiCubit.getGIAI();
          }
          if (state is FatsHandleSubmitError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message.replaceAll("Exception:", "")),
                backgroundColor: AppColors.danger,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(10),
                action: SnackBarAction(
                  label: 'Close',
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _buildScanField('Asset Tag', 'Type/Scan asset tag',
                          (value) {
                        if (value.isEmpty) {
                          FocusScope.of(context).unfocus();
                        }

                        fatsCubit.getTagDetails(value.trim());
                      }),
                    ),
                    const SizedBox(width: 8),
                    state is FatsGetTagDetailsLoading
                        ? const CircularProgressIndicator(
                            strokeWidth: 2,
                            backgroundColor: AppColors.white,
                          )
                        : GestureDetector(
                            onTap: () {
                              fatsCubit.getTagDetails(_assetTagController.text);
                            },
                            child: const Icon(Icons.qr_code_scanner),
                          ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildTextField('Location Tag', 'Type/Scan location tag'),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: tag?.fullLocationDetails != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Asset Location details',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                                "${tag?.daoName ?? ""} - ${tag?.businessUnit}"),
                            Text(tag?.buildingName ?? ""),
                            Text("${tag?.buildingNo ?? ""} - ${tag?.floorNo}"),
                          ],
                        )
                      : const SizedBox(),
                ),
                const SizedBox(height: 10),
                _buildTextField('Serial number', 'Enter serial number'),
                const SizedBox(height: 10),
                _buildLabelText('Employee Name'),
                DropdownButtonFormField<String>(
                  value: _selectedEmployee,
                  dropdownColor: AppColors.white,
                  decoration: const InputDecoration(
                    hintText: 'Select employee',
                    border: OutlineInputBorder(),
                  ),
                  items: _employeeNames
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedEmployee = value;
                      _employeeIdController.text = employeeData
                              ?.firstWhere((e) => e.userName == value)
                              .email ??
                          "";
                      employeeId = employeeData
                              ?.firstWhere((e) => e.userName == value)
                              .id ??
                          "";
                    });
                  },
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
                _buildLabelText('Insert/take photo (add up to 4 images)'),
                SizedBox(
                  height: 100,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildAddPhotoButton(),
                        ..._buildPhotoList(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _buildLabelText('Asset Condition'),
                DropdownButtonFormField<String>(
                  value: _selectedCondition,
                  dropdownColor: AppColors.white,
                  decoration: const InputDecoration(
                    hintText: 'Excellent',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      _conditions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _selectedCondition = value!),
                ),
                const SizedBox(height: 10),
                _buildLabelText('Bought'),
                DropdownButtonFormField<String>(
                  value: _selectedBought,
                  dropdownColor: AppColors.white,
                  decoration: const InputDecoration(
                    hintText: 'New',
                    border: OutlineInputBorder(),
                  ),
                  items: _bought.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _selectedBought = value!),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton(
                      onPressed: () async {
                        if (_images.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please add at least one image'),
                            ),
                          );
                        } else if (tag == null ||
                            _locationTagController.text.isEmpty ||
                            _assetTagController.text.isEmpty ||
                            _serialNumberController.text.isEmpty ||
                            _employeeIdController.text.isEmpty ||
                            _phoneExtController.text.isEmpty ||
                            _otherTagController.text.isEmpty ||
                            _noteController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill all the fields'),
                            ),
                          );
                        } else {
                          await fatsCubit.handleSubmit(
                            tag?.id ?? "",
                            employeeId ?? "",
                            _assetTagController.text,
                            _locationTagController.text,
                            _serialNumberController.text,
                            _employeeIdController.text,
                            _phoneExtController.text,
                            _otherTagController.text,
                            _noteController.text,
                            _selectedCondition,
                            _selectedBought,
                            _locationTagController.text,
                            _images,
                            "${_daoNameController.text} - ${_businessUnitController.text}\n${_buildingNameController.text}\n${_buildingNoController.text} - ${_floorNoController.text}",
                          );
                        }
                      },
                      child: state is FatsHandleSubmitLoading
                          ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              backgroundColor: AppColors.white,
                            )
                          : const Text('Save'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
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

  Widget _buildScanField(
    String label,
    String hint,
    Function(String) onScan,
  ) {
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
        TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
          onSubmitted: (_) {
            nextFocus.requestFocus();
            onScan(controller.text.trim());
          },
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint) {
    final controller = switch (label) {
      'Employee ID' => _employeeIdController,
      'Phone Extention' => _phoneExtController,
      'Other Tag' => _otherTagController,
      'Location Tag' => _locationTagController,
      'Serial number' => _serialNumberController,
      'DAO Name' => _daoNameController,
      'Business Unit' => _businessUnitController,
      'Building Name' => _buildingNameController,
      'Building No' => _buildingNoController,
      'Floor No' => _floorNoController,
      _ => _otherTagController, // default case
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabelText(label),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
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
          if (_images.length >= 4) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Maximum 4 images allowed'),
                backgroundColor: AppColors.danger,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(10),
                action: SnackBarAction(
                  label: 'Close',
                  textColor: AppColors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            );
            return;
          }
          _showImageSourceDialog();
        },
      ),
    );
  }

  Future<void> _showImageSourceDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: const Text(
            'Select Image Source',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.camera,
                  color: AppColors.black,
                ),
                title: const Text(
                  'Camera',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColors.black,
                ),
                title: const Text(
                  'Gallery',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        setState(() {
          _images.add(File(image.path));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: AppColors.danger,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  List<Widget> _buildPhotoList() {
    return _images.map((File image) {
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
                image: FileImage(image),
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

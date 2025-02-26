import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/cubit/fats_cubit.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/cubit/fats_state.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/model/city_model.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/model/country_model.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/model/state_model.dart';
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
  final TextEditingController _areaController = TextEditingController();

  // Add focus nodes
  final FocusNode _deptCodeFocus = FocusNode();
  final FocusNode _businessNameFocus = FocusNode();
  final FocusNode _buildingNameFocus = FocusNode();
  final FocusNode _buildingNumberFocus = FocusNode();
  final FocusNode _areaFocus = FocusNode();

  List<CountryModel> countryList = [];
  CountryModel? selectedCountry;
  List<StateModel> stateList = [];
  StateModel? selectedState;
  List<CityModel> cityList = [];
  CityModel? selectedCity;
  final List<String> departmentList = [
    'Human Resources',
    'Information Technology',
    'Finance',
    'Marketing',
    'Operations',
    'Sales',
    'Research & Development',
    'Administration',
  ];

  String selectDepartment = '';

  final List<String> floorNumberList = [
    '1st Floor',
    '2nd Floor',
    '3rd Floor',
    '4th Floor',
    '5th Floor',
  ];
  String? selectedFloor;

  final FatsCubit fatsCubit = FatsCubit();

  @override
  void initState() {
    super.initState();
    // Fetch countries when screen loads
    fatsCubit.getCountries();
  }

  @override
  void dispose() {
    // Dispose controllers
    _deptCodeController.dispose();
    _businessNameController.dispose();
    _buildingNameController.dispose();
    _buildingNumberController.dispose();
    _areaController.dispose();

    // Dispose focus nodes
    _deptCodeFocus.dispose();
    _businessNameFocus.dispose();
    _buildingNameFocus.dispose();
    _buildingNumberFocus.dispose();
    _areaFocus.dispose();

    super.dispose();
  }

  void _validateAndNavigate() {
    String errorMessage = '';

    if (selectedCountry == null) {
      errorMessage = 'Please select a country';
    } else if (selectedState == null) {
      errorMessage = 'Please select a state';
    } else if (selectedCity == null) {
      errorMessage = 'Please select a city';
    } else if (_areaController.text.trim().isEmpty) {
      errorMessage = 'Please enter an area';
    } else if (selectDepartment.isEmpty) {
      errorMessage = 'Please select a department';
    } else if (_deptCodeController.text.trim().isEmpty) {
      errorMessage = 'Please enter department code';
    } else if (_businessNameController.text.trim().isEmpty) {
      errorMessage = 'Please enter business name';
    } else if (_buildingNameController.text.trim().isEmpty) {
      errorMessage = 'Please enter building name';
    } else if (_buildingNumberController.text.trim().isEmpty) {
      errorMessage = 'Please enter building number';
    } else if (selectedFloor == null) {
      errorMessage = 'Please select a floor';
    }

    if (errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Create a map of the form data
      final Map<String, dynamic> assetData = {
        'country': selectedCountry,
        'state': selectedState,
        'city': selectedCity,
        'area': _areaController.text,
        'department': selectDepartment,
        'departmentCode': _deptCodeController.text,
        'businessName': _businessNameController.text,
        'buildingName': _buildingNameController.text,
        'buildingNumber': _buildingNumberController.text,
        'floorNumber': selectedFloor,
      };

      AppNavigator.goToPage(
        context: context,
        screen: SendBarcodeScreen(assetData: assetData),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.skyBlue,
        title: const Text('Asset Capture'),
      ),
      body: BlocConsumer<FatsCubit, FatsState>(
        bloc: fatsCubit,
        listener: (context, state) {
          if (state is FatsCountryLoaded) {
            setState(() {
              countryList = state.countries;
            });
          } else if (state is FatsStateLoaded) {
            setState(() {
              stateList = state.states;
            });
          } else if (state is FatsCityLoaded) {
            setState(() {
              cityList = state.cities;
            });
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Country'),
                  DropdownButtonFormField<CountryModel>(
                    dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      hintText: 'Select Country',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    items: countryList.map((CountryModel country) {
                      return DropdownMenuItem<CountryModel>(
                        value: country,
                        child: Text(country.nameEn ?? ''),
                      );
                    }).toList(),
                    value: selectedCountry,
                    onChanged: (CountryModel? value) {
                      setState(() {
                        selectedCountry = value;
                        selectedState = null;
                        selectedCity = null;
                        stateList.clear();
                        cityList.clear();
                      });
                      if (value?.id != null) {
                        fatsCubit.getStates(value!.id!);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text('State'),
                  DropdownButtonFormField<StateModel>(
                    dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      hintText: 'Select State',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    items: stateList.map((StateModel state) {
                      return DropdownMenuItem<StateModel>(
                        value: state,
                        child: Text(state.name ?? ''),
                      );
                    }).toList(),
                    value: selectedState,
                    onChanged: (StateModel? value) {
                      setState(() {
                        selectedState = value;
                        selectedCity = null;
                        cityList.clear();
                      });
                      if (value?.id != null) {
                        fatsCubit.getCities(value!.id!);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text('City'),
                  DropdownButtonFormField<CityModel>(
                    dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      hintText: 'Select City',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    items: cityList.map((CityModel city) {
                      return DropdownMenuItem<CityModel>(
                        value: city,
                        child: Text(city.name ?? ''),
                      );
                    }).toList(),
                    value: selectedCity,
                    onChanged: (CityModel? value) {
                      setState(() {
                        selectedCity = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text('Area'),
                  TextFormField(
                    controller: _areaController,
                    focusNode: _areaFocus,
                    decoration: const InputDecoration(
                      hintText: 'Enter area',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Department'),
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      hintText: 'Select department',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    items: departmentList.map((String department) {
                      return DropdownMenuItem<String>(
                        value: department,
                        child: Text(department),
                      );
                    }).toList(),
                    value: selectDepartment.isEmpty ? null : selectDepartment,
                    onChanged: (value) {
                      setState(() {
                        selectDepartment = value ?? '';
                      });
                    },
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
                    dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      hintText: 'select floor',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    items: floorNumberList.map((String floor) {
                      return DropdownMenuItem<String>(
                        value: floor,
                        child: Text(floor),
                      );
                    }).toList(),
                    value: selectedFloor,
                    onChanged: (value) {
                      setState(() {
                        selectedFloor = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: _validateAndNavigate,
                      child: const Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

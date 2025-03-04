// ignore_for_file: library_private_types_in_public_api, prefer_collection_literals

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gtrack_nartec/blocs/Identify/gln/gln_cubit.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_nartec/screens/home/identify/GLN/gln_cubit/gln_cubit.dart';
import 'package:gtrack_nartec/screens/home/identify/GLN/gln_cubit/gln_state.dart';
import 'package:image_picker/image_picker.dart';

class AddGlnScreen extends StatefulWidget {
  const AddGlnScreen({super.key});

  @override
  _AddGlnScreenState createState() => _AddGlnScreenState();
}

class _AddGlnScreenState extends State<AddGlnScreen> {
  GoogleMapController? mapController;
  LatLng _currentPosition =
      const LatLng(24.7136, 46.6753); // Initial position (Riyadh, Saudi Arabia)
  final TextEditingController _locationNameEngController =
      TextEditingController();
  final TextEditingController _locationNameArController =
      TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressArController = TextEditingController();
  final TextEditingController _poBoxController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updatePosition(_currentPosition); // Initialize with the starting position
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _updatePosition(LatLng position) async {
    setState(() {
      _currentPosition = position;
      _latController.text = position.latitude.toString();
      _lngController.text = position.longitude.toString();
    });

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      setState(() {
        _addressController.text =
            '${place.street}, ${place.locality}, ${place.country}';
        _addressArController.text =
            '${place.street}, ${place.locality}, ${place.country}';
      });
    }
  }

  @override
  void dispose() {
    _latController.dispose();
    _lngController.dispose();
    _addressController.dispose();
    _addressArController.dispose();
    super.dispose();
  }

  String glnLocation = "Legal Entity";
  List<String> glnLocationList = [
    "Legal Entity",
    "Function",
    "Physical Location",
    "Digital Location",
  ];

  String status = "active";
  List<String> statusList = [
    "active",
    "inactive",
  ];

  String? _selectedImageText;

  void _openImageSelectorDialog() async {
    final selectedImageText = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return ImageSelectorDialog();
      },
    );

    if (selectedImageText != null) {
      setState(() {
        _selectedImageText = selectedImageText;
      });
    }
  }

  GLNCubit glnCubit = GLNCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.skyBlue,
        title: const Text(
          'Add GLN',
        ),
        // back button color will be white
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _currentPosition,
                  zoom: 14.0,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('currentPosition'),
                    position: _currentPosition,
                    draggable: true,
                    onDragEnd: _updatePosition,
                  ),
                },
                gestureRecognizers: Set()
                  ..add(Factory<PanGestureRecognizer>(
                      () => PanGestureRecognizer()))
                  ..add(Factory<ScaleGestureRecognizer>(
                      () => ScaleGestureRecognizer()))
                  ..add(Factory<TapGestureRecognizer>(
                      () => TapGestureRecognizer()))
                  ..add(Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer())),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  const Text(
                    "   What does a GLN identify ?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  // dropdown for gln location
                  Container(
                    height: 70,
                    padding: const EdgeInsets.all(8.0),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: glnLocation,
                          items: glnLocationList
                              .map((String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ))
                              .toList(),
                          onChanged: (String? value) {
                            setState(() {
                              glnLocation = value!;
                            });
                            _openImageSelectorDialog();
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Location Name [Eng]',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12.0),
                      ),
                      controller: _locationNameEngController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Location Name [Ar]',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12.0),
                      ),
                      controller: _locationNameArController,
                    ),
                  ),
                  //
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Address Name [Eng]',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12.0),
                      ),
                      controller: _addressController,
                      readOnly: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Address Name [Ar]',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12.0),
                      ),
                      controller: _addressArController,
                      readOnly: true,
                    ),
                  ),
                  // postal code
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Postal Code',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12.0),
                      ),
                      controller: _postalCodeController,
                    ),
                  ),
                  // po box
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'PO Box',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12.0),
                      ),
                      controller: _poBoxController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Latitude',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12.0),
                      ),
                      controller: _latController,
                      readOnly: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Longitude',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12.0),
                      ),
                      controller: _lngController,
                      readOnly: true,
                    ),
                  ),
                  // status dropdouwn
                  Container(
                    height: 70,
                    padding: const EdgeInsets.all(8.0),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: status,
                          items: statusList
                              .map((String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ))
                              .toList(),
                          onChanged: (String? value) {
                            setState(() {
                              status = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  // Image picker
                  Align(
                    alignment: Alignment.center,
                    child: buildImagePicker(
                      'Image',
                      image,
                      MediaQuery.of(context).size.width * 0.4,
                      MediaQuery.of(context).size.height * 0.2,
                      MediaQuery.of(context).size.width * 0.4,
                      MediaQuery.of(context).size.height * 0.05,
                      15,
                      12,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Save button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BlocConsumer<GLNCubit, GLNState>(
        bloc: glnCubit,
        listener: (context, state) {
          if (state is GLNLoaded) {
            AppSnackbars.success(
              context,
              "GLN added successfully",
            );
            context.read<GlnCubit>().getGlnData();
            Navigator.of(context).pop();
          }
          if (state is GLNError) {
            AppSnackbars.danger(context, state.message);
          }
        },
        builder: (context, state) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 50),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            child: PrimaryButtonWidget(
              text: 'Add GLN',
              isLoading: state is GLNLoading,
              backgroungColor: AppColors.skyBlue,
              loadingColor: AppColors.skyBlue,
              onPressed: () {
                if (_locationNameEngController.text.trim().isEmpty ||
                    _addressController.text.trim().isEmpty ||
                    _addressArController.text.trim().isEmpty ||
                    _poBoxController.text.trim().isEmpty ||
                    _postalCodeController.text.trim().isEmpty ||
                    _lngController.text.trim().isEmpty ||
                    _selectedImageText == null ||
                    glnLocation.toString().isEmpty ||
                    _latController.text.trim().isEmpty) {
                  AppSnackbars.warning(
                    context,
                    "Please fill all the fields",
                  );
                  return;
                }
                glnCubit.postGln(
                  _locationNameEngController.text.trim(),
                  _addressController.text.trim(),
                  _addressArController.text.trim(),
                  _poBoxController.text.trim(),
                  _postalCodeController.text.trim(),
                  _lngController.text.trim(),
                  _latController.text.trim(),
                  status,
                  image,
                  _selectedImageText!,
                  glnLocation.toString(),
                  _locationNameArController.text.trim(),
                );
              },
            ),
          );
        },
      ),
    );
  }

  File? image;
  final ImagePicker _picker = ImagePicker();

  onImagePick() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    image = File(pickedFile!.path);
    setState(() {});
  }

  Widget buildImagePicker(
    String label,
    File? image,
    double width,
    double height,
    double btnWidth,
    double btnHeight,
    double textSize,
    double btnText,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: onImagePick,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                width: width,
                height: height,
                color: Colors.grey[200],
                child: image != null
                    ? Image.file(image, fit: BoxFit.cover)
                    : Center(
                        child: Text(
                          label,
                          style: TextStyle(fontSize: textSize),
                        ),
                      ),
              ),
            ),
            // for adding image
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: IconButton(
                    onPressed: onImagePick,
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ImageSelectorDialog extends StatelessWidget {
  final List<Map<String, String>> images = [
    {'path': 'assets/glnpop/glnBank.png', 'text': 'Bank'},
    {'path': 'assets/glnpop/glnbarn.png', 'text': 'Barn'},
    {'path': 'assets/glnpop/glnClinic.png', 'text': 'Clinic'},
    {
      'path': 'assets/glnpop/glnColdStore.png',
      'text': 'Cold storage within a warehouse'
    },
    {
      'path': 'assets/glnpop/glnCorporate.png',
      'text': 'Corporate Headquarters'
    },
    {
      'path': 'assets/glnpop/glnDistribution.png',
      'text': 'Distribution centre'
    },
    {'path': 'assets/glnpop/glndockdoor.png', 'text': 'Dock door'},
    {'path': 'assets/glnpop/glnFactory.png', 'text': 'Factory'},
    {'path': 'assets/glnpop/glnGroceryStore.png', 'text': 'Grocery store'},
    {
      'path': 'assets/glnpop/glnMobileBlood.png',
      'text': 'Mobile blood donation van'
    },
    {'path': 'assets/glnpop/glnport.png', 'text': 'Port'},
    {'path': 'assets/glnpop/glnShelf.png', 'text': 'Shelf'},
  ];

  ImageSelectorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFEAF7F6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.skyBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.image, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Select GLN Type Icon',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Grid content
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => Navigator.pop(context, images[index]['text']),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            images[index]['path'].toString(),
                            height: 50,
                            width: 50,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Text(
                              images[index]['text'].toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                              // maxLines: 2,
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Footer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

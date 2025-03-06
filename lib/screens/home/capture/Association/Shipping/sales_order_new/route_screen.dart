// ignore_for_file: unused_field, unused_element, use_build_context_synchronously

import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/material.dart';
import 'package:gtrack_nartec/cubit/capture/association/shipping/sales_order/sales_order_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/shipping/sales_order/sales_order_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/sales_order/map_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/sales_order/sub_sales_order_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Shipping/sales_order_new/journey_screen.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({
    super.key,
    required this.customerId,
    required this.salesOrderId,
    required this.subSalesOrder,
  });

  final String customerId;
  final String salesOrderId;
  final List<SubSalesOrderModel> subSalesOrder;

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  GoogleMapController? mapController;
  LatLng? _currentLocation;
  LatLng? _destinationLocation;
  bool _isLoading = true;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  double _distanceInKm = 0.0;

  @override
  void initState() {
    super.initState();
    salesOrderCubit = SalesOrderCubit();
    _loadMapData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mapController != null) {
      // Re-initialize the map if the controller is already available
      _initializeLocation(_destinationLocation?.latitude ?? 0.0,
          _destinationLocation?.longitude ?? 0.0);
    }
  }

  void _loadMapData() {
    // Reset loading state
    setState(() {
      _isLoading = true;
      _currentLocation = null;
      _destinationLocation = null;
      _markers.clear();
      _polylines.clear();
    });

    // Get map model data
    salesOrderCubit.getMapModel(widget.customerId);
  }

  late final SalesOrderCubit salesOrderCubit;

  void _initializeLocation(double latitude, double longitude) async {
    Location location = Location();

    try {
      // Configure location settings first
      await location.changeSettings(
        interval: 1000,
        distanceFilter: 10,
      );

      // Check if location service is enabled
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location services are disabled')),
          );
          return;
        }
      }

      // Check location permissions
      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
          return;
        }
      }

      // Get initial location before starting stream
      final initialLocation = await location.getLocation();
      if (!mounted) return;

      setState(() {
        _currentLocation =
            LatLng(initialLocation.latitude!, initialLocation.longitude!);
        _destinationLocation = LatLng(latitude, longitude);
        _updateMarkers();
        _calculateDistance();
      });

      // Start location updates after initial setup
      location.onLocationChanged.listen((LocationData currentLocation) {
        if (!mounted) return;
        setState(() {
          _currentLocation =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _updateMarkers();
          _calculateDistance();
        });
      });

      setState(() => _isLoading = false);
    } catch (e) {
      print("Error initializing location: $e");
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }
  }

  void _updateCameraPosition() {
    if (_currentLocation != null && _destinationLocation != null) {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          min(_currentLocation!.latitude, _destinationLocation!.latitude),
          min(_currentLocation!.longitude, _destinationLocation!.longitude),
        ),
        northeast: LatLng(
          max(_currentLocation!.latitude, _destinationLocation!.latitude),
          max(_currentLocation!.longitude, _destinationLocation!.longitude),
        ),
      );
      mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
  }

  void _calculateDistance() {
    if (!mounted) return; // Exit if the widget is no longer in the tree

    setState(() {
      _distanceInKm = Geolocator.distanceBetween(
            _currentLocation!.latitude,
            _currentLocation!.longitude,
            _destinationLocation!.latitude,
            _destinationLocation!.longitude,
          ) /
          1000; // Convert to kilometers
    });
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  List<MapModel>? mapModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.pink,
        title: const Text("Route Details"),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocConsumer<SalesOrderCubit, SalesOrderState>(
        bloc: salesOrderCubit,
        listener: (context, state) {
          if (state is MapModelLoaded) {
            mapModel = state.mapModel;
            _initializeLocation(
              double.parse(mapModel![0].latitude!),
              double.parse(mapModel![0].longitude!),
            );
          }
          if (state is MapModelError) {
            _initializeLocation(24.774369, 46.738586);
          }
          if (state is StatusUpdateLoaded) {
            AppNavigator.replaceTo(
              context: context,
              screen: JourneyScreen(
                customerId: widget.customerId,
                salesOrderId: widget.salesOrderId,
                mapModel: mapModel!,
                subSalesOrder: widget.subSalesOrder,
              ),
            );
          }
          if (state is StatusUpdateError) {
            AppSnackbars.danger(
              context,
              state.message.replaceAll("Exception: ", ""),
            );
          }
        },
        builder: (context, state) {
          if (state is MapModelLoading || _currentLocation == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.pink),
            );
          }

          if (state is MapModelError && _currentLocation != null) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: buildMapAndInfoContent(
                  () {},
                  const Center(
                    child: Text(
                      "Start Journey",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          }

          if (state is MapModelLoaded && _currentLocation != null) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: buildMapAndInfoContent(
                  () {
                    final now = DateTime.now();
                    salesOrderCubit.statusUpdate(widget.salesOrderId,
                        {"startJourneyTime": now.toIso8601String()});
                  },
                  state is StatusUpdateLoading
                      ? const Center(
                          child:
                              CircularProgressIndicator(color: AppColors.white),
                        )
                      : const Center(
                          child: Text(
                            "Start Journey",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget buildMapAndInfoContent(
    Function() onTap,
    Widget buttonWidget,
  ) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.45,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary),
          ),
          child: GoogleMap(
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
              // Animate to show both markers
              if (_currentLocation != null && _destinationLocation != null) {
                LatLngBounds bounds = LatLngBounds(
                  southwest: LatLng(
                    min(_currentLocation!.latitude,
                        _destinationLocation!.latitude),
                    min(_currentLocation!.longitude,
                        _destinationLocation!.longitude),
                  ),
                  northeast: LatLng(
                    max(_currentLocation!.latitude,
                        _destinationLocation!.latitude),
                    max(_currentLocation!.longitude,
                        _destinationLocation!.longitude),
                  ),
                );
                controller
                    .animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
              }
            },
            initialCameraPosition: CameraPosition(
              target: _currentLocation!,
              zoom: 14,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            mapType: MapType.normal,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (mapModel != null) ...[
                InfoRow(
                  label: "Customer's Name:",
                  value: mapModel![0].companyNameEnglish ?? "N/A",
                ),
                const SizedBox(height: 10),
                InfoRow(
                  label: 'Contact Person:',
                  value: mapModel![0].contactPerson ?? "N/A",
                ),
                const SizedBox(height: 10),
                InfoRow(
                  label: 'Date Assigned:',
                  value: mapModel![0].createdAt != null
                      ? DateFormat('dd/MM/yyyy').format(
                          DateTime.parse(mapModel![0].createdAt!),
                        )
                      : "N/A",
                ),
                const SizedBox(height: 10),
                InfoRow(
                  label: 'Mobile Number:',
                  value: mapModel![0].mobileNo ?? "N/A",
                ),
                const SizedBox(height: 10),
                InfoRow(
                  label: 'Company Name:',
                  value: mapModel![0].companyNameArabic ?? "N/A",
                ),
              ] else ...[
                const InfoRow(
                  label: "Status:",
                  value: "No customer information available",
                ),
              ],
              const SizedBox(height: 10),
            ],
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(5),
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.pink,
              borderRadius: BorderRadius.circular(10),
            ),
            child: buttonWidget,
          ),
        ),
      ],
    );
  }

  void _updateMarkers() {
    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: _currentLocation!,
        infoWindow: const InfoWindow(title: 'Current Location'),
      ),
    );
    _markers.add(
      Marker(
        markerId: const MarkerId('destinationLocation'),
        position: _destinationLocation!,
        infoWindow: const InfoWindow(title: 'Destination Location'),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

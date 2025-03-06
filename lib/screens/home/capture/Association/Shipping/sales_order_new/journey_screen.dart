// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/association/shipping/sales_order/sales_order_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/shipping/sales_order/sales_order_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/sales_order/map_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/sales_order/sub_sales_order_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Shipping/sales_order_new/action_screen.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({
    super.key,
    required this.customerId,
    required this.salesOrderId,
    required this.mapModel,
    required this.subSalesOrder,
  });

  final String customerId;
  final String salesOrderId;
  final List<MapModel> mapModel;
  final List<SubSalesOrderModel> subSalesOrder;

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  bool _hasArrived = true;

  // Initialize the markers
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _addDestinationMarker();
  }

  Future<void> _initializeLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: _currentLocation!,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: const InfoWindow(title: 'Current Location'),
          ),
        );
      });
      _startLocationUpdates();
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  void _startLocationUpdates() {
    Geolocator.getPositionStream().listen((position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _updateCurrentLocationMarker();
        _checkArrival();
      });
    });
  }

  void _addDestinationMarker() {
    final destinationLocation = LatLng(
      double.parse(widget.mapModel[0].latitude!),
      double.parse(widget.mapModel[0].longitude!),
    );
    _markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: destinationLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'Destination'),
      ),
    );
  }

  void _updateCurrentLocationMarker() {
    _markers.removeWhere(
        (marker) => marker.markerId == const MarkerId('current_location'));
    _markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: _currentLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Current Location'),
      ),
    );
  }

  void _checkArrival() {
    if (_currentLocation != null) {
      final distance = Geolocator.distanceBetween(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        double.parse(widget.mapModel[0].latitude!),
        double.parse(widget.mapModel[0].longitude!),
      );
      // Consider arrived if within 50 meters
      setState(() {
        _hasArrived = distance <= 50;
      });
    }
  }

  final SalesOrderCubit salesOrderCubit = SalesOrderCubit();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SalesOrderCubit, SalesOrderState>(
      bloc: salesOrderCubit,
      listener: (context, state) {
        if (state is StatusUpdateLoaded) {
          AppNavigator.replaceTo(
            context: context,
            screen: ActionScreen(
              customerId: widget.customerId,
              salesOrderId: widget.salesOrderId,
              mapModel: widget.mapModel,
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
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.pink,
            title: const Text('Journey'),
            centerTitle: true,
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottomNavigationBar: !_hasArrived
              ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 15,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: AppColors.pink,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Delivery Address',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.mapModel[0].address ??
                                      'No address provided',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.gps_fixed,
                                  color: AppColors.pink,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Coordinates',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${widget.mapModel[0].latitude}, ${widget.mapModel[0].longitude}',
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.pink,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              // current date
                              final now = DateTime.now();
                              await salesOrderCubit.statusUpdate(
                                widget.salesOrderId,
                                {'arrivalTime': now.toIso8601String()},
                              );
                            },
                            icon: state is StatusUpdateLoading
                                ? null
                                : const Icon(
                                    Icons.check_circle_outline,
                                    size: 20,
                                  ),
                            label: state is StatusUpdateLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.white,
                                    ),
                                  )
                                : const Text(
                                    'Arrived ?',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : null,
          body: _currentLocation == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation!,
                    zoom: 15,
                  ),
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onMapCreated: (controller) => _mapController = controller,
                ),
        );
      },
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

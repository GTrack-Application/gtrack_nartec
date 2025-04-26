// ignore_for_file: unused_field, unused_element, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gtrack_nartec/cubit/capture/association/shipping/sales_order/sales_order_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/shipping/sales_order/sales_order_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/sales_order/map_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/sales_order/sales_order_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/sales_order/sub_sales_order_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Shipping/sales_order_new/journey_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({
    super.key,
    required this.customerId,
    required this.salesOrderId,
    required this.subSalesOrder,
    required this.salesOrderModel,
  });

  final String customerId;
  final String salesOrderId;
  final List<SubSalesOrderModel> subSalesOrder;
  final SalesOrderModel salesOrderModel;

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
  DateTime? _lastRouteUpdateTime;

  @override
  void initState() {
    super.initState();
    print(widget.subSalesOrder);
    print(widget.subSalesOrder.length);
    print(widget.subSalesOrder[0].id);

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
      // Configure location settings first - reduce update frequency to prevent overloading
      await location.changeSettings(
        interval: 5000, // Increase to 5 seconds from 1 second
        distanceFilter: 20, // Increase to 20 meters from 10
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
      try {
        final initialLocation = await location.getLocation().timeout(
              const Duration(seconds: 10),
              onTimeout: () =>
                  throw TimeoutException("Location request timed out"),
            );
        if (!mounted) return;

        if (initialLocation.latitude == null ||
            initialLocation.longitude == null) {
          throw Exception("Invalid location data received");
        }

        setState(() {
          _currentLocation =
              LatLng(initialLocation.latitude!, initialLocation.longitude!);
          _destinationLocation = LatLng(latitude, longitude);
          _updateMarkers();
          _calculateDistance();
        });

        // Use a less frequent listener for location updates
        location.onLocationChanged.listen((LocationData currentLocation) {
          if (!mounted) return;

          if (currentLocation.latitude != null &&
              currentLocation.longitude != null) {
            setState(() {
              _currentLocation =
                  LatLng(currentLocation.latitude!, currentLocation.longitude!);
              _updateMarkers();
              _calculateDistance();
            });
          }
        });
      } catch (e) {
        print("Error getting initial location: $e");
        // Fallback to setting destination only
        if (!mounted) return;
        setState(() {
          _destinationLocation = LatLng(latitude, longitude);
          // Use a default current location if needed
          _currentLocation =
              LatLng(latitude - 0.01, longitude - 0.01); // Small offset
          _updateMarkers();
        });
      }

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
    if (mapController == null ||
        _currentLocation == null ||
        _destinationLocation == null) return;

    try {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          min(_currentLocation!.latitude, _destinationLocation!.latitude) -
              0.005,
          min(_currentLocation!.longitude, _destinationLocation!.longitude) -
              0.005,
        ),
        northeast: LatLng(
          max(_currentLocation!.latitude, _destinationLocation!.latitude) +
              0.005,
          max(_currentLocation!.longitude, _destinationLocation!.longitude) +
              0.005,
        ),
      );
      mapController
          ?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50))
          .catchError((error) {
        print("Error updating camera position: $error");
        // Fallback to a simpler camera position
        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(_currentLocation!, 13),
        );
      });
    } catch (e) {
      print("Error setting camera bounds: $e");
      // Fallback to focusing on current location
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 13),
      );
    }
  }

  void _calculateDistance() {
    if (!mounted) return; // Exit if the widget is no longer in the tree

    // Check if both locations are available before calculating distance
    if (_currentLocation == null || _destinationLocation == null) return;

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
    // Cancel any active streams or timers here
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
            print("MapModelLoaded: ${state.mapModel}");
            mapModel = state.mapModel;

            if (mapModel != null && mapModel!.isNotEmpty) {
              _initializeLocation(
                double.parse(mapModel![0].latitude!),
                double.parse(mapModel![0].longitude!),
              );
            } else {
              // Handle empty map model with a default location or error message
              _initializeLocation(24.774369, 46.738586); // Default coordinates
              AppSnackbars.danger(
                  context, "No location data available for this customer");
              setState(() {
                _isLoading = false;
              });
            }
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
                salesOrderModel: widget.salesOrderModel,
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
                    salesOrderCubit.statusUpdate(
                      widget.salesOrderId,
                      {"startJourneyTime": now.toIso8601String()},
                      state.mapModel[0].latitude,
                      state.mapModel[0].longitude!,
                      state.mapModel[0].gln!,
                      widget.subSalesOrder
                          .map(
                            (e) => "urn:epc:id:sgtin:${e.productId}",
                          )
                          .toList(),
                      widget.subSalesOrder
                          .map(
                            (e) => {
                              "type":
                                  widget.salesOrderModel.purchaseOrderNumber,
                              "bizTransaction":
                                  "${widget.salesOrderModel.purchaseOrderNumber}"
                            },
                          )
                          .toList(),
                      widget.subSalesOrder
                          .map((e) => {
                                "type": "owning_party",
                                "source":
                                    "urn:epc:id:sgln:${state.mapModel[0].gln}"
                              })
                          .toList(),
                      widget.subSalesOrder
                          .map(
                            (e) => {
                              "type": "owning_party",
                              "destination":
                                  "urn:epc:id:sgln:${state.mapModel[0].gln}"
                            },
                          )
                          .toList(),
                      widget.subSalesOrder
                          .map(
                            (e) => {
                              "epcClass":
                                  "urn:epc:class:sgtin:${widget.salesOrderModel.purchaseOrderNumber}",
                              "quantity": e.quantity,
                              "uom": "EA"
                            },
                          )
                          .toList(),
                    );
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
          child: Stack(
            children: [
              _currentLocation == null
                  ? const Center(
                      child: Text("Waiting for location data..."),
                    )
                  : GoogleMap(
                      onMapCreated: (controller) {
                        setState(() {
                          mapController = controller;
                        });
                        // Animate to show both markers
                        if (_currentLocation != null &&
                            _destinationLocation != null) {
                          try {
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
                            controller.animateCamera(
                                CameraUpdate.newLatLngBounds(bounds, 50));
                          } catch (e) {
                            print("Error setting camera bounds: $e");
                            // Fallback to focusing on current location
                            controller.animateCamera(
                              CameraUpdate.newLatLngZoom(_currentLocation!, 14),
                            );
                          }
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
              // Show overlay message when map model is empty or null
              if (mapModel == null || mapModel!.isEmpty)
                Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Text(
                      "This customer has no data for latitude and longitude",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.pink,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
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
              if (mapModel != null && mapModel!.isNotEmpty) ...[
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
        // Only show the button if map model has data
        if (mapModel != null && mapModel!.isNotEmpty)
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
        // Show a disabled message instead of the button when no data is available
        if (mapModel == null || mapModel!.isEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(5),
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "Journey unavailable\nNo customer location data",
                style: TextStyle(color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  void _updateMarkers() {
    if (_currentLocation == null || _destinationLocation == null) return;

    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: _currentLocation!,
        infoWindow: const InfoWindow(title: 'Current Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
    _markers.add(
      Marker(
        markerId: const MarkerId('destinationLocation'),
        position: _destinationLocation!,
        infoWindow: const InfoWindow(title: 'Destination Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
    _drawRoute();
  }

  Future<void> _drawRoute() async {
    if (_currentLocation == null || _destinationLocation == null) return;

    // Don't redraw the route too frequently - add debouncing
    if (_polylines.isNotEmpty) {
      // Only update route every 20 seconds or 100 meters to prevent API overuse
      if (_lastRouteUpdateTime != null &&
          DateTime.now().difference(_lastRouteUpdateTime!).inSeconds < 20) {
        return;
      }
    }

    try {
      String apiKey = 'AIzaSyBcdPY1bQKSv0C1lQq-nYb3kBcjANsY3Fk';
      String url = 'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=${_currentLocation!.latitude},${_currentLocation!.longitude}'
          '&destination=${_destinationLocation!.latitude},${_destinationLocation!.longitude}'
          '&key=$apiKey';

      var response = await http.get(Uri.parse(url)).timeout(
            const Duration(seconds: 10),
            onTimeout: () =>
                throw TimeoutException("Directions API request timed out"),
          );

      if (response.statusCode == 200) {
        var decoded = json.decode(response.body);
        if (decoded['routes'] != null && decoded['routes'].isNotEmpty) {
          String points = decoded['routes'][0]['overview_polyline']['points'];
          List<LatLng> polylineCoordinates = _decodePolyline(points);

          if (!mounted) return;
          setState(() {
            _polylines.clear();
            _polylines.add(
              Polyline(
                polylineId: const PolylineId('route'),
                color: AppColors.pink,
                points: polylineCoordinates,
                width: 5,
                patterns: [
                  PatternItem.dash(20),
                  PatternItem.gap(10),
                ],
              ),
            );
          });
        } else {
          print('No routes found in the response');
        }
      } else {
        print(
            'Failed to fetch directions. Status code: ${response.statusCode}');
      }

      _lastRouteUpdateTime = DateTime.now();
    } catch (e) {
      print('Error drawing route: $e');
      // Don't show an error snackbar as this might be disruptive if it keeps failing
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble()));
    }
    return points;
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

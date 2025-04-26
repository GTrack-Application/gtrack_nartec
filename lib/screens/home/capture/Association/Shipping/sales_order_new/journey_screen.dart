// ignore_for_file: prefer_final_fields, avoid_print

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gtrack_nartec/cubit/capture/association/shipping/sales_order/sales_order_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/shipping/sales_order/sales_order_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/sales_order/map_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/sales_order/sales_order_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/sales_order/sub_sales_order_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Shipping/sales_order_new/action_screen.dart';
import 'package:http/http.dart' as http;

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({
    super.key,
    required this.customerId,
    required this.salesOrderId,
    required this.mapModel,
    required this.subSalesOrder,
    required this.salesOrderModel,
  });

  final String customerId;
  final String salesOrderId;
  final List<MapModel> mapModel;
  final List<SubSalesOrderModel> subSalesOrder;
  final SalesOrderModel salesOrderModel;

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  final SalesOrderCubit salesOrderCubit = SalesOrderCubit();
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  BitmapDescriptor? carIcon;
  AnimationController? _animationController;
  Marker? _carMarker;
  int _currentPointIndex = 0;

  @override
  void initState() {
    super.initState();
    final destinationLocation = LatLng(
      double.parse(widget.mapModel[0].latitude!),
      double.parse(widget.mapModel[0].longitude!),
    );
    salesOrderCubit.initializeLocation(destinationLocation);
    _loadCarIcon();

    // Update polylines when location changes
    salesOrderCubit.stream.listen((state) {
      if (state is LocationUpdated) {
        getPolylinePoints(
          state.currentLocation,
          destinationLocation,
        );
      }
    });
  }

  void _loadCarIcon() async {
    carIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/logo.png',
    );
  }

  void _animateCarAlongRoute() {
    if (polylineCoordinates.isEmpty || _mapController == null) return;

    // Dispose previous animation if exists
    _animationController?.dispose();

    // Create new animation controller
    _animationController = AnimationController(
      duration: const Duration(seconds: 10), // Adjust duration as needed
      vsync: this,
    );

    _currentPointIndex = 0;

    _animationController!.addListener(() {
      // Calculate the position along the route based on animation value
      double animationValue = _animationController!.value;
      int totalPoints = polylineCoordinates.length;
      int targetIndex = (animationValue * (totalPoints - 1)).floor();

      if (targetIndex != _currentPointIndex && targetIndex < totalPoints) {
        _currentPointIndex = targetIndex;
        LatLng currentPosition = polylineCoordinates[_currentPointIndex];

        // Calculate bearing for car rotation
        double bearing = 0;
        if (_currentPointIndex < totalPoints - 1) {
          LatLng nextPosition = polylineCoordinates[_currentPointIndex + 1];
          bearing = _getBearing(currentPosition, nextPosition);
        }

        // Update car marker position
        setState(() {
          _carMarker = Marker(
            markerId: const MarkerId('car'),
            position: currentPosition,
            icon: carIcon ?? BitmapDescriptor.defaultMarker,
            rotation: bearing,
            flat: true,
          );

          // Add car marker to the map markers
          if (salesOrderCubit.state is LocationUpdated) {
            final state = salesOrderCubit.state as LocationUpdated;
            Set<Marker> updatedMarkers = {...state.markers};
            updatedMarkers
                .removeWhere((marker) => marker.markerId.value == 'car');
            updatedMarkers.add(_carMarker!);
            // salesOrderCubit.updateMarkers(updatedMarkers);
          }
        });

        // Don't move camera to follow the car - removed camera animation here
      }
    });

    _animationController!.repeat();
  }

  double _getBearing(LatLng start, LatLng end) {
    double lat1 = start.latitude * (pi / 180);
    double lng1 = start.longitude * (pi / 180);
    double lat2 = end.latitude * (pi / 180);
    double lng2 = end.longitude * (pi / 180);

    double dLon = lng2 - lng1;
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double bearing = atan2(y, x);

    // Convert to degrees
    bearing = bearing * (180 / pi);
    bearing = (bearing + 360) % 360;

    return bearing;
  }

  void getPolylinePoints(LatLng origin, LatLng destination) async {
    String apiKey = 'AIzaSyBcdPY1bQKSv0C1lQq-nYb3kBcjANsY3Fk';
    String url = 'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&mode=driving'
        '&alternatives=false'
        '&units=metric'
        '&language=en'
        '&optimizeWaypoints=true'
        '&key=$apiKey';

    print('url: $url');

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var decoded = json.decode(response.body);
        if (decoded['routes'].isNotEmpty) {
          // Clear previous coordinates
          polylineCoordinates = [];

          // Extract each leg and step for complete detail
          List<dynamic> legs = decoded['routes'][0]['legs'];
          for (var leg in legs) {
            List<dynamic> steps = leg['steps'];
            for (var step in steps) {
              String points = step['polyline']['points'];
              List<LatLng> stepPoints = _decodePolyline(points);
              polylineCoordinates.addAll(stepPoints);
            }
          }

          // Extract the duration (in seconds) from the API response
          int durationInSeconds =
              decoded['routes'][0]['legs'][0]['duration']['value'];

          // Calculate the estimated time of arrival
          DateTime now = DateTime.now();
          DateTime eta = now.add(Duration(seconds: durationInSeconds));

          // Format the ETA (you can add this to your state if needed)
          String formattedEta =
              '${eta.hour}:${eta.minute.toString().padLeft(2, '0')}';
          print('ETA: $formattedEta');

          setState(() {
            _polylines.clear();
            _polylines.add(
              Polyline(
                polylineId: const PolylineId('route'),
                color: Colors.blue.shade700,
                points: polylineCoordinates,
                width: 5,
                jointType: JointType.mitered,
                geodesic: true,
                endCap: Cap.roundCap,
                startCap: Cap.roundCap,
                visible: true,
                zIndex: 1,
              ),
            );
          });

          // Start car animation after getting route
          _animateCarAlongRoute();
        }
      }
    } catch (e) {
      print('Error fetching route: $e');
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
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.pink,
            title: const Text('Journey'),
            centerTitle: true,
            titleTextStyle: const TextStyle(
              color: AppColors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottomNavigationBar: state is LocationUpdated && !state.hasArrived
              ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.2),
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
                                    color: AppColors.grey,
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
                                widget.mapModel[0].latitude!,
                                widget.mapModel[0].longitude!,
                                widget.mapModel[0].gln!,
                                widget.subSalesOrder
                                    .map(
                                      (e) => "urn:epc:id:sgtin:${e.productId}",
                                    )
                                    .toList(),
                                widget.subSalesOrder
                                    .map(
                                      (e) => {
                                        "type": widget.salesOrderModel
                                            .purchaseOrderNumber,
                                        "bizTransaction":
                                            "${widget.salesOrderModel.purchaseOrderNumber}"
                                      },
                                    )
                                    .toList(),
                                widget.subSalesOrder
                                    .map((e) => {
                                          "type": "owning_party",
                                          "source":
                                              "urn:epc:id:sgln:${widget.mapModel[0].gln}"
                                        })
                                    .toList(),
                                widget.subSalesOrder
                                    .map(
                                      (e) => {
                                        "type": "owning_party",
                                        "destination":
                                            "urn:epc:id:sgln:${widget.mapModel[0].gln}"
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
          body: state is LocationUpdated
              ? Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: (state as dynamic).currentLocation,
                        zoom: 15,
                      ),
                      markers: (state as dynamic).markers,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      onMapCreated: (controller) {
                        _mapController = controller;
                        // Apply custom map style
                        _setMapStyle();

                        // No camera movement here - removed camera animation
                      },
                      polylines: _polylines,
                    ),
                    // a button to start the journey
                    // Positioned(
                    //   bottom: 16,
                    //   left: 16,
                    //   child: FilledButton.icon(
                    //     style: FilledButton.styleFrom(
                    //       backgroundColor: AppColors.pink,
                    //       padding: const EdgeInsets.symmetric(
                    //         horizontal: 15,
                    //         vertical: 12,
                    //       ),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(12),
                    //       ),
                    //     ),
                    //     onPressed: () {
                    //       AppNavigator.replaceTo(
                    //         context: context,
                    //         screen: FullScreenMap(
                    //           currentLat:
                    //               (state as dynamic).currentLocation.latitude,
                    //           currentLong:
                    //               (state as dynamic).currentLocation.longitude,
                    //           markers: (state as dynamic).markers,
                    //         ),
                    //       );
                    //     },
                    //     icon: const Icon(Icons.play_arrow),
                    //     label: const Text('Start'),
                    //   ),
                    // ),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  void _setMapStyle() async {
    String style = '''
    [
      {
        "featureType": "road",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "color": "#f5f5f5"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#e0e0e0"
          }
        ]
      }
    ]
    ''';
    _mapController?.setMapStyle(style);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _animationController?.dispose();
    super.dispose();
  }
}

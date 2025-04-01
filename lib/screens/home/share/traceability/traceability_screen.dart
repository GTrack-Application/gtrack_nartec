import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gtrack_nartec/features/share/cubits/share/share_cubit.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

String cleanCoordinate(String coordinate) {
  return coordinate
      .replaceAll('°', '')
      .replaceAll('N', '')
      .replaceAll('E', '')
      .replaceAll('W', '')
      .replaceAll('S', '')
      .replaceAll(' ', '')
      .trim();
}

class TraceabilityScreen extends StatefulWidget {
  final String? gtin;
  const TraceabilityScreen({super.key, this.gtin});

  @override
  State<TraceabilityScreen> createState() => _TraceabilityScreenState();
}

class _TraceabilityScreenState extends State<TraceabilityScreen> {
  late GoogleMapController mapController;
  LatLng _center = const LatLng(24.65682, 46.84287); // Center of the map

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    if (widget.gtin != null) {
      ShareCubit.get(context).gtinController.text = widget.gtin!;
      ShareCubit.get(context).getTraceabilityData();
    }
    _setMarkersAndPolylines();
  }

  void _setMarkersAndPolylines() async {
    final traceabilityData = ShareCubit.get(context).traceabilityData;
    PolylinePoints polylinePoints = PolylinePoints();

    for (var i = 0; i < traceabilityData.length; i++) {
      var current = traceabilityData[i];
      var fromDetails = current.gLNFromDetails;
      var toDetails = current.gLNToDetails;

      if (fromDetails != null &&
          fromDetails.latitude != null &&
          fromDetails.longitude != null) {
        var fromLatitude = double.parse(cleanCoordinate(fromDetails.latitude!));
        var fromLongitude =
            double.parse(cleanCoordinate(fromDetails.longitude!));
        _markers.add(
          Marker(
            markerId: MarkerId('from_${current.id}'),
            position: LatLng(fromLatitude, fromLongitude),
            infoWindow: InfoWindow(title: fromDetails.locationNameEn),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              current.industryType?.toLowerCase() == 'manufacturing'
                  ? BitmapDescriptor.hueGreen
                  : current.industryType?.toLowerCase() == 'logistics'
                      ? BitmapDescriptor.hueBlue
                      : BitmapDescriptor.hueRed,
            ),
          ),
        );

        if (toDetails != null &&
            toDetails.latitude != null &&
            toDetails.longitude != null) {
          var toLatitude = double.parse(cleanCoordinate(toDetails.latitude!));
          var toLongitude = double.parse(cleanCoordinate(toDetails.longitude!));
          _markers.add(
            Marker(
              markerId: MarkerId('to_${current.id}'),
              position: LatLng(toLatitude, toLongitude),
              infoWindow: InfoWindow(title: toDetails.locationNameEn),
            ),
          );

          // Fetching polyline points from Polyline API
          PolylineResult result =
              await polylinePoints.getRouteBetweenCoordinates(
                  googleApiKey: "AIzaSyCsEUxB9psxb-LxhYx8hJtF248gj4bx49A",
                  request: PolylineRequest(
                    origin: PointLatLng(fromLatitude, fromLongitude),
                    destination: PointLatLng(toLatitude, toLongitude),
                    mode: TravelMode.driving,
                    optimizeWaypoints: true,
                    avoidFerries: true,
                    avoidHighways: false,
                    avoidTolls: true,
                  ));

          if (result.points.isNotEmpty) {
            List<LatLng> polylineCoordinates = [];
            for (var point in result.points) {
              polylineCoordinates.add(LatLng(point.latitude, point.longitude));
            }

            _polylines.add(
              Polyline(
                polylineId: PolylineId('polyline_${current.id}'),
                points: polylineCoordinates,
                color: Colors.blue,
                width: 5,
              ),
            );
          }
        }
      }
    }
    setState(() {});
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void dispose() {
    ShareCubit.get(context).clearTraceabilityData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.gtin != null
          ? null
          : AppBar(
              title: const Text('Traceability Map'),
              backgroundColor: Colors.green[700],
            ),
      body: Column(
        children: [
          Visibility(
            visible: widget.gtin == null,
            child: TextField(
              controller: ShareCubit.get(context).gtinController,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                ShareCubit.get(context).getTraceabilityData();
              },
              decoration: InputDecoration(
                hintText: 'Search for a location',
                contentPadding: const EdgeInsets.all(10),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // hide keyboard
                    FocusScope.of(context).unfocus();
                    ShareCubit.get(context).getTraceabilityData();
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocConsumer<ShareCubit, ShareState>(
              listener: (context, state) {
                if (state is ShareTraceabilitySuccess) {
                  ShareCubit.get(context).traceabilityData =
                      state.traceabilityData;
                  setState(() {
                    _markers.clear();
                    _polylines.clear();
                    _setMarkersAndPolylines();
                    if (ShareCubit.get(context).traceabilityData.isNotEmpty) {
                      _center = LatLng(
                        double.parse(
                          cleanCoordinate(state
                              .traceabilityData[0].gLNFromDetails!.latitude!),
                        ),
                        double.parse(
                          cleanCoordinate(state
                              .traceabilityData[0].gLNFromDetails!.longitude!),
                        ),
                      );
                    }
                  });
                }
              },
              builder: (context, state) {
                if (state is ShareTraceabilityLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ShareTraceabilityError) {
                  return Center(
                    child: Text(state.message),
                  );
                }
                return GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 6.0,
                  ),
                  markers: _markers,
                  polylines: _polylines,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

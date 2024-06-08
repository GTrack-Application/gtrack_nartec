import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gtrack_mobile_app/cubit/share/share_cubit.dart';

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
  const TraceabilityScreen({super.key});

  @override
  State<TraceabilityScreen> createState() => _TraceabilityScreenState();
}

class _TraceabilityScreenState extends State<TraceabilityScreen> {
  late GoogleMapController mapController;
  LatLng _center = const LatLng(24.65682, 46.84287); // Center of the map

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _setMarkersAndPolylines();
  }

  void _setMarkersAndPolylines() {
    for (var i = 0; i < ShareCubit.get(context).traceabilityData.length; i++) {
      var current = ShareCubit.get(context).traceabilityData[i];
      var fromDetails = current.gLNFromDetails;
      var toDetails = current.gLNToDetails;

      var fromLatitude = double.parse(cleanCoordinate(fromDetails!.latitude!));
      var fromLongitude = double.parse(cleanCoordinate(fromDetails.longitude!));
      _markers.add(
        Marker(
          markerId: MarkerId('from_${current.id}'),
          position: LatLng(fromLatitude, fromLongitude),
          infoWindow: InfoWindow(title: fromDetails.locationNameEn),
        ),
      );

      if (toDetails != null) {
        var toLatitude = double.parse(cleanCoordinate(toDetails.latitude!));
        var toLongitude = double.parse(cleanCoordinate(toDetails.longitude!));
        _markers.add(
          Marker(
            markerId: MarkerId('to_${current.id}'),
            position: LatLng(toLatitude, toLongitude),
            infoWindow: InfoWindow(title: toDetails.locationNameEn),
          ),
        );
        _polylines.add(
          Polyline(
            polylineId: PolylineId('polyline_${current.id}'),
            points: [
              LatLng(fromLatitude, fromLongitude),
              LatLng(toLatitude, toLongitude)
            ],
            color: Colors.blue,
            width: 5,
          ),
        );
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traceability Map'),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          TextField(
            controller: ShareCubit.get(context).gtinController,
            onChanged: (value) {
              ShareCubit.get(context).gtinController.text = value;
            },
            onEditingComplete: () {
              ShareCubit.get(context).getTraceabilityData();
            },
            decoration: InputDecoration(
              hintText: 'Search for a location',
              contentPadding: const EdgeInsets.all(10),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  ShareCubit.get(context).getTraceabilityData();
                },
              ),
            ),
          ),
          Expanded(
            child: BlocConsumer<ShareCubit, ShareState>(
              listener: (context, state) {
                if (state is ShareTraceabilitySuccess) {
                  setState(() {
                    _markers.clear();
                    _polylines.clear();
                    _setMarkersAndPolylines();
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

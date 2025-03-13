// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:location/location.dart';

class FullScreenMap extends StatefulWidget {
  final double currentLat;
  final double currentLong;
  final Set<Marker> markers;
  final Set<Polyline>? polylines;

  const FullScreenMap({
    super.key,
    required this.currentLat,
    required this.currentLong,
    required this.markers,
    this.polylines,
  });

  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  GoogleMapController? mapController;
  Location location = Location();
  late LatLng currentLocation;

  @override
  void initState() {
    super.initState();
    currentLocation = LatLng(widget.currentLat, widget.currentLong);
    location.onLocationChanged.listen((LocationData currentLocation) {
      _onLocationChanged(currentLocation);
    });
  }

  void _onLocationChanged(LocationData currentLocation) {
    if (mapController != null && mounted) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(currentLocation.latitude!, currentLocation.longitude!),
        ),
      );
    }
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              mapController = controller;
              if (mounted) {
                // Optionally move camera to current location when map is created
                mapController!.animateCamera(
                  CameraUpdate.newLatLng(currentLocation),
                );
              }
            },
            initialCameraPosition: CameraPosition(
              target: currentLocation,
              zoom: 18,
            ),
            minMaxZoomPreference: const MinMaxZoomPreference(1, 20),
            mapType: MapType.normal,
            buildingsEnabled: true,
            compassEnabled: true,
            zoomControlsEnabled: true,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: true,
            zoomGesturesEnabled: true,
            indoorViewEnabled: true,
            markers: widget.markers,
            polylines: widget.polylines ?? {},
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            trafficEnabled: true,
          ),
          // back button
          Positioned(
            top: 50,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.pink,
                borderRadius: BorderRadius.circular(50),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

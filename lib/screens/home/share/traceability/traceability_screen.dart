import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gtrack_mobile_app/models/share/traceability/TraceabilityModel.dart';

class TraceabilityScreen extends StatefulWidget {
  @override
  State<TraceabilityScreen> createState() => TraceabilityScreenState();
}

class TraceabilityScreenState extends State<TraceabilityScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(
      24.65682, 46.84287); // Center of the map (Riyadh, Saudi Arabia)

  List<TraceabilityModel> apiResponse = [
    TraceabilityModel(
      id: 6,
      gs1UserId: "1808",
      transactionType: "packing",
      gTIN: "6285561000186",
      gLNFrom: "6285561000063",
      gLNTo: "6285561000032",
      industryType: "manufacturing",
      gLNFromDetails: GLNFromDetails(
        locationNameEn: "Sama Oil Industry Company warehouse - Jeddah",
        locationNameAr: "مستودع شركة زيت سما للصناعة -جده",
        addressEn:
            "Jeddah - Al-Sarawat District - Turki bin Ahmed Al-Sudairi Street - 8512",
        addressAr: "جده-حي السروات - شارع تركي بن احمد السديري -8512",
        longitude: "21.37033",
        latitude: "39.20790",
      ),
      gLNToDetails: GLNFromDetails(
        locationNameEn: "Sama Oil Industrial Company warehouse",
        locationNameAr: "مستودع شركة زيت سما للصناعة",
        addressEn: "Al-Qassim - Unayzah - Al-Narjis District - 3186",
        addressAr: "القصيم -عنيزة -حي النرجس -3186",
        longitude: "26.14938",
        latitude: "43.99702",
      ),
    ),
    // Add other TraceabilityModel instances here...
  ];

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _setMarkersAndPolylines();
  }

  void _setMarkersAndPolylines() {
    for (var i = 0; i < apiResponse.length; i++) {
      var current = apiResponse[i];
      var next = i < apiResponse.length - 1 ? apiResponse[i + 1] : null;

      var fromDetails = current.gLNFromDetails;
      var toDetails = current.gLNToDetails;

      var fromLatitude =
          double.parse(fromDetails!.latitude!.replaceAll('° N', '').trim());
      var fromLongitude =
          double.parse(fromDetails.longitude!.replaceAll('° E', '').trim());
      _markers.add(
        Marker(
          markerId: MarkerId('from_${current.id}'),
          position: LatLng(fromLatitude, fromLongitude),
          infoWindow: InfoWindow(title: fromDetails.locationNameEn),
        ),
      );

      if (toDetails != null) {
        var toLatitude =
            double.parse(toDetails.latitude!.replaceAll('° N', '').trim());
        var toLongitude =
            double.parse(toDetails.longitude!.replaceAll('° E', '').trim());
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
            decoration: InputDecoration(
              hintText: 'Search for a location',
              contentPadding: const EdgeInsets.all(10),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 6.0,
              ),
              markers: _markers,
              polylines: _polylines,
            ),
          ),
        ],
      ),
    );
  }
}

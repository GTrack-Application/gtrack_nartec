import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TraceabilityScreen extends StatefulWidget {
  @override
  State<TraceabilityScreen> createState() => TraceabilityScreenState();
}

class TraceabilityScreenState extends State<TraceabilityScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(
      24.65682, 46.84287); // Center of the map (Riyadh, Saudi Arabia)

  List<Map<String, dynamic>> apiResponse = [
    // Your provided API response here
    {
      "id": 6,
      "gs1UserId": "1808",
      "TransactionType": "packing",
      "GTIN": "6285561000186",
      "GLNFrom": "6285561000063",
      "GLNTo": "6285561000032",
      "IndustryType": "manufacturing",
      "GLNFromDetails": {
        "locationNameEn": "Sama Oil Industry Company warehouse - Jeddah",
        "locationNameAr": "مستودع شركة زيت سما للصناعة -جده",
        "AddressEn":
            "Jeddah - Al-Sarawat District - Turki bin Ahmed Al-Sudairi Street - 8512",
        "AddressAr": "جده-حي السروات - شارع تركي بن احمد السديري -8512",
        "longitude": "21.37033",
        "latitude": "39.20790"
      },
      "GLNToDetails": {
        "locationNameEn": "Sama Oil Industrial Company warehouse",
        "locationNameAr": "مستودع شركة زيت سما للصناعة",
        "AddressEn": "Al-Qassim - Unayzah - Al-Narjis District - 3186",
        "AddressAr": "القصيم -عنيزة -حي النرجس -3186",
        "longitude": "26.14938",
        "latitude": "43.99702"
      }
    },
    {
      "id": 7,
      "gs1UserId": "1808",
      "TransactionType": "packing",
      "GTIN": "6285561000186",
      "GLNFrom": "6285561000032",
      "GLNTo": "6285561000049",
      "IndustryType": "manufacturing",
      "GLNFromDetails": {
        "locationNameEn": "Sama Oil Industrial Company warehouse",
        "locationNameAr": "مستودع شركة زيت سما للصناعة",
        "AddressEn": "Al-Qassim - Unayzah - Al-Narjis District - 3186",
        "AddressAr": "القصيم -عنيزة -حي النرجس -3186",
        "longitude": "26.14938",
        "latitude": "43.99702"
      },
      "GLNToDetails": {
        "locationNameEn":
            "Sama Oil Industrial Company warehouse - Khamis Mushayt",
        "locationNameAr": "مستودع شركة زيت سما للصناعة-خميس مشيط",
        "AddressEn": "Khamis Mushayt - Al-Maamoura District",
        "AddressAr": "خميس مشيط - حي المعمورة",
        "longitude": "18.32977",
        "latitude": "42.72763"
      }
    },
    {
      "id": 8,
      "gs1UserId": "1808",
      "TransactionType": "packing",
      "GTIN": "6285561000186",
      "GLNFrom": "6285561000049",
      "GLNTo": "6285561000070",
      "IndustryType": "manufacturing",
      "GLNFromDetails": {
        "locationNameEn":
            "Sama Oil Industrial Company warehouse - Khamis Mushayt",
        "locationNameAr": "مستودع شركة زيت سما للصناعة-خميس مشيط",
        "AddressEn": "Khamis Mushayt - Al-Maamoura District",
        "AddressAr": "خميس مشيط - حي المعمورة",
        "longitude": "18.32977",
        "latitude": "42.72763"
      },
      "GLNToDetails": {
        "locationNameEn": "Sama Oil Industry Company warehouse - Riyadh",
        "locationNameAr": "مستودع شركة زيت سما للصناعة -الرياض",
        "AddressEn": "Riyadh - Al Sulay Al Thanyah District 2698",
        "AddressAr": "الرياض -حي السلي الثنيه2698",
        "longitude": "24.65682",
        "latitude": "46.84287"
      }
    },
    {
      "id": 9,
      "gs1UserId": "1808",
      "TransactionType": "packing",
      "GTIN": "6285561000186",
      "GLNFrom": "6285561000070",
      "GLNTo": "6285561000018",
      "IndustryType": "retail",
      "GLNFromDetails": {
        "locationNameEn": "Sama Oil Industry Company warehouse - Riyadh",
        "locationNameAr": "مستودع شركة زيت سما للصناعة -الرياض",
        "AddressEn": "Riyadh - Al Sulay Al Thanyah District 2698",
        "AddressAr": "الرياض -حي السلي الثنيه2698",
        "longitude": "24.65682",
        "latitude": "46.84287"
      },
      "GLNToDetails": {
        "locationNameEn": "Riyadh",
        "locationNameAr": "الرياض",
        "AddressEn": "Al , Sulay Al , Hamra Street",
        "AddressAr": "السلي شارع الحمراء",
        "longitude": "24.6567660",
        "latitude": "46.8429378"
      }
    },
    {
      "id": 10,
      "gs1UserId": "1808",
      "TransactionType": "packing",
      "GTIN": "6285561000186",
      "GLNFrom": "6285561000018",
      "GLNTo": "6285561000018",
      "IndustryType": "logistics",
      "GLNFromDetails": {
        "locationNameEn": "Riyadh",
        "locationNameAr": "الرياض",
        "AddressEn": "Al , Sulay Al , Hamra Street",
        "AddressAr": "السلي شارع الحمراء",
        "longitude": "24.6567660",
        "latitude": "46.8429378"
      },
      "GLNToDetails": {
        "locationNameEn": "Riyadh",
        "locationNameAr": "الرياض",
        "AddressEn": "Al , Sulay Al , Hamra Street",
        "AddressAr": "السلي شارع الحمراء",
        "longitude": "24.6567660",
        "latitude": "46.8429378"
      }
    },
    {
      "id": 11,
      "gs1UserId": "1808",
      "TransactionType": "packing",
      "GTIN": "6285561000186",
      "GLNFrom": "6285561000018",
      "GLNTo": "6285561000018",
      "IndustryType": "logistics",
      "GLNFromDetails": {
        "locationNameEn": "Riyadh",
        "locationNameAr": "الرياض",
        "AddressEn": "Al , Sulay Al , Hamra Street",
        "AddressAr": "السلي شارع الحمراء",
        "longitude": "24.6567660",
        "latitude": "46.8429378"
      },
      "GLNToDetails": {
        "locationNameEn": "Riyadh",
        "locationNameAr": "الرياض",
        "AddressEn": "Al , Sulay Al , Hamra Street",
        "AddressAr": "السلي شارع الحمراء",
        "longitude": "24.6567660",
        "latitude": "46.8429378"
      }
    },
    {
      "id": 12,
      "gs1UserId": "1808",
      "TransactionType": "packing",
      "GTIN": "6285561000186",
      "GLNFrom": "6285561000018",
      "GLNTo": null,
      "IndustryType": "logistics",
      "GLNFromDetails": {
        "locationNameEn": "Riyadh",
        "locationNameAr": "الرياض",
        "AddressEn": "Al , Sulay Al , Hamra Street",
        "AddressAr": "السلي شارع الحمراء",
        "longitude": "24.6567660",
        "latitude": "46.8429378"
      },
      "GLNToDetails": null
    },
    {
      "id": 13,
      "gs1UserId": "1808",
      "TransactionType": "packing",
      "GTIN": "6285561000186",
      "GLNFrom": "6285561000018",
      "GLNTo": null,
      "IndustryType": "logistics",
      "GLNFromDetails": {
        "locationNameEn": "Riyadh",
        "locationNameAr": "الرياض",
        "AddressEn": "Al , Sulay Al , Hamra Street",
        "AddressAr": "السلي شارع الحمراء",
        "longitude": "24.6567660",
        "latitude": "46.8429378"
      },
      "GLNToDetails": null
    }
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

      var fromDetails = current['GLNFromDetails'];
      var toDetails = current['GLNToDetails'];

      var fromLatitude =
          double.parse(fromDetails['latitude'].replaceAll('° N', '').trim());
      var fromLongitude =
          double.parse(fromDetails['longitude'].replaceAll('° E', '').trim());
      _markers.add(
        Marker(
          markerId: MarkerId('from_${current['id']}'),
          position: LatLng(fromLatitude, fromLongitude),
          infoWindow: InfoWindow(title: fromDetails['locationNameEn']),
        ),
      );

      if (toDetails != null) {
        var toLatitude =
            double.parse(toDetails['latitude'].replaceAll('° N', '').trim());
        var toLongitude =
            double.parse(toDetails['longitude'].replaceAll('° E', '').trim());
        _markers.add(
          Marker(
            markerId: MarkerId('to_${current['id']}'),
            position: LatLng(toLatitude, toLongitude),
            infoWindow: InfoWindow(title: toDetails['locationNameEn']),
          ),
        );
        _polylines.add(
          Polyline(
            polylineId: PolylineId('polyline_${current['id']}'),
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
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 6.0,
        ),
        markers: _markers,
        polylines: _polylines,
      ),
    );
  }
}

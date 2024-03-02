// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gtrack_mobile_app/controllers/share/product_information/events_screen_controller.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_dialogs.dart';
import 'package:gtrack_mobile_app/models/share/product_information/events_screen_model.dart';
import 'package:nb_utils/nb_utils.dart';

List<EventsScreenModel> table = [];

class EventsScreen extends StatefulWidget {
  final String gtin;
  const EventsScreen({Key? key, required this.gtin}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<double> longitude = [];
  List<double> latitude = [];

  double currentLat = 0;
  double currentLong = 0;

  bool isLoaded = false;

  // flag to show the table
  bool isTableVisible = false;

  List<Polyline> yourPolylinesList = [];
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  List<Marker> yourMarkersList = [];

  // Origin and destination
  PointLatLng? origin;
  PointLatLng? destination;

  void setPolylines(double lat, double long, int i) async {
    origin = PointLatLng(latitude[i], longitude[i]);
    destination = PointLatLng(lat, long);
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyCsEUxB9psxb-LxhYx8hJtF248gj4bx49A", // Replace with your Google Maps API key
      origin!, // Starting coordinates
      destination!, // Ending coordinates
      avoidFerries: true,
      avoidHighways: false,
      avoidTolls: true,
      travelMode: TravelMode.driving,
      optimizeWaypoints: true,
    );

    if (result.status == 'OK') {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      Polyline polyline = Polyline(
        polylineId: const PolylineId('polyline'),
        color: AppColors.green,
        points: polylineCoordinates,
        width: 3,
      );

      setState(() {
        yourPolylinesList.add(polyline);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        AppDialogs.loadingDialog(context);
        EventsScreenController.getEventsData(widget.gtin).then((value) {
          setState(() {
            table = value;
            latitude = value
                .map((e) => double.parse(e.itemGPSOnGoLat.toString()))
                .toList();
            longitude = value
                .map((e) => double.parse(e.itemGPSOnGoLon.toString()))
                .toList();

            currentLat = latitude[0];
            currentLong = longitude[0];

            // setPolylines(latitude[1], longitude[1], 0);

            yourMarkersList = table.map((data) {
              return Marker(
                markerId: MarkerId(data.memberID.toString()),
                position: LatLng(
                  double.parse(data.itemGPSOnGoLat.toString()),
                  double.parse(data.itemGPSOnGoLon.toString()),
                ),
                infoWindow: InfoWindow(
                  title: data.memberID,
                  snippet: "${data.itemGPSOnGoLat}, ${data.itemGPSOnGoLon}",
                ),
              );
            }).toList();

            polylineCoordinates = polylineCoordinates.toSet().toList();

            // connect each and every point with each other other but only using routes
            for (int i = 0; i < table.length - 2; i++) {
              setPolylines(latitude[i + 1], longitude[i + 1], i);
            }
            isLoaded = true;
          });
          AppDialogs.closeDialog();
        }).onError((error, stackTrace) {
          setState(() {
            table = [];
          });
          AppDialogs.closeDialog();
          toast(error.toString().replaceAll("Exception:", ""));
        });
      },
    );
  }

  late GoogleMapController mapController;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void dispose() {
    mapController.dispose();

    latitude.clear();
    longitude.clear();
    table.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoaded == false
          ? const SizedBox.shrink()
          : Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isTableVisible = !isTableVisible;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                  ),
                  child: Text(isTableVisible ? "Hide Grid" : "Show Grid"),
                ),
                !isTableVisible
                    ? const SizedBox.shrink()
                    : Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.green),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: PaginatedDataTable(
                          columns: const [
                            DataColumn(
                                label: Text(
                              "Event Id",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.green,
                              ),
                            )),
                            DataColumn(
                                label: Text(
                              "Member Id",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.green,
                              ),
                            )),
                            DataColumn(
                                label: Text(
                              "Ref Description",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.green,
                              ),
                            )),
                            DataColumn(
                                label: Text(
                              "Date Created",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.green,
                              ),
                            )),
                            DataColumn(
                                label: Text(
                              "Date Last Updated",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.green,
                              ),
                            )),
                            DataColumn(
                                label: Text(
                              "GLN Id From",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.green,
                              ),
                            )),
                            DataColumn(
                                label: Text(
                              "GLN Id To",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.green,
                              ),
                            )),
                          ],
                          source: EventsSource(),
                          arrowHeadColor: AppColors.green,
                          showCheckboxColumn: false,
                          rowsPerPage: 3,
                        ).visible(isTableVisible),
                      ).visible(isTableVisible),
                Expanded(
                  child: GoogleMap(
                    fortyFiveDegreeImageryEnabled: false,
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(currentLat, currentLong),
                      zoom: 12,
                      tilt: 0,
                      bearing: 0,
                    ),
                    cameraTargetBounds: CameraTargetBounds.unbounded,
                    mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    mapToolbarEnabled: true,
                    markers: Set<Marker>.from(yourMarkersList),
                    buildingsEnabled: true,
                    compassEnabled: true,
                    zoomGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    layoutDirection: TextDirection.ltr,
                    polylines: Set<Polyline>.from(yourPolylinesList),
                  ),
                ),
              ],
            ),
    );
  }
}

class EventsSource extends DataTableSource {
  List<EventsScreenModel> data = table;

  @override
  DataRow getRow(int index) {
    final rowData = data[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(rowData.trxEventId.toString())),
        DataCell(Text(rowData.memberID.toString())),
        DataCell(Text(rowData.trxRefDescription.toString())),
        DataCell(Text(rowData.trxDateCreated.toString())),
        DataCell(Text(rowData.trxDateLastUpdate.toString())),
        DataCell(Text(rowData.trxGLNIDFrom.toString())),
        DataCell(Text(rowData.trxGLNIDTo.toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

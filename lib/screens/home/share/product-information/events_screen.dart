import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gtrack_mobile_app/controllers/share/product_information/events_screen_controller.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_dialogs.dart';
import 'package:gtrack_mobile_app/models/share/product_information/events_screen_model.dart';
import 'package:nb_utils/nb_utils.dart';

List<EventsScreenModel> table = [];

class EventsScreen extends StatefulWidget {
  final String gtin;
  final String codeType;
  const EventsScreen({Key? key, required this.gtin, required this.codeType})
      : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<bool> isMarked = [];

  List<double> longitude = [];
  List<double> latitude = [];

  double currentLat = 0;
  double currentLong = 0;

  // markers
  Set<Marker> markers = {};

  bool isLoaded = false;

  // flag to show the table
  bool isTableVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        AppDialogs.loadingDialog(context);
        final gtin = (widget.codeType == "1D")
            ? widget.gtin
            : widget.gtin.substring(1, 14);
        EventsScreenController.getEventsData(gtin).then((value) {
          setState(() {
            isMarked = List.filled(value.length, true);
            table = value;
            latitude = value
                .map((e) => double.parse(e.itemGPSOnGoLat.toString()))
                .toList();
            longitude = value
                .map((e) => double.parse(e.itemGPSOnGoLon.toString()))
                .toList();

            currentLat = 24.7136;
            currentLong = 46.6753;

            // setting up markers
            markers = table.map((data) {
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
            }).toSet();

            isLoaded = true;
          });
          AppDialogs.closeDialog();
        }).onError((error, stackTrace) {
          setState(() {
            isMarked = List.filled(0, false);
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

    markers.clear();
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
                  child: Text(isTableVisible ? "Hide Grid" : "Show Grid"),
                  onPressed: () {
                    setState(() {
                      isTableVisible = !isTableVisible;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                  ),
                ),
                !isTableVisible
                    ? const SizedBox.shrink()
                    : PaginatedDataTable(
                        columns: const [
                          DataColumn(label: Text("Event Id")),
                          DataColumn(label: Text("Member Id")),
                          DataColumn(label: Text("Ref Description")),
                          DataColumn(label: Text("Date Created")),
                          DataColumn(label: Text("Date Last Updated")),
                          DataColumn(label: Text("GLN Id From")),
                          DataColumn(label: Text("GLN Id To")),
                        ],
                        source: EventsSource(),
                        arrowHeadColor: AppColors.green,
                        showCheckboxColumn: false,
                        rowsPerPage: 3,
                      ).visible(isTableVisible),
                Expanded(
                  child: GoogleMap(
                    fortyFiveDegreeImageryEnabled: false,
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      // with current position using geolocator
                      target: latitude.isEmpty
                          ? LatLng(currentLat, currentLong)
                          : LatLng(
                              latitude[0],
                              longitude[0],
                            ),
                      zoom: 14,
                      tilt: 0,
                      bearing: 0,
                    ),
                    cameraTargetBounds: CameraTargetBounds.unbounded,
                    mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    mapToolbarEnabled: true,
                    markers: markers,
                    buildingsEnabled: true,
                    compassEnabled: true,
                    zoomGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    layoutDirection: TextDirection.ltr,
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId('route'),
                        jointType: JointType.mitered,
                        consumeTapEvents: true,
                        color: AppColors.primary,
                        width: 5,
                        points: latitude.isEmpty
                            ? [
                                LatLng(currentLat, currentLong),
                                LatLng(currentLat, currentLong),
                              ]
                            : latitude
                                .asMap()
                                .map((index, value) => MapEntry(
                                    index,
                                    LatLng(
                                      latitude[index],
                                      longitude[index],
                                    )))
                                .values
                                .toList(),
                      ),
                    },
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

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gtrack_mobile_app/controllers/Identify/GLN/GLNController.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_dialogs.dart';
import 'package:gtrack_mobile_app/models/Identify/GLN/GLNProductsModel.dart';
import 'package:nb_utils/nb_utils.dart';

class GLNScreen extends StatefulWidget {
  const GLNScreen({super.key});

  @override
  State<GLNScreen> createState() => _GLNScreenState();
}

class _GLNScreenState extends State<GLNScreen> {
  List<bool> isMarked = [];
  List<GLNProductsModel> table = [];

  List<double> longitude = [];
  List<double> latitude = [];

  double currentLat = 0;
  double currentLong = 0;

  // markers
  Set<Marker> markers = {};

  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        AppDialogs.loadingDialog(context);
        GLNController.getData().then((value) {
          setState(() {
            isMarked = List.filled(value.length, true);
            table = value;
            latitude =
                value.map((e) => double.parse(e.latitude.toString())).toList();
            longitude =
                value.map((e) => double.parse(e.longitude.toString())).toList();

            currentLat = latitude[0];
            currentLong = longitude[0];

            // setting up markers
            markers = table.map((data) {
              return Marker(
                markerId: MarkerId(data.glnId.toString()),
                position: LatLng(
                  double.parse(data.latitude.toString()),
                  double.parse(data.longitude.toString()),
                ),
                infoWindow: InfoWindow(
                  snippet: data.locationNameAr.toString(),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text(data.locationNameEn.toString()),
                      title: Text(data.locationNameAr.toString()),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
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
      appBar: AppBar(
        title: const Text('Member GLN'),
        centerTitle: true,
        backgroundColor: AppColors.skyBlue,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.grey,
                    width: 1,
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      showCheckboxColumn: false,
                      dataRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.grey.withOpacity(0.2)),
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => AppColors.skyBlue),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.skyBlue,
                          width: 1,
                        ),
                      ),
                      border: TableBorder.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Select',
                            style: TextStyle(color: AppColors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataColumn(
                            label: Text(
                          'GLN Id',
                          style: TextStyle(color: AppColors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'gcp GLNID',
                          style: TextStyle(color: AppColors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'location Name En',
                          style: TextStyle(color: AppColors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'location Name Ar',
                          style: TextStyle(color: AppColors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'GLN Barcode Number',
                          style: TextStyle(color: AppColors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Status',
                          style: TextStyle(color: AppColors.white),
                          textAlign: TextAlign.center,
                        )),
                      ],
                      rows: table.map((e) {
                        return DataRow(
                            onSelectChanged: (value) async {},
                            cells: [
                              DataCell(
                                Checkbox(
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) => AppColors.skyBlue),
                                  value: isMarked[table.indexOf(e)],
                                  onChanged: (value) {
                                    setState(() {
                                      isMarked[table.indexOf(e)] = value!;

                                      if (value == false) {
                                        // remove lat and long from list
                                        latitude.removeAt(table.indexOf(e));
                                        longitude.removeAt(table.indexOf(e));
                                        // remove marker from map
                                        markers.removeWhere((element) =>
                                            element.markerId ==
                                            MarkerId(e.glnId.toString()));
                                      } else {
                                        // add lat and long to the list
                                        latitude.add(double.parse(
                                            e.latitude.toString()));
                                        longitude.add(double.parse(
                                            e.longitude.toString()));
                                        // add marker to the map
                                        markers.add(Marker(
                                          markerId:
                                              MarkerId(e.glnId.toString()),
                                          position: LatLng(
                                            double.parse(e.latitude.toString()),
                                            double.parse(
                                                e.longitude.toString()),
                                          ),
                                          infoWindow: InfoWindow(
                                            snippet:
                                                e.locationNameAr.toString(),
                                          ),
                                        ));
                                      }
                                    });
                                  },
                                ),
                              ),
                              DataCell(Text(e.glnId.toString())),
                              DataCell(Text(e.gcpGLNID ?? '')),
                              DataCell(Text(e.locationNameEn ?? '')),
                              DataCell(Text(e.locationNameAr ?? '')),
                              DataCell(Text(e.gLNBarcodeNumber ?? '')),
                              DataCell(Text(e.status ?? '')),
                            ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.grey,
                    width: 1,
                  ),
                ),
                child: isLoaded == false
                    ? SizedBox.shrink()
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: GoogleMap(
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
                            zoom: -14,
                          ),
                          // each marker will connect to each other and will show the route to the next marker
                          polylines: {
                            Polyline(
                              polylineId: PolylineId('route'),
                              color: AppColors.skyBlue,
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

                          markers: markers,
                          buildingsEnabled: true,
                          compassEnabled: true,
                          indoorViewEnabled: true,
                          mapToolbarEnabled: true,
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

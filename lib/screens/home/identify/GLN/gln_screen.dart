// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/controllers/Identify/GLN/GLNController.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_dialogs.dart';
import 'package:gtrack_mobile_app/models/Identify/GLN/GLNProductsModel.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nb_utils/nb_utils.dart';

class GLNScreen extends StatefulWidget {
  const GLNScreen({super.key});

  @override
  State<GLNScreen> createState() => _GLNScreenState();
}

class _GLNScreenState extends State<GLNScreen> {
  TextEditingController searchController = TextEditingController();

  List<bool> isMarked = [];
  List<GLNProductsModel> table = [];

  List<double> longitude = [];
  List<double> latitude = [];

  double currentLat = 0;
  double currentLong = 0;

  // markers
  Set<Marker> markers = {};

  bool isLoaded = false;

  String? userId, gcp, memberCategoryDescription;

  @override
  void initState() {
    super.initState();
    AppPreferences.getUserId().then((value) => userId = value);
    AppPreferences.getGcp().then((value) => gcp = value);
    AppPreferences.getMemberCategoryDescription()
        .then((value) => memberCategoryDescription = value);
    Future.delayed(
      Duration.zero,
      () {
        AppDialogs.loadingDialog(context);
        GLNController.getData().then((value) {
          setState(() {
            table = value;
            // isMarked = List.filled(value.length, true);
            // latitude =
            //     value.map((e) => double.parse(e.latitude.toString())).toList();
            // longitude =
            //     value.map((e) => double.parse(e.longitude.toString())).toList();

            // currentLat = latitude[0];
            // currentLong = longitude[0];

            // // setting up markers
            // markers = table.map((data) {
            //   return Marker(
            //     markerId: MarkerId(data.glnId.toString()),
            //     position: LatLng(
            //       double.parse(data.latitude.toString()),
            //       double.parse(data.longitude.toString()),
            //     ),
            //     infoWindow: InfoWindow(
            //       snippet: data.locationNameAr.toString(),
            //     ),
            //     onTap: () {
            //       showDialog(
            //         context: context,
            //         builder: (context) => AlertDialog(
            //           content: Text(data.locationNameEn.toString()),
            //           title: Text(data.locationNameAr.toString()),
            //           actions: [
            //             TextButton(
            //               onPressed: () {
            //                 Navigator.pop(context);
            //               },
            //               child: Text('Close'),
            //             ),
            //           ],
            //         ),
            //       );
            //     },
            //   );
            // }).toSet();

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

  // late GoogleMapController mapController;

  // void onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }

  @override
  void dispose() {
    // mapController.dispose();

    // markers.clear();
    // latitude.clear();
    // longitude.clear();
    // table.clear();

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Member ID",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      gcp.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/add_Icon.png',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Ionicons.search_outline),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "GLN List",
                      style: TextStyle(fontSize: 18),
                    ),
                    Icon(
                      Ionicons.filter_outline,
                      size: 30,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PaginatedDataTable(
                rowsPerPage: 5,
                columns: const [
                  DataColumn(
                      label: Text(
                    'GLN ID',
                    style: TextStyle(color: AppColors.black),
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                      label: Text(
                    'gcp GLNID',
                    style: TextStyle(color: AppColors.black),
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                      label: Text(
                    'location Name En',
                    style: TextStyle(color: AppColors.black),
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                      label: Text(
                    'location Name Ar',
                    style: TextStyle(color: AppColors.black),
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                      label: Text(
                    'GLN Barcode Number',
                    style: TextStyle(color: AppColors.black),
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                      label: Text(
                    'Status',
                    style: TextStyle(color: AppColors.black),
                    textAlign: TextAlign.center,
                  )),
                ],
                source: TableDataSource(table, context),
                showCheckboxColumn: false,
                showFirstLastButtons: true,
                arrowHeadColor: AppColors.skyBlue,
              ),
              const SizedBox(height: 10),
              // Container(
              //   height: MediaQuery.of(context).size.height * 0.5,
              //   width: MediaQuery.of(context).size.width,
              //   margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(20),
              //     border: Border.all(
              //       color: AppColors.grey,
              //       width: 1,
              //     ),
              //   ),
              //   child: isLoaded == false
              //       ? SizedBox.shrink()
              //       : ClipRRect(
              //           borderRadius: BorderRadius.circular(20),
              //           child: GoogleMap(
              //             onMapCreated: (GoogleMapController controller) {
              //               mapController = controller;
              //             },
              //             initialCameraPosition: CameraPosition(
              //               // with current position using geolocator
              //               target: latitude.isEmpty
              //                   ? LatLng(currentLat, currentLong)
              //                   : LatLng(
              //                       latitude[0],
              //                       longitude[0],
              //                     ),
              //               zoom: -14,
              //             ),
              //             // each marker will connect to each other and will show the route to the next marker
              //             polylines: {
              //               Polyline(
              //                 polylineId: PolylineId('route'),
              //                 color: AppColors.skyBlue,
              //                 width: 5,
              //                 points: latitude.isEmpty
              //                     ? [
              //                         LatLng(currentLat, currentLong),
              //                         LatLng(currentLat, currentLong),
              //                       ]
              //                     : latitude
              //                         .asMap()
              //                         .map((index, value) => MapEntry(
              //                             index,
              //                             LatLng(
              //                               latitude[index],
              //                               longitude[index],
              //                             )))
              //                         .values
              //                         .toList(),
              //               ),
              //             },
              //             markers: markers,
              //             buildingsEnabled: true,
              //             compassEnabled: true,
              //             indoorViewEnabled: true,
              //             mapToolbarEnabled: true,
              //           ),
              //         ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class TableDataSource extends DataTableSource {
  List<GLNProductsModel> data;
  BuildContext ctx;

  TableDataSource(
    this.data,
    this.ctx,
  );

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final instance = data[index];

    return DataRow.byIndex(
      index: index,
      onSelectChanged: (value) {},
      cells: [
        DataCell(SelectableText(instance.glnId.toString())),
        DataCell(SelectableText(instance.gcpGLNID ?? '')),
        DataCell(SelectableText(instance.locationNameEn ?? '')),
        DataCell(SelectableText(instance.locationNameAr ?? '')),
        DataCell(SelectableText(instance.gLNBarcodeNumber ?? '')),
        DataCell(SelectableText(instance.status ?? '')),
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

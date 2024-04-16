// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gtrack_mobile_app/blocs/Identify/gln/gln_cubit.dart';
import 'package:gtrack_mobile_app/blocs/Identify/gln/gln_states.dart';
import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/models/Identify/GLN/GLNProductsModel.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:shimmer/shimmer.dart';

class GLNScreen extends StatefulWidget {
  const GLNScreen({super.key});

  @override
  State<GLNScreen> createState() => _GLNScreenState();
}

class _GLNScreenState extends State<GLNScreen> {
  TextEditingController searchController = TextEditingController();

  GlnCubit glnCubit = GlnCubit();

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
        glnCubit.identifyGln();
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

    searchController.clear();

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
      body: BlocConsumer<GlnCubit, GlnState>(
        bloc: glnCubit,
        listener: (context, state) {
          if (state is GlnLoadedState) {
            if (state.data.isEmpty) {
              toast('No data found');
            }
            table = state.data;
            isLoaded = true;
          } else if (state is GlnErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 20.0),
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
                  state is GlnLoadingState
                      ? Shimmer.fromColors(
                          baseColor: AppColors.grey,
                          highlightColor: AppColors.white,
                          child: Container(
                            height: 350,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.grey,
                                width: 1,
                              ),
                              color: Colors.black38,
                            ),
                          ),
                        )
                      : PaginatedDataTable(
                          rowsPerPage: 5,
                          headingRowColor: MaterialStateColor.resolveWith(
                              (states) => Colors.blue),
                          arrowHeadColor: Colors.blue,
                          columns: const [
                            DataColumn(
                                label: Text(
                              'GLN ID',
                              style: TextStyle(color: AppColors.white),
                              textAlign: TextAlign.center,
                            )),
                            DataColumn(
                                label: Text(
                              'GCP GLNID',
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
                          source: TableDataSource(table, context),
                          showCheckboxColumn: false,
                          showFirstLastButtons: true,
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
          );
        },
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
        DataCell(SelectableText(instance.id ?? '')),
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

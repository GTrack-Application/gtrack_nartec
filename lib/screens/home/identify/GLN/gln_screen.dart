// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gtrack_mobile_app/blocs/Identify/gln/gln_cubit.dart';
import 'package:gtrack_mobile_app/blocs/Identify/gln/gln_states.dart';
import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/models/Identify/GLN/GLNProductsModel.dart';
import 'package:gtrack_mobile_app/screens/home/identify/GLN/gln_information_screen.dart';
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

  @override
  void dispose() {
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
                      : Container(
                          // border
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListView.builder(
                            itemCount: table.length,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                width: context.width() * 0.9,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.2)),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(10),
                                  title: Text(
                                    table[index].locationNameAr ?? "",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    table[index].gLNBarcodeNumber ?? "",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  leading: Hero(
                                    tag: table[index].id ?? "",
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: table[index].image == null
                                            ? "https://img.freepik.com/free-psd/3d-illustration-human-avatar-profile_23-2150671116.jpg?w=740&t=st=1715954816~exp=1715955416~hmac=b32613f5083d999009d81a82df971a4351afdc2a8725f2053bfa1a4af896d072"
                                            : "${AppUrls.baseUrlWith3093}${table[index].image?.replaceAll(RegExp(r'^/+|/+$'), '').replaceAll("\\", "/")}",
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      AppNavigator.goToPage(
                                        context: context,
                                        screen: GLNInformationScreen(
                                            employees: table[index]),
                                      );
                                    },
                                    child: Image.asset("assets/icons/view.png"),
                                  ),
                                  onTap: () {},
                                ),
                              );
                            },
                          ),
                        ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// class TableDataSource extends DataTableSource {
//   List<GLNProductsModel> data;
//   BuildContext ctx;

//   TableDataSource(
//     this.data,
//     this.ctx,
//   );

//   @override
//   DataRow? getRow(int index) {
//     if (index >= data.length) {
//       return null;
//     }

//     final instance = data[index];

//     return DataRow.byIndex(
//       index: index,
//       onSelectChanged: (value) {},
//       cells: [
//         DataCell(SelectableText(instance.id ?? '')),
//         DataCell(SelectableText(instance.gcpGLNID ?? '')),
//         DataCell(SelectableText(instance.locationNameEn ?? '')),
//         DataCell(SelectableText(instance.locationNameAr ?? '')),
//         DataCell(SelectableText(instance.gLNBarcodeNumber ?? '')),
//         DataCell(SelectableText(instance.status ?? '')),
//       ],
//     );
//   }

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get rowCount => data.length;

//   @override
//   int get selectedRowCount => 0;
// }

// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gtrack_nartec/blocs/Identify/gln/gln_cubit.dart';
import 'package:gtrack_nartec/blocs/Identify/gln/gln_states.dart';
import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/features/capture/models/aggregation/packing/PackedItemsModel.dart';
import 'package:gtrack_nartec/screens/home/identify/GLN/add_gln_screen.dart';
import 'package:ionicons/ionicons.dart';

import 'package:shimmer/shimmer.dart';

class GLNScreen extends StatefulWidget {
  const GLNScreen({super.key});

  @override
  State<GLNScreen> createState() => _GLNScreenState();
}

class _GLNScreenState extends State<GLNScreen> {
  TextEditingController searchController = TextEditingController();

  List<PackedItemsModel> table = [];
  List<PackedItemsModel> filteredTable = [];

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

    AppPreferences.getMemberId().then((value) => userId = value);
    AppPreferences.getGcp().then((value) => gcp = value);
    AppPreferences.getMemberCategoryDescription()
        .then((value) => memberCategoryDescription = value);
    context.read<GlnCubit>().identifyGln();
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
        listener: (context, state) {
          if (state is GlnLoadedState) {
            if (state.data.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('No data found'),
                  backgroundColor: Colors.red,
                ),
              );
            }
            table = state.data;
            filteredTable = state.data;
            isLoaded = true;
          } else if (state is GlnErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          } else if (state is GlnDeleteState) {
            context.read<GlnCubit>().identifyGln();
          }
        },
        builder: (context, state) {
          return Column(
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
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      userId ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  AppNavigator.goToPage(
                    context: context,
                    screen: AddGlnScreen(),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
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
                          onChanged: (value) {
                            setState(() {
                              filteredTable = table.where((element) {
                                var nameCondition = element.gLN!
                                    .toLowerCase()
                                    .contains(value.toLowerCase());
                                var barcodeCondition = element.gTIN!
                                    .toLowerCase()
                                    .contains(value.toLowerCase());
                                return nameCondition || barcodeCondition;
                              }).toList();
                            });
                          },
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Ionicons.search_outline),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                  ? Expanded(
                      child: Shimmer.fromColors(
                        baseColor: AppColors.grey,
                        highlightColor: AppColors.white,
                        child: Container(
                          height: 350,
                          width: MediaQuery.of(context).size.width,
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.grey,
                              width: 1,
                            ),
                            color: Colors.black38,
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: Container(
                        // border
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: RefreshIndicator(
                          onRefresh: () async {
                            context.read<GlnCubit>().identifyGln();
                          },
                          child: ListView.builder(
                            itemCount: filteredTable.length,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.9,
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
                                child: Dismissible(
                                  key: UniqueKey(),
                                  direction: DismissDirection.endToStart,
                                  movementDuration: const Duration(seconds: 1),
                                  secondaryBackground: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Swipe to Delete",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                  background: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Swipe to Delete",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                  confirmDismiss: (direction) {
                                    return showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Are you sure?"),
                                        content: const Text(
                                            "Do you want to delete this product?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            },
                                            child: const Text("Yes"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            child: const Text("No"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  onDismissed: (direction) {
                                    context
                                        .read<GlnCubit>()
                                        .deleteGln(filteredTable[index].id!);
                                  },
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(10),
                                    title: Text(
                                      filteredTable[index].gLN ?? "",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      filteredTable[index].gTIN ?? "",
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    leading: Hero(
                                      tag: filteredTable[index].id ?? "",
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: filteredTable[index]
                                                      .itemImage ==
                                                  null
                                              ? "https://img.freepik.com/free-psd/3d-illustration-human-avatar-profile_23-2150671116.jpg?w=740&t=st=1715954816~exp=1715955416~hmac=b32613f5083d999009d81a82df971a4351afdc2a8725f2053bfa1a4af896d072"
                                              : "${AppUrls.baseUrlWith3093}${filteredTable[index].itemImage?.replaceAll(RegExp(r'^/+|/+$'), '').replaceAll("\\", "/")}",
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.image_outlined),
                                        ),
                                      ),
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        // AppNavigator.goToPage(
                                        //   context: context,
                                        //   screen: GLNInformationScreen(
                                        //       employees: filteredTable[index]),
                                        // );
                                      },
                                      child:
                                          Image.asset("assets/icons/view.png"),
                                    ),
                                    onTap: () {},
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 10),
            ],
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

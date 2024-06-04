// ignore_for_file: collection_methods_unrelated_type

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/blocs/Identify/gln/gln_cubit.dart';
import 'package:gtrack_mobile_app/blocs/Identify/gln/gln_states.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/cubit/capture/agregation/packing/packed_items/packed_items_cubit.dart';
import 'package:gtrack_mobile_app/cubit/capture/agregation/packing/packed_items/packed_items_state.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/models/Identify/GLN/GLNProductsModel.dart';
import 'package:gtrack_mobile_app/models/capture/aggregation/packing/PackedItemsModel.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Aggregation/packing/complete_packing_screen.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Aggregation/packing/packing_details_screen.dart';
import 'package:nb_utils/nb_utils.dart';

class PackingScreen extends StatefulWidget {
  const PackingScreen({super.key});

  @override
  State<PackingScreen> createState() => _PackingScreenState();
}

class _PackingScreenState extends State<PackingScreen> {
  TextEditingController searchController = TextEditingController();

  GlnCubit glnCubit = GlnCubit();
  List<GLNProductsModel> table = [];

  List<String> dropdownList = [];
  String? dropdownValue;

  List<String> gln = [];

  @override
  void initState() {
    super.initState();
    glnCubit.identifyGln();
  }

  PackedItemsCubit packedItemsCubit = PackedItemsCubit();
  List<PackedItemsModel> products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Packing'),
        backgroundColor: AppColors.pink,
      ),
      body: SafeArea(
        child: BlocConsumer<GlnCubit, GlnState>(
          bloc: glnCubit,
          listener: (context, state) {
            if (state is GlnErrorState) {
              toast(state.message);
            }
            if (state is GlnLoadedState) {
              table = state.data;
              dropdownList = table.map((e) => e.locationNameAr ?? "").toList();
              gln = table.map((e) => e.gcpGLNID ?? "").toList();
              dropdownList = dropdownList.toSet().toList();
              dropdownValue = dropdownList[0];
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.fromBorderSide(
                          BorderSide(color: AppColors.grey)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                          packedItemsCubit.getPackedItems(
                              gln[dropdownList.indexOf(newValue!)]);
                        },
                        items: dropdownList
                            .map<DropdownMenuItem<String>>((String? value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value!),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: context.width() * 1,
                    height: 40,
                    decoration: const BoxDecoration(color: AppColors.primary),
                    child: const Text(
                      'List of Pack Items',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: BlocConsumer<PackedItemsCubit, PackedItemsState>(
                        bloc: packedItemsCubit,
                        listener: (context, state) {
                          if (state is PackedItemsError) {
                            toast(state.message);
                          }
                          if (state is PackedItemsLoaded) {
                            products = state.data;
                          }
                        },
                        builder: (context, state) {
                          return RefreshIndicator(
                            onRefresh: () async {
                              packedItemsCubit.getPackedItems(
                                  gln[dropdownList.indexOf(dropdownValue!)]);
                            },
                            child: ListView.builder(
                              itemCount: products.length,
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
                                      products[index].itemName ?? "",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      products[index].gTIN ?? "",
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    leading: Hero(
                                      tag: products[index].id ?? "",
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "${AppUrls.baseUrlWith3093}${products[index].itemImage?.replaceAll(RegExp(r'^/+'), '').replaceAll("\\", "/") ?? ''}",
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
                                          screen: PackingDetailsScreen(
                                            employees: products[index],
                                          ),
                                        );
                                      },
                                      child:
                                          Image.asset("assets/icons/view.png"),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CompletePackingScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(249, 75, 0, 1),
                        ),
                        child: const Text(
                          'Start Packing',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

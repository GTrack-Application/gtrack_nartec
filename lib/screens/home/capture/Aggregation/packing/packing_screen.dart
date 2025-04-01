// ignore_for_file: collection_methods_unrelated_type, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/Identify/gln/gln_cubit.dart';
import 'package:gtrack_nartec/blocs/Identify/gln/gln_states.dart';
import 'package:gtrack_nartec/features/capture/cubits/agregation/packing/packed_items/packed_items_cubit.dart';
import 'package:gtrack_nartec/features/capture/cubits/agregation/packing/packed_items/packed_items_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/features/capture/models/aggregation/packing/PackedItemsModel.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/packing/complete_packing_screen.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/packing/packing_details_screen.dart';

class PackingScreen extends StatefulWidget {
  const PackingScreen({super.key});

  @override
  State<PackingScreen> createState() => _PackingScreenState();
}

class _PackingScreenState extends State<PackingScreen> {
  TextEditingController searchController = TextEditingController();

  GlnCubit glnCubit = GlnCubit();
  List<PackedItemsModel> table = [];

  List<String> dropdownList = [];
  String? dropdownValue;

  List<String> gln = [];

  @override
  void initState() {
    super.initState();
    // glnCubit.identifyGln();
    packedItemsCubit.getPackedItems();
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
              AppSnackbars.danger(context, state.message);
            }
            if (state is GlnLoadedState) {
              table = state.data;
              dropdownList = table.map((e) => e.gLN ?? "").toList();
              gln = table.map((e) => e.gLN ?? "").toList();
              dropdownList = dropdownList.toSet().toList();
              dropdownValue = dropdownList[0];
              // packedItemsCubit.getPackedItems();
            }
          },
          builder: (context, state) {
            if (state is GlnLoadingState) {
              return buildPlaceholder();
            }

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20),
                      //   width: double.infinity,
                      //   height: 50,
                      //   decoration: const BoxDecoration(
                      //     color: AppColors.white,
                      //     borderRadius: BorderRadius.all(Radius.circular(10)),
                      //     border: Border.fromBorderSide(
                      //         BorderSide(color: AppColors.grey)),
                      //   ),
                      //   child: DropdownButtonHideUnderline(
                      //     child: DropdownButton<String>(
                      //       value: dropdownValue,
                      //       icon: const Icon(Icons.arrow_drop_down),
                      //       iconSize: 24,
                      //       elevation: 16,
                      //       isExpanded: true,
                      //       style: const TextStyle(color: Colors.black),
                      //       onChanged: (String? newValue) {
                      //         setState(() {
                      //           dropdownValue = newValue;
                      //         });
                      //         packedItemsCubit.getPackedItems();
                      //       },
                      //       items: dropdownList
                      //           .map<DropdownMenuItem<String>>((String? value) {
                      //         return DropdownMenuItem<String>(
                      //           value: value,
                      //           child: Text(value!),
                      //         );
                      //       }).toList(),
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: MediaQuery.of(context).size.width * 1,
                        height: 40,
                        decoration:
                            const BoxDecoration(color: AppColors.primary),
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
                          child:
                              BlocConsumer<PackedItemsCubit, PackedItemsState>(
                            bloc: packedItemsCubit,
                            listener: (context, state) {
                              if (state is PackedItemsError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.message),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                              if (state is PackedItemsLoaded) {
                                products = state.data;
                              }
                            },
                            builder: (context, state) {
                              return RefreshIndicator(
                                onRefresh: () async {
                                  packedItemsCubit.getPackedItems();
                                },
                                child: ListView.builder(
                                  itemCount: products.length,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
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
                                            color: Colors.grey
                                                .withValues(alpha: 0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                        border: Border.all(
                                            color: Colors.grey
                                                .withValues(alpha: 0.2)),
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        title: Text(
                                          products[index].itemName ?? "",
                                          style: const TextStyle(
                                            fontSize: 13,
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
                                                  "${products[index].itemImage?.replaceAll(RegExp(r'^/+'), '').replaceAll("\\", "/")}",
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(
                                                Icons.image_outlined,
                                              ),
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
                                          child: Image.asset(
                                              "assets/icons/view.png"),
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
                              AppNavigator.goToPage(
                                context: context,
                                screen: const CompletePackingScreen(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(249, 75, 0, 1),
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
                ),
                Visibility(
                  visible: state is GlnLoadingState,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Padding buildPlaceholder() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // List header placeholder
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
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

          // List items placeholder
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                itemCount: 5, // Show 5 placeholder items
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  return Container(
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
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                      ),
                      title: Container(
                        width: double.infinity,
                        height: 16,
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      subtitle: Container(
                        width: 100,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      trailing: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Button placeholder
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 120,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

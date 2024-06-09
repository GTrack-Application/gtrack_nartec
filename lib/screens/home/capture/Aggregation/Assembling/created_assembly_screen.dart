// ignore_for_file: collection_methods_unrelated_type

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/cubit/capture/agregation/assembling_bundling/get_bundle_items/bundle_items_cubit.dart';
import 'package:gtrack_mobile_app/cubit/capture/agregation/assembling_bundling/get_bundle_items/bundle_items_state.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/models/capture/aggregation/assembling_bundling/BundleItemsModel.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Aggregation/Assembling/sub_assembles_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class CreatedAssemblyScreen extends StatefulWidget {
  const CreatedAssemblyScreen({super.key});

  @override
  State<CreatedAssemblyScreen> createState() => _CreatedAssemblyScreenState();
}

class _CreatedAssemblyScreenState extends State<CreatedAssemblyScreen> {
  BundleItemsCubit bundleItemsCubit = BundleItemsCubit();
  List<AssembleItemsModel> products = [];

  @override
  void initState() {
    super.initState();
    bundleItemsCubit.getAssembleItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // change the back button color to white
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Created Assembles'),
        backgroundColor: AppColors.pink,
      ),
      body: SafeArea(
        child: BlocConsumer<BundleItemsCubit, BundleItemsState>(
          bloc: bundleItemsCubit,
          listener: (context, state) {
            if (state is BundleItemsError) {
              toast(state.message);
            }
            if (state is AssembleItemsLoaded) {
              products.addAll(state.items);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: context.width() * 1,
                    height: 40,
                    decoration: const BoxDecoration(color: AppColors.primary),
                    child: Text(
                      'List of Created Assemble Products (${products.length})',
                      style: const TextStyle(
                        fontSize: 15,
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
                      child: state is BundleItemsLoading
                          ? ListView.builder(
                              itemCount: 5,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
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
                                      title: Container(
                                        width: 100,
                                        height: 20,
                                        color: Colors.grey,
                                      ),
                                      subtitle: Container(
                                        width: 100,
                                        height: 20,
                                        color: Colors.grey,
                                      ),
                                      leading: Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : RefreshIndicator(
                              onRefresh: () async {
                                products.clear();
                                bundleItemsCubit.getAssembleItems();
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
                                        horizontal: 20, vertical: 10),
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
                                        products[index].bundlingName ?? "",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        products[index].gtin ?? "",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      leading: const Icon(
                                          Icons.shopping_bag_outlined),
                                      trailing: GestureDetector(
                                        onTap: () {
                                          AppNavigator.goToPage(
                                              context: context,
                                              screen: SubAssemblesScreen(
                                                gitn: products[index]
                                                    .gtin!
                                                    .trim()
                                                    .toString(),
                                                name: products[index]
                                                    .bundlingName!,
                                              ));
                                        },
                                        child: Image.asset(
                                            "assets/icons/view.png"),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
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

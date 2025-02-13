// ignore_for_file: collection_methods_unrelated_type, avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/Identify/gln/gln_cubit.dart';
import 'package:gtrack_nartec/blocs/Identify/gln/gln_states.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/controllers/capture/Association/Transfer/RawMaterialsToWIP/GetSalesPickingListCLRMByAssignToUserAndVendorController.dart';
import 'package:gtrack_nartec/cubit/capture/agregation/assembling_bundling/assembling_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/agregation/assembling_bundling/assembling_state.dart';
import 'package:gtrack_nartec/cubit/capture/agregation/assembling_bundling/create_bundle/create_bundle_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/agregation/assembling_bundling/create_bundle/create_bundle_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/models/Identify/GLN/GLNProductsModel.dart';
import 'package:gtrack_nartec/models/capture/aggregation/assembling_bundling/products_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/Bundling/created_bundle_screen.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/Bundling/gtin_details_screen.dart';
import 'package:shimmer/shimmer.dart';

class BundlingScreen extends StatefulWidget {
  const BundlingScreen({super.key});

  @override
  State<BundlingScreen> createState() => _BundlingScreenState();
}

class _BundlingScreenState extends State<BundlingScreen> {
  TextEditingController searchController = TextEditingController();
  TextEditingController bundleNameController = TextEditingController();

  CreateBundleCubit createBundleCubit = CreateBundleCubit();

  AssemblingCubit assembleCubit = AssemblingCubit();
  List<ProductsModel> products = [];

  GlnCubit glnCubit = GlnCubit();

  List<GLNProductsModel> table = [];

  List<String> dropdownList = [];
  String? dropdownValue;

  List<String> gln = [];
  String? glnValue;

  @override
  void initState() {
    super.initState();
    glnCubit.identifyGln();
  }

  bool isGlnLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bundling'),
        backgroundColor: AppColors.pink,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: BlocConsumer<AssemblingCubit, AssemblingState>(
              bloc: assembleCubit,
              listener: (context, state) {
                if (state is AssemblingError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                if (state is AssemblingLoaded) {
                  FocusNode().unfocus();
                  searchController.clear();
                  products.addAll(state.assemblings);
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocConsumer<GlnCubit, GlnState>(
                        bloc: glnCubit,
                        listener: (context, state) {
                          if (state is GlnErrorState) {
                            setState(() {
                              isGlnLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          if (state is GlnLoadedState) {
                            setState(() {
                              isGlnLoading = false;
                            });
                            table = state.data;
                            dropdownList = table
                                .map((e) =>
                                    "${e.locationNameEn ?? ""} - ${e.gLNBarcodeNumber}")
                                .toList();
                            gln = table
                                .map((e) => e.gLNBarcodeNumber ?? "")
                                .toList();
                            dropdownList = dropdownList.toSet().toList();
                            dropdownValue = dropdownList[0];
                            glnValue = gln[0];
                          }
                        },
                        builder: (context, state) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            width: double.infinity,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border: Border.fromBorderSide(
                                  BorderSide(color: AppColors.grey)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: dropdownValue,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                isExpanded: true,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue;
                                    glnValue =
                                        gln[dropdownList.indexOf(newValue!)];
                                    print("GLN Value: $glnValue");
                                  });
                                },
                                items: dropdownList
                                    .map<DropdownMenuItem<String>>(
                                        (String? value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value!),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 3,
                            child: SizedBox(
                              height: 40,
                              child: TextField(
                                controller: searchController,
                                onSubmitted: (value) {
                                  FocusScope.of(context).unfocus();
                                  assembleCubit.getBundlingProductsByGtin(
                                      searchController.text.trim());
                                },
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 10, top: 5),
                                  hintText: 'Scan GTIN',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                assembleCubit.getBundlingProductsByGtin(
                                    searchController.text.trim());
                              },
                              child: SizedBox(
                                height: 30,
                                child: Image.asset(
                                  'assets/icons/qr_code.png',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: MediaQuery.of(context).size.width * 1,
                        height: 40,
                        decoration:
                            const BoxDecoration(color: AppColors.primary),
                        child: const Text(
                          'List of Products',
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
                          child: state is AssemblingLoading
                              ? ListView.builder(
                                  itemCount: 5,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                          border: Border.all(
                                              color:
                                                  Colors.grey.withOpacity(0.2)),
                                        ),
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(10),
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
                              : ListView.builder(
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
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                        border: Border.all(
                                            color:
                                                Colors.grey.withOpacity(0.2)),
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        title: Text(
                                          products[index].productnameenglish ??
                                              "",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          products[index].barcode ?? "",
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                        leading: Hero(
                                          tag: products[index].id ?? "",
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "${AppUrls.baseUrlWith3093}${products[index].frontImage?.replaceAll(RegExp(r'^/+'), '').replaceAll("\\", "/") ?? ''}",
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(
                                                          Icons.image_outlined),
                                            ),
                                          ),
                                        ),
                                        trailing: GestureDetector(
                                          onTap: () {
                                            AppNavigator.goToPage(
                                              context: context,
                                              screen: GTINDetailsScreen(
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
                        ),
                      ),
                      const SizedBox(height: 10),
                      products.isEmpty
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                BlocConsumer<CreateBundleCubit,
                                    CreateBundleState>(
                                  bloc: createBundleCubit,
                                  listener: (context, state) {
                                    if (state is CreateBundleError) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(state.message),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                    if (state is CreateBundleLoaded) {
                                      RawMaterialsToWIPController
                                              .insertGtrackEPCISLog(
                                                  "packing",
                                                  products[0]
                                                      .barcode
                                                      .toString(),
                                                  glnValue.toString(),
                                                  products[0]
                                                      .gcpGLNID
                                                      .toString(),
                                                  'manufacturing')
                                          .then((value) {
                                        print("EPCIS Log Inserted");
                                      }).onError((error, stackTrace) {
                                        print("EPCIS Log error: $error");
                                      });

                                      setState(() {
                                        searchController.clear();
                                        products = [];
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Bundle Created Successfully"),
                                          backgroundColor: Colors.green,
                                        ),
                                      );

                                      AppNavigator.goToPage(
                                        context: context,
                                        screen: const CreatedBundleScreen(),
                                      );
                                    }
                                  },
                                  builder: (context, state) {
                                    return ElevatedButton(
                                      onPressed: () {
                                        // show dialog
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    'Create Bundle',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    icon: const Icon(
                                                        Icons.cancel),
                                                  )
                                                ],
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller:
                                                        bundleNameController,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: 'Bundle Name',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      createBundleCubit
                                                          .createBundle(
                                                        products
                                                            .map((e) =>
                                                                e.barcode!)
                                                            .toList(),
                                                        dropdownValue
                                                            .toString()
                                                            .trim(),
                                                        bundleNameController
                                                            .text
                                                            .trim(),
                                                      );
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          const Color.fromRGBO(
                                                              249, 75, 0, 1),
                                                    ),
                                                    child: state
                                                            is CreateBundleLoading
                                                        ? const Center(
                                                            child: CircularProgressIndicator(
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                            Color>(
                                                                        Colors
                                                                            .white)))
                                                        : const Text(
                                                            'Create Bundle',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color.fromRGBO(249, 75, 0, 1),
                                      ),
                                      child: state is CreateBundleLoading
                                          ? const Center(
                                              child: CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.white)))
                                          : const Text(
                                              'Create Bundle',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                              ),
                                            ),
                                    );
                                  },
                                ),
                                Text("Total Of GTIN: ${products.length}"),
                              ],
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
          Visibility(
            visible: isGlnLoading == true ? true : false,
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

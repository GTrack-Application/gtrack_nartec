// ignore_for_file: collection_methods_unrelated_type, avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/Identify/gln/gln_cubit.dart';
import 'package:gtrack_nartec/blocs/Identify/gln/gln_states.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/features/capture/cubits/association/receiving/raw_materials/direct_receipt/direct_receipt_cubit.dart';
import 'package:gtrack_nartec/features/capture/cubits/association/receiving/raw_materials/direct_receipt/direct_receipt_state.dart';
import 'package:gtrack_nartec/features/capture/cubits/association/receiving/raw_materials/direct_receipt/get_shipment_data/get_shipment_cubit.dart';
import 'package:gtrack_nartec/features/capture/cubits/association/receiving/raw_materials/direct_receipt/get_shipment_data/get_shipment_state.dart';
import 'package:gtrack_nartec/features/capture/cubits/association/receiving/raw_materials/item_details/item_details_cubit.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/features/capture/models/Association/Receiving/raw_materials/direct_receipt/ShipmentDataModel.dart';
import 'package:gtrack_nartec/features/capture/models/aggregation/packing/PackedItemsModel.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Receiving/direct_receipt/direct_receipt_details_screen.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Receiving/direct_receipt/direct_receipt_save_screen.dart';

class DirectReceiptScreen extends StatefulWidget {
  const DirectReceiptScreen({super.key});

  @override
  State<DirectReceiptScreen> createState() => _DirectReceiptScreenState();
}

class _DirectReceiptScreenState extends State<DirectReceiptScreen> {
  GlnCubit glnCubit = GlnCubit();
  DirectReceiptCubit directReceiptCubit = DirectReceiptCubit();

  GetShipmentCubit getShipmentCubit = GetShipmentCubit();
  List<ShipmentDataModel> products = [];

  List<PackedItemsModel> table = [];
  List<Map<String, dynamic>> data = [];

  List<String> dropdownList = [];
  String? dropdownValue;

  List<String> receivingType = [];
  String? receivingTypeValue;

  List<String> gln = [];
  List<String> receivingTypeValueIdList = [];
  String? receivingTypeValueId;

  List<String> glnLocation = [];
  String? glnLocaitonValue;

  @override
  void initState() {
    super.initState();
    glnCubit.identifyGln();
    directReceiptCubit.getReceivingTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Direct Receipts'),
        backgroundColor: AppColors.pink,
      ),
      body: SafeArea(
        child: BlocConsumer<GlnCubit, GlnState>(
          bloc: glnCubit,
          listener: (context, state) {
            if (state is GlnErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
            if (state is GlnLoadedState) {
              table = state.data;
              dropdownList = table.map((e) => e.gLN ?? "").toList();

              gln = table.map((e) => e.gTIN ?? "").toList();
              dropdownList = dropdownList.toSet().toList();
              dropdownValue = dropdownList[0];
              ItemDetailsCubit.get(context).glnIdFrom = dropdownValue;
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Padding(
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
                            isExpanded: true,
                            style: const TextStyle(color: Colors.black),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue;
                                print(gln);
                                ItemDetailsCubit.get(context).glnIdFrom =
                                    newValue;
                              });
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
                      BlocConsumer<DirectReceiptCubit, DirectReceiptState>(
                        bloc: directReceiptCubit,
                        listener: (context, state) {
                          if (state is DirectReceiptError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    state.message.replaceAll("Exception:", "")),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          if (state is DirectReceiptLoaded) {
                            receivingType = state.directReceiptModel
                                .map((e) => e['ReceivingType'].toString())
                                .toList();
                            receivingTypeValue = receivingType[0];
                            ItemDetailsCubit.get(context).typeOfTransaction =
                                receivingTypeValue;
                            receivingTypeValueIdList = state.directReceiptModel
                                .map((e) => e['id'].toString())
                                .toList();
                            receivingTypeValueId = receivingTypeValueIdList[0];
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
                                value: receivingTypeValue,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                isExpanded: true,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    receivingTypeValue = newValue;
                                    ItemDetailsCubit.get(context)
                                        .typeOfTransaction = newValue;
                                    receivingTypeValueId =
                                        receivingTypeValueIdList[
                                            receivingType.indexOf(newValue!)];
                                  });
                                },
                                items: receivingType
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
                      const SizedBox(height: 10),
                      Text(
                        receivingTypeValue.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: TextField(
                                controller: ItemDetailsCubit.get(context)
                                    .shipmentIdController,
                                onEditingComplete: () {
                                  if (ItemDetailsCubit.get(context)
                                      .shipmentIdController
                                      .text
                                      .isEmpty) {
                                    // hide keyboard
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  }
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  getShipmentCubit.getShipmentData(
                                    receivingTypeValueId.toString(),
                                    ItemDetailsCubit.get(context)
                                        .shipmentIdController
                                        .text
                                        .trim()
                                        .toString(),
                                  );
                                },
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 10, top: 5),
                                  hintText: '$receivingTypeValue Number',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              getShipmentCubit.getShipmentData(
                                receivingTypeValueId.toString(),
                                ItemDetailsCubit.get(context)
                                    .shipmentIdController
                                    .text
                                    .trim()
                                    .toString(),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.grey),
                              ),
                              height: 40,
                              width: 40,
                              child: const Icon(
                                Icons.search,
                                color: AppColors.black,
                                size: 30,
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
                        decoration: const BoxDecoration(color: AppColors.pink),
                        child: const Text(
                          'List of Items',
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
                              BlocConsumer<GetShipmentCubit, GetShipmentState>(
                            bloc: getShipmentCubit,
                            listener: (context, state) {
                              if (state is GetShipmentError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.message
                                        .replaceAll("Exception:", "")),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                              if (state is GetShipmentLoaded) {
                                products.add(state.shipment);
                              }
                            },
                            builder: (context, state) {
                              return RefreshIndicator(
                                onRefresh: () async {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  getShipmentCubit.getShipmentData(
                                    receivingTypeValueId.toString(),
                                    ItemDetailsCubit.get(context)
                                        .shipmentIdController
                                        .text
                                        .trim()
                                        .toString(),
                                  );
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
                                        onTap: () {
                                          AppNavigator.goToPage(
                                            context: context,
                                            screen: DirectReceiptSaveScreen(
                                              productsModel: products[index],
                                              location: gln[index],
                                            ),
                                          );
                                        },
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        title: Text(
                                          products[index].brandName ?? "",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          products[index].brandName ?? "",
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
                                              screen:
                                                  DirectReceiptDetailsScreen(
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
                    ],
                  ),
                ),
                Visibility(
                  visible:
                      state is GlnLoadingState || state is DirectReceiptLoading,
                  child: const Center(
                      child: CircularProgressIndicator(color: AppColors.pink)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

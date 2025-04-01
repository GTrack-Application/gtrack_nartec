// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/features/capture/controllers/Association/Transfer/RawMaterialsToWIP/GetSalesPickingListCLRMByAssignToUserAndVendorController.dart';
import 'package:gtrack_nartec/features/capture/cubits/association/receiving/raw_materials/direct_receipt/unit_country_list/unit_country_cubit.dart';
import 'package:gtrack_nartec/features/capture/cubits/association/receiving/raw_materials/direct_receipt/unit_country_list/unit_country_state.dart';
import 'package:gtrack_nartec/features/capture/cubits/association/receiving/raw_materials/item_details/item_details_cubit.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/features/capture/models/Association/Receiving/raw_materials/direct_receipt/ShipmentDataModel.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Receiving/direct_receipt/asset_details_screen.dart';
import 'package:intl/intl.dart';

class DirectReceiptSaveScreen extends StatefulWidget {
  const DirectReceiptSaveScreen({
    super.key,
    required this.productsModel,
    required this.location,
  });
  final ShipmentDataModel productsModel;
  final String location;

  @override
  State<DirectReceiptSaveScreen> createState() =>
      _DirectReceiptSaveScreenState();
}

class _DirectReceiptSaveScreenState extends State<DirectReceiptSaveScreen> {
  FocusNode searchFocusNode = FocusNode();
  FocusNode quantityFocusNode = FocusNode();
  FocusNode batchNoFocusNode = FocusNode();
  FocusNode expiryDateFocusNode = FocusNode();
  FocusNode manufactureDateFocusNode = FocusNode();
  FocusNode netWeightFocusNode = FocusNode();
  FocusNode transpoGLNFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    ItemDetailsCubit.get(context).unitCubit.getUnits();
    ItemDetailsCubit.get(context).countryCubit.getCountries();
  }

  @override
  void dispose() {
    super.dispose();

    quantityFocusNode.dispose();
    batchNoFocusNode.dispose();
    expiryDateFocusNode.dispose();
    manufactureDateFocusNode.dispose();
    netWeightFocusNode.dispose();
    transpoGLNFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Item Details'),
        backgroundColor: AppColors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.productsModel.productnameenglish ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              widget.productsModel.barcode ?? "",
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              widget.productsModel.hsDescription ?? "",
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(border: Border.all()),
                      child: CachedNetworkImage(
                        imageUrl:
                            "${AppUrls.baseUrlWith3091}${widget.productsModel.frontImage!.replaceAll(RegExp(r'^/+|/+$'), '').replaceAll("\\", "/")}",
                        width: 60,
                        height: MediaQuery.of(context).size.height * 0.1,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.image_outlined),
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
              SizedBox(height: 10),
              const Text(
                "QUANTITY",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(
                height: 40,
                child: TextField(
                  controller: ItemDetailsCubit.get(context).quantityController,
                  focusNode: quantityFocusNode,
                  onSubmitted: (value) {
                    batchNoFocusNode.requestFocus();
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10, top: 5),
                    hintText: 'Quantity',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              const Text(
                "BATCH NO",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(
                height: 40,
                child: TextField(
                  controller: ItemDetailsCubit.get(context).batchNoController,
                  focusNode: batchNoFocusNode,
                  onSubmitted: (value) {
                    expiryDateFocusNode.requestFocus();
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10, top: 5),
                    hintText: 'Batch No',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              const Text(
                "EXPIRY DATE",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(
                height: 40,
                child: TextField(
                  controller:
                      ItemDetailsCubit.get(context).expiryDateController,
                  focusNode: expiryDateFocusNode,
                  onSubmitted: (value) {
                    manufactureDateFocusNode.requestFocus();
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        // show date picker and set the selected date to expiryDateController
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        ).then(
                          (value) {
                            if (value != null) {
                              ItemDetailsCubit.get(context)
                                      .expiryDateController
                                      .text =
                                  DateFormat('dd-MM-yyyy').format(value);

                              ItemDetailsCubit.get(context).expiryDate =
                                  DateFormat('yyyy-MM-dd').format(value);
                            }
                          },
                        );
                      },
                      icon: const Icon(Icons.calendar_today),
                    ),
                    contentPadding: const EdgeInsets.only(left: 10, top: 5),
                    hintText: 'Expiry Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              const Text(
                "MANUFACTURE DATE",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(
                height: 40,
                child: TextField(
                  controller:
                      ItemDetailsCubit.get(context).manufactureDateController,
                  focusNode: manufactureDateFocusNode,
                  onSubmitted: (value) {
                    netWeightFocusNode.requestFocus();
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        ).then(
                          (value) {
                            if (value != null) {
                              ItemDetailsCubit.get(context)
                                      .manufactureDateController
                                      .text =
                                  DateFormat("dd-MM-yyyy").format(value);

                              ItemDetailsCubit.get(context).manufactureDate =
                                  DateFormat("yyyy-MM-dd").format(value);
                            }
                          },
                        );
                      },
                      icon: const Icon(Icons.calendar_today),
                    ),
                    contentPadding: const EdgeInsets.only(left: 10, top: 5),
                    hintText: 'Manufacture Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              const Text(
                "NET WEIGHT",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(
                height: 40,
                child: TextField(
                  controller: ItemDetailsCubit.get(context).netWeightController,
                  focusNode: netWeightFocusNode,
                  onSubmitted: (value) {},
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10, top: 5),
                    hintText: 'Net Weight',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              const Text(
                "UNIT OF MEASURE",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              // dropdown for unit of measure
              BlocConsumer<UnitCountryCubit, UnitCountryState>(
                bloc: ItemDetailsCubit.get(context).unitCubit,
                listener: (context, state) {
                  print(state);

                  if (state is UnitLoaded) {
                    ItemDetailsCubit.get(context).unitList =
                        state.units.map((e) => e.unitName ?? "").toList();
                    // remove empty and null values from list
                    ItemDetailsCubit.get(context)
                        .unitList
                        .removeWhere((element) => element == "");
                    ItemDetailsCubit.get(context).unitValue =
                        ItemDetailsCubit.get(context).unitList.first;
                  }
                  if (state is UnitError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message
                            .toString()
                            .replaceAll("Exception", "")),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return DropdownButtonFormField<String>(
                    value: ItemDetailsCubit.get(context).unitValue,
                    items: ItemDetailsCubit.get(context)
                        .unitList
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        ItemDetailsCubit.get(context).unitValue = value;
                      });
                    },
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 10, top: 5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              const Text(
                "TRANSPO GLN",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(
                height: 40,
                child: TextField(
                  controller:
                      ItemDetailsCubit.get(context).transpoGLNController,
                  focusNode: transpoGLNFocusNode,
                  onSubmitted: (value) {},
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10, top: 5),
                    hintText: 'Transpo GLN',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              const Text(
                "PUT AWAY LOCATION",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              // dropdown for put away location
              BlocConsumer<UnitCountryCubit, UnitCountryState>(
                bloc: ItemDetailsCubit.get(context).countryCubit,
                listener: (context, state) {
                  print(state);
                  if (state is CountryLoaded) {
                    ItemDetailsCubit.get(context).locationList = state.countries
                        .map((e) => e.countryName ?? "")
                        .toList();
                    // remove empty and null values from list
                    ItemDetailsCubit.get(context)
                        .locationList
                        .removeWhere((element) => element == "");

                    ItemDetailsCubit.get(context).locationValue =
                        ItemDetailsCubit.get(context).locationList.first;
                  }
                  if (state is CountryError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message
                            .toString()
                            .replaceAll("Exception", "")),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return DropdownButtonFormField<String>(
                    value: ItemDetailsCubit.get(context).locationValue,
                    items: ItemDetailsCubit.get(context)
                        .locationList
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        ItemDetailsCubit.get(context).locationValue = value;
                      });
                    },
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 10, top: 5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      AppNavigator.goToPage(
                        context: context,
                        screen: const AssetDetailsScreen(),
                      );
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text(
                      'Click to Enter Asset Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  BlocConsumer<ItemDetailsCubit, ItemDetailsState>(
                    listener: (context, state) {
                      if (state is ItemDetailsSuccess) {
                        RawMaterialsToWIPController.insertGtrackEPCISLog(
                          "receiving",
                          widget.productsModel.barcode.toString(),
                          widget.location,
                          widget.productsModel.gcpGLNID.toString(),
                          'manufacturing',
                        ).then((value) {
                          print("EPCIS Log Inserted");
                        }).onError((error, stackTrace) {
                          print("EPCIS Log error: $error");
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Item details saved successfully!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        ItemDetailsCubit.get(context).clearEverything();
                        Navigator.pop(context);
                      } else if (state is ItemDetailsError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message.toString()),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is ItemDetailsLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ElevatedButton(
                        onPressed: () {
                          if (ItemDetailsCubit.get(context)
                                  .quantityController
                                  .text
                                  .isEmpty ||
                              ItemDetailsCubit.get(context)
                                  .batchNoController
                                  .text
                                  .isEmpty ||
                              ItemDetailsCubit.get(context)
                                  .expiryDateController
                                  .text
                                  .isEmpty ||
                              ItemDetailsCubit.get(context)
                                  .manufactureDateController
                                  .text
                                  .isEmpty ||
                              ItemDetailsCubit.get(context)
                                  .netWeightController
                                  .text
                                  .isEmpty ||
                              ItemDetailsCubit.get(context).unitValue == "" ||
                              ItemDetailsCubit.get(context).locationValue ==
                                  "") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text("Please fill all the above fields!"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          ItemDetailsCubit.get(context).saveItemDetails(
                            widget.productsModel,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        child: const Text(
                          'Submit and Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

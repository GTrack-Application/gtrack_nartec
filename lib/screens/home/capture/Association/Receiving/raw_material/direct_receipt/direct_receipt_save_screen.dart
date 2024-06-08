import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/controllers/capture/Association/Transfer/RawMaterialsToWIP/GetSalesPickingListCLRMByAssignToUserAndVendorController.dart';
import 'package:gtrack_mobile_app/cubit/capture/association/receiving/raw_materials/item_details/item_details_cubit.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/models/capture/Association/Receiving/raw_materials/direct_receipt/ShipmentDataModel.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Association/Receiving/raw_material/direct_receipt/asset_details_screen.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class DirectReceiptSaveScreen extends StatefulWidget {
  const DirectReceiptSaveScreen({super.key, required this.productsModel});
  final ShipmentDataModel productsModel;

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
  FocusNode unitFocusNode = FocusNode();
  FocusNode transpoGLNFocusNode = FocusNode();
  FocusNode putAwayLocationFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // quantityController.dispose();
    // batchNoController.dispose();
    // expiryDateController.dispose();
    // manufactureDateController.dispose();
    // netWeightController.dispose();
    // unitController.dispose();
    // transpoGLNController.dispose();
    // putAwayLocation.dispose();

    quantityFocusNode.dispose();
    batchNoFocusNode.dispose();
    expiryDateFocusNode.dispose();
    manufactureDateFocusNode.dispose();
    netWeightFocusNode.dispose();
    unitFocusNode.dispose();
    transpoGLNFocusNode.dispose();
    putAwayLocationFocusNode.dispose();
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
              10.height,
              Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    10.width,
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
                            5.height,
                            Text(
                              widget.productsModel.barcode ?? "",
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.primary,
                              ),
                            ),
                            5.height,
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
                        height: context.height() * 0.1,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.image_outlined),
                      ),
                    ),
                    10.width,
                  ],
                ),
              ),
              10.height,
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
              10.height,
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
              10.height,
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
                        ).then((value) {
                          if (value != null) {
                            ItemDetailsCubit.get(context)
                                .expiryDateController
                                .text = DateFormat('yyyy-MM-dd').format(value);
                          }
                        });
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
              10.height,
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
                        ).then((value) {
                          if (value != null) {
                            ItemDetailsCubit.get(context)
                                .manufactureDateController
                                .text = DateFormat('yyyy-MM-dd').format(value);
                          }
                        });
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
              10.height,
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
                  onSubmitted: (value) {
                    unitFocusNode.requestFocus();
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10, top: 5),
                    hintText: 'Net Weight',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              10.height,
              const Text(
                "UNIT OF MEASURE",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(
                height: 40,
                child: TextField(
                  controller: ItemDetailsCubit.get(context).unitController,
                  focusNode: unitFocusNode,
                  onSubmitted: (value) {
                    unitFocusNode.unfocus();
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10, top: 5),
                    hintText: 'Unit of Measure',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              10.height,
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
                  onSubmitted: (value) {
                    putAwayLocationFocusNode.requestFocus();
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10, top: 5),
                    hintText: 'Transpo GLN',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              10.height,
              const Text(
                "PUT AWAY LOCATION",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(
                height: 40,
                child: TextField(
                  controller: ItemDetailsCubit.get(context).putAwayLocation,
                  focusNode: putAwayLocationFocusNode,
                  onSubmitted: (value) {
                    putAwayLocationFocusNode.unfocus();
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10, top: 5),
                    hintText: 'Put Away Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              10.height,
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
                        insertGtrackEPCISLog();
                        toast("Item details saved successfully!");
                        ItemDetailsCubit.get(context).clearEverything();
                        Navigator.pop(context);
                      } else if (state is ItemDetailsError) {
                        toast(state.message.toString());
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
                              ItemDetailsCubit.get(context)
                                  .unitController
                                  .text
                                  .isEmpty) {
                            toast("Please fill all the above fields!");
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
              20.height,
            ],
          ),
        ),
      ),
    );
  }

  insertGtrackEPCISLog() async {
    RawMaterialsToWIPController.insertGtrackEPCISLog(
      "Receiving (Direct Receipt)",
      widget.productsModel.barcode.toString(),
      widget.productsModel.gcpGLNID.toString(),
      widget.productsModel.gcpGLNID.toString(),
      'Manufacturing',
    );
  }
}

import 'package:gtrack_mobile_app/cubit/capture/agregation/packing/complete_packing/complete_packing_cubit.dart';
import 'package:gtrack_mobile_app/cubit/capture/agregation/packing/complete_packing/complete_packing_state.dart';
import 'package:gtrack_mobile_app/cubit/capture/agregation/packing/packed_items/packed_items_cubit.dart';
import 'package:gtrack_mobile_app/models/capture/aggregation/packing/GtinProductDetailsModel.dart';
import 'package:gtrack_mobile_app/cubit/capture/agregation/packing/packing_state.dart';
import 'package:gtrack_mobile_app/cubit/capture/agregation/packing/packing_cubit.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CompletePackingScreen extends StatefulWidget {
  const CompletePackingScreen({super.key});

  @override
  State<CompletePackingScreen> createState() => _CompletePackingScreenState();
}

class _CompletePackingScreenState extends State<CompletePackingScreen> {
  TextEditingController searchController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController batchNoController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController manufactureDateController = TextEditingController();
  TextEditingController netWeightController = TextEditingController();
  TextEditingController unitController = TextEditingController();

  FocusNode searchFocusNode = FocusNode();
  FocusNode quantityFocusNode = FocusNode();
  FocusNode batchNoFocusNode = FocusNode();
  FocusNode expiryDateFocusNode = FocusNode();
  FocusNode manufactureDateFocusNode = FocusNode();
  FocusNode netWeightFocusNode = FocusNode();
  FocusNode unitFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    quantityController.dispose();
    batchNoController.dispose();
    expiryDateController.dispose();
    manufactureDateController.dispose();
    netWeightController.dispose();
    unitController.dispose();

    quantityFocusNode.dispose();
    batchNoFocusNode.dispose();
    expiryDateFocusNode.dispose();
    manufactureDateFocusNode.dispose();
    netWeightFocusNode.dispose();
    unitFocusNode.dispose();
  }

  PackingCubit packingCubit = PackingCubit();
  GtinProductDetailsModel? product;

  CompletePackingCubit completePackingCubit = CompletePackingCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('View / Validate GTIN'),
        backgroundColor: AppColors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocConsumer<PackingCubit, PackingState>(
                bloc: packingCubit,
                listener: (context, state) {
                  if (state is PackingError) {
                    toast(state.message);
                  }
                  if (state is PackingLoaded) {
                    setState(() {
                      product = state.data;
                    });
                  }
                },
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: 40,
                          child: TextField(
                            controller: searchController,
                            focusNode: searchFocusNode,
                            onSubmitted: (value) {
                              searchFocusNode.unfocus();
                              packingCubit.identifyGln(value.trim());
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
                      5.width,
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            searchFocusNode.unfocus();
                            packingCubit
                                .identifyGln(searchController.text.trim());
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
                  );
                },
              ),
              10.height,
              Visibility(
                visible: product != null,
                child: Container(
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
                                product?.data?.productName ?? "",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              5.height,
                              Text(
                                product?.data?.gtin ?? "",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                ),
                              ),
                              5.height,
                              Text(
                                product?.data?.productDescription?.value ?? "",
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
                              "${AppUrls.baseUrlWith3091}${product?.data?.productImageUrl?.value?.replaceAll(RegExp(r'^/+|/+$'), '').replaceAll("\\", "/")}",
                          width: 60,
                          height: context.height() * 0.1,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      10.width,
                    ],
                  ),
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
                  controller: quantityController,
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
                  controller: batchNoController,
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
                  controller: expiryDateController,
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
                            expiryDateController.text =
                                DateFormat('yyyy-MM-dd').format(value);
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
                  controller: manufactureDateController,
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
                            manufactureDateController.text =
                                DateFormat('yyyy-MM-dd').format(value);
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
                  controller: netWeightController,
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
                  controller: unitController,
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
              Visibility(
                visible: product != null,
                child: BlocConsumer<CompletePackingCubit, CompletePackingState>(
                  bloc: completePackingCubit,
                  listener: (context, state) {
                    if (state is CompletePackingError) {
                      toast(state.message);
                    }
                    if (state is CompletePackingLoaded) {
                      toast("Packing Completed Successfully!");
                      // searchController.clear();
                      // quantityController.clear();
                      // batchNoController.clear();
                      // expiryDateController.clear();
                      // manufactureDateController.clear();
                      // netWeightController.clear();
                      // unitController.clear();

                      // setState(() {
                      //   product = null;
                      // });
                      context
                          .read<PackedItemsCubit>()
                          .getPackedItems(product!.data!.gcpGLNID.toString());
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
                  },
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (searchController.text.isEmpty ||
                                quantityController.text.isEmpty ||
                                batchNoController.text.isEmpty ||
                                expiryDateController.text.isEmpty ||
                                manufactureDateController.text.isEmpty ||
                                netWeightController.text.isEmpty ||
                                unitController.text.isEmpty) {
                              toast("Please fill all the above fields!");
                              return;
                            }
                            completePackingCubit.completePacking(
                              product?.data?.gtin ?? "",
                              batchNoController.text.trim(),
                              manufactureDateController.text.trim(),
                              expiryDateController.text.trim(),
                              int.parse(quantityController.text.trim()),
                              product?.data?.gcpGLNID ?? "",
                              double.parse(netWeightController.text.trim()),
                              unitController.text.trim(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(249, 75, 0, 1),
                          ),
                          child: state is CompletePackingLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white)))
                              : const Text(
                                  'Packing Complete',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              20.height,
            ],
          ),
        ),
      ),
    );
  }
}

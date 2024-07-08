// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gtrack_mobile_app/blocs/Identify/gtin/gtin_cubit.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/models/IDENTIFY/GTIN/gpc_by_search_model.dart';
import 'package:gtrack_mobile_app/screens/home/identify/controller/add_gtin_controller.dart';
import 'package:gtrack_mobile_app/screens/home/identify/cubit/add_gtin_cubit.dart';
import 'package:gtrack_mobile_app/screens/home/identify/cubit/add_gtin_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart'; // Ensure this package is properly imported and used
import 'package:flutter/material.dart';

class AddGtinScreen extends StatefulWidget {
  const AddGtinScreen({super.key});

  @override
  State<AddGtinScreen> createState() => _AddGtinScreenState();
}

class _AddGtinScreenState extends State<AddGtinScreen> {
  TextEditingController productNameEngController = TextEditingController();
  TextEditingController productNameArbController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController descriptionControllerEng = TextEditingController();
  TextEditingController descriptionControllerArb = TextEditingController();
  TextEditingController productUrlController = TextEditingController();

  FocusNode productNameEngNode = FocusNode();
  FocusNode productNameArbNode = FocusNode();
  FocusNode sizeNode = FocusNode();
  FocusNode descriptionEngNode = FocusNode();
  FocusNode descriptionArbNode = FocusNode();
  FocusNode productUrlNode = FocusNode();

  String brandsNameEngValue = '';
  List<String> brandsNameEngList = [];

  String brandsNameArbValue = '';
  List<String> brandsNameArbList = [];

  String? unitCodeValue;
  List<String> unitCodeList = [];

  String? originValue;
  List<String> originList = [];

  String? countryOfSaleValue;
  List<String> countryOfSaleList = [];

  String? productDesctiptionLanguageValue;
  List<String> productDesctiptionLanguageList = [];

  String? productTypeValue;
  List<String> productTypeList = [];

  String? packageTypeValue;
  List<String> packageTypeList = [];

  String? gpcValue;
  List<String> gpcList = [];

  String? hsCodeValue;
  List<String> hsCodeList = [];

  AddGtinCubit cubit = AddGtinCubit();

  bool isGpcByMyself = false;

  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  SuggestionsController<GPCBySearchModel> searchSuggestionsController =
      SuggestionsController();

  @override
  void initState() {
    super.initState();
    cubit.fetAddGtinData();
  }

  @override
  void dispose() {
    productNameEngController.dispose();
    productNameArbController.dispose();
    sizeController.dispose();
    descriptionControllerEng.dispose();
    descriptionControllerArb.dispose();
    productUrlController.dispose();
    productNameEngNode.dispose();
    productNameArbNode.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add GTIN Product'),
        backgroundColor: AppColors.skyBlue,
      ),
      body: BlocConsumer<AddGtinCubit, AddGtinState>(
        bloc: cubit,
        listener: (context, state) {
          print(state);
          if (state is AddGtinBrandLoaded) {
            setState(() {
              isLoading = false;
              descriptionControllerEng.text =
                  "${productNameEngController.text.trim()} - ${sizeController.text.trim()} - ${hsCodeValue ?? ""} - ${state.brands[0].name.toString()}";
              descriptionControllerArb.text =
                  "${productNameArbController.text.trim()} - ${sizeController.text.trim()} - ${hsCodeValue ?? ""} - ${state.brands[0].nameAr.toString()}";
            });

            for (var element in state.brands) {
              brandsNameEngList.add(element.name.toString());
              brandsNameArbList.add(element.nameAr.toString());
            }
            brandsNameEngValue = brandsNameEngList.first;
            brandsNameArbValue = brandsNameArbList.first;
          } else if (state is AddGtinUnitLoaded) {
            setState(() {
              isLoading = false;
            });
            unitCodeList.clear();

            for (var element in state.units) {
              unitCodeList.add(element.unitName.toString());
            }
            unitCodeValue = unitCodeList.first;
          } else if (state is AddGtinOriginLoaded) {
            setState(() {
              isLoading = false;
            });
            originList.clear();
            countryOfSaleList.clear();

            for (var element in state.origins) {
              originList.add(element.countryName.toString());
              countryOfSaleList.add(element.countryName.toString());
            }
            // convert list to String
            originList = originList.toSet().toList();
            countryOfSaleList = countryOfSaleList.toSet().toList();

            originValue = originList.first;
            countryOfSaleValue = countryOfSaleList.first;
          } else if (state is AddGtinProductDesLoaded) {
            setState(() {
              isLoading = false;
            });
            productDesctiptionLanguageList.clear();

            for (var element in state.productDesc) {
              productDesctiptionLanguageList
                  .add(element.languageName.toString());
            }

            productDesctiptionLanguageList =
                productDesctiptionLanguageList.toSet().toList();

            productDesctiptionLanguageValue =
                productDesctiptionLanguageList.first;
          } else if (state is AddGtinProductTypeLoaded) {
            setState(() {
              isLoading = false;
            });
            productTypeList.clear();

            for (var element in state.productType) {
              productTypeList.add(element.name.toString());
            }

            productTypeValue = productTypeList.first;
          } else if (state is AddGtinPackageTypeLoaded) {
            setState(() {
              isLoading = false;
            });
            packageTypeList.clear();

            for (var element in state.packageType) {
              packageTypeList.add(element.name.toString());
            }

            packageTypeValue = packageTypeList.first;
          } else if (state is InsertGtinLoaded) {
            context.read<GtinCubit>().getGtinData();

            toast("Gtin Added Successfully!");
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Product Name [Eng]",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: TextField(
                          controller: productNameEngController,
                          focusNode: productNameEngNode,
                          onChanged: (value) {
                            setState(() {
                              descriptionControllerEng.text =
                                  "${value.toString()} - ${sizeController.text} - ${hsCodeValue ?? ""} - ${brandsNameEngValue.toString()}";
                              descriptionControllerArb.text =
                                  "${productNameArbController.text.trim()} - ${sizeController.text} - ${hsCodeValue ?? ""} - ${brandsNameArbValue.toString()}";
                            });
                          },
                          onSubmitted: (value) {
                            setState(() {
                              isLoading = true;
                              descriptionControllerEng.text =
                                  "${productNameEngController.text.trim()} - ${sizeController.text} - ${hsCodeValue ?? ""} - ${brandsNameEngValue.toString()}";

                              descriptionControllerArb.text =
                                  "${productNameArbController.text.trim()} - ${sizeController.text} - ${hsCodeValue ?? ""} - ${brandsNameArbValue.toString()}";
                            });
                            AddGtinController.fetchGpc(value.toString())
                                .then((val) {
                              setState(() {
                                gpcList.clear();

                                for (var element in val) {
                                  gpcList.add(
                                      element.metadata!.bricksTitle.toString());
                                }

                                gpcList = gpcList.toSet().toList();

                                gpcValue = gpcList.first;

                                isLoading = false;
                                AddGtinController.fetchHsCode(
                                        gpcValue.toString())
                                    .then((value) {
                                  setState(() {
                                    hsCodeList = value
                                        .toString()
                                        .replaceFirst("[", "")
                                        .replaceFirst("]", "")
                                        .split(",")
                                        .map((e) => e.toString())
                                        .toList();
                                    hsCodeValue = hsCodeList[0];

                                    isLoading = false;

                                    descriptionControllerEng.text =
                                        "${value.toString()} - ${sizeController.text} - ${hsCodeValue ?? ""} - ${brandsNameEngValue.toString()}";

                                    descriptionControllerArb.text =
                                        "${productNameArbController.text.trim()} - ${sizeController.text} - ${hsCodeValue ?? ""} - ${brandsNameArbValue.toString()}";
                                  });
                                }).onError((error, stackTrace) {
                                  print("Error: $error");
                                  setState(() {
                                    descriptionControllerEng.text =
                                        "${value.toString()} - ${sizeController.text} - ${hsCodeValue ?? ""} - ${brandsNameEngValue.toString()}";

                                    descriptionControllerArb.text =
                                        "${productNameArbController.text.trim()} - ${sizeController.text} - ${hsCodeValue ?? ""} - ${brandsNameArbValue.toString()}";
                                    isLoading = false;
                                  });
                                });
                              });
                            }).onError((error, stackTrace) {
                              setState(() {
                                descriptionControllerEng.text =
                                    "${value.toString()} - ${sizeController.text} - ${hsCodeValue ?? ""} - ${brandsNameEngValue.toString()}";

                                descriptionControllerArb.text =
                                    "${productNameArbController.text.trim()} - ${sizeController.text} - ${hsCodeValue ?? ""} - ${brandsNameArbValue.toString()}";
                                isLoading = false;
                              });
                              print('Error: $error');
                            });
                            FocusScope.of(context)
                                .requestFocus(productNameArbNode);
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(left: 10, top: 5),
                            hintText: 'Enter Product Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      10.height,
                      const Text(
                        "Product Name [Arabic]",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: TextField(
                          controller: productNameArbController,
                          focusNode: productNameArbNode,
                          onChanged: (value) {
                            setState(() {
                              descriptionControllerEng.text =
                                  "${productNameEngController.text.trim()} - ${sizeController.text} - ${hsCodeValue ?? ""} - ${brandsNameEngValue.toString()}";

                              descriptionControllerArb.text =
                                  "${value.toString()} - ${sizeController.text} - ${hsCodeValue ?? ""} - ${brandsNameArbValue.toString()}";
                            });
                          },
                          onSubmitted: (value) {
                            setState(() {
                              descriptionControllerEng.text =
                                  "${productNameEngController.text.trim()} - ${sizeController.text} - ${hsCodeValue ?? ""} - ${brandsNameEngValue.toString()}";

                              descriptionControllerArb.text =
                                  "${value.toString()} - ${sizeController.text} - ${hsCodeValue ?? ""} - ${brandsNameArbValue.toString()}";
                            });
                            FocusScope.of(context).unfocus();
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(left: 10, top: 5),
                            hintText: 'Enter Product Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      10.height,
                      const Text(
                        "Brand Name [Eng]",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      CustomDropdown(
                        value: brandsNameEngValue,
                        items: brandsNameEngList,
                        onChanged: (value) {
                          setState(() {
                            brandsNameEngValue = value.toString();
                          });
                          descriptionControllerEng.text =
                              "${productNameEngController.text} - ${sizeController.text.trim()} - ${hsCodeValue ?? ""} - ${value ?? ""}";
                        },
                        hintText: 'Select brand name',
                      ),
                      10.height,
                      const Text(
                        "Brand Name [Arabic]",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      CustomDropdown(
                        value: brandsNameArbValue,
                        items: brandsNameArbList,
                        onChanged: (value) {
                          setState(() {
                            brandsNameArbValue = value.toString();
                            descriptionControllerArb.text =
                                "${productNameArbController.text.trim()} - ${sizeController.text} - ${hsCodeValue ?? ""} - ${value.toString()}";
                          });
                        },
                        hintText: 'Select brand name',
                      ),
                      10.height,
                      const Text(
                        "Unit Code",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      CustomDropdown(
                        value: unitCodeValue ?? '',
                        items: unitCodeList,
                        onChanged: (value) {
                          setState(() {
                            unitCodeValue = value;
                          });
                        },
                        hintText: 'Select unit code',
                      ),

                      10.height,
                      const Text(
                        "Size",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: TextField(
                          controller: sizeController,
                          focusNode: sizeNode,
                          onChanged: (value) {
                            setState(() {
                              descriptionControllerEng.text =
                                  "${productNameEngController.text} - ${value.toString()} - ${hsCodeValue ?? ""} - ${brandsNameEngValue.toString()}";
                              descriptionControllerArb.text =
                                  "${productNameArbController.text} - ${value.toString()} - ${hsCodeValue ?? ""} - ${brandsNameArbValue.toString()}";
                            });
                          },
                          onSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(descriptionEngNode);
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(left: 10, top: 5),
                            hintText: 'Enter Size',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      10.height,
                      // dropdown for origin
                      const Text(
                        "Origin",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      CustomDropdown(
                        value: originValue ?? '',
                        items: originList,
                        onChanged: (value) {
                          setState(() {
                            originValue = value;
                          });
                        },
                        hintText: 'Select origin',
                      ),
                      10.height,
                      // dropdown for countryOfSale
                      const Text(
                        "Country of Sale",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      CustomDropdown(
                        value: countryOfSaleValue ?? '',
                        items: countryOfSaleList,
                        onChanged: (value) {
                          setState(() {
                            countryOfSaleValue = value;
                          });
                        },
                        hintText: 'Select country of sale',
                      ),
                      10.height,
                      // dropdown for productDesctiptionLanguage
                      const Text(
                        "Product Description Language",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      CustomDropdown(
                        value: productDesctiptionLanguageValue ?? '',
                        items: productDesctiptionLanguageList,
                        onChanged: (value) {
                          setState(() {
                            productDesctiptionLanguageValue = value;
                          });
                        },
                        hintText: 'Select product description language',
                      ),
                      10.height,
                      // dropdown for productType
                      const Text(
                        "Product Type",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      CustomDropdown(
                        value: productTypeValue ?? '',
                        items: productTypeList,
                        onChanged: (value) {
                          setState(() {
                            productTypeValue = value;
                          });
                        },
                        hintText: 'Select product type',
                      ),
                      10.height,
                      // dropdown for packageType
                      const Text(
                        "Package Type",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      CustomDropdown(
                        value: packageTypeValue ?? '',
                        items: packageTypeList,
                        onChanged: (value) {
                          setState(() {
                            packageTypeValue = value;
                          });
                        },
                        hintText: 'Select package type',
                      ),
                      10.height,
                      // dropdown for gpc
                      const Text(
                        "GPC",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      isGpcByMyself
                          ? Container(
                              alignment: Alignment.center,
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(),
                              ),
                              child: TypeAheadField<GPCBySearchModel>(
                                suggestionsCallback: (pattern) async {
                                  return await AddGtinController
                                      .fetchGPCBySearch(pattern);
                                },
                                onSelected: (selectedValue) async {
                                  setState(() {
                                    searchController.text =
                                        selectedValue.value.toString();
                                    isLoading = true;
                                  });

                                  await AddGtinController.fetchHsCode(
                                          selectedValue.value.toString())
                                      .then((value) {
                                    hsCodeList.clear();
                                    setState(() {
                                      hsCodeList = value
                                          .toString()
                                          .replaceFirst("[", "")
                                          .replaceFirst("]", "")
                                          .split(",")
                                          .map((e) => e.toString())
                                          .toList();
                                      hsCodeValue = hsCodeList[0];
                                      hsCodeValue = hsCodeList[0];
                                      isLoading = false;
                                    });
                                  }).onError((error, stackTrace) {
                                    print('Error: $error');
                                    setState(() {
                                      isLoading = false;
                                    });
                                  });
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    title: Text(suggestion.value.toString()),
                                  );
                                },
                                controller: searchController,
                                focusNode: searchFocusNode,
                              ),
                            )
                          : CustomDropdown(
                              value: gpcValue ?? '',
                              items: gpcList,
                              onChanged: (value) async {
                                setState(() {
                                  gpcValue = value;
                                  isLoading = true;
                                });

                                await AddGtinController.fetchHsCode(
                                        value.toString())
                                    .then((value) {
                                  hsCodeList.clear();
                                  setState(() {
                                    hsCodeList = value
                                        .toString()
                                        .replaceFirst("[", "")
                                        .replaceFirst("]", "")
                                        .split(",")
                                        .map((e) => e.toString())
                                        .toList();
                                    hsCodeValue = hsCodeList[0];
                                    isLoading = false;
                                  });
                                }).onError((error, stackTrace) {
                                  print("Error: $error");
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                              },
                              hintText: 'Select GPC',
                            ),
                      // add a checkbox here where we show that "Add GPC by myself"
                      Row(
                        children: [
                          Checkbox(
                            value: isGpcByMyself,
                            onChanged: (value) {
                              setState(() {
                                isGpcByMyself = value!;
                              });
                            },
                          ),
                          const Text(
                            "Add GPC by myself",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      10.height,
                      // dropdown for hsCode
                      const Text(
                        "HS Code",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      CustomDropdown(
                        value: hsCodeValue ?? '',
                        items: hsCodeList,
                        onChanged: (value) {
                          setState(() {
                            hsCodeValue = value;
                          });
                          descriptionControllerEng.text =
                              "${productNameEngController.text} - ${sizeController.text.trim()} - ${value ?? ""} - ${brandsNameEngValue.toString()}";
                          descriptionControllerArb.text =
                              "${productNameArbController.text} - ${sizeController.text.trim()} - ${value ?? ""} - ${brandsNameArbValue.toString()}";
                        },
                        hintText: 'Select HS Code',
                      ),
                      10.height,
                      const Text(
                        "Description [Eng]",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: TextField(
                          controller: descriptionControllerEng,
                          focusNode: descriptionEngNode,
                          onSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(descriptionArbNode);
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(left: 10, top: 5),
                            hintText: 'Enter Description',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      10.height,
                      const Text(
                        "Description [Arabic]",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: TextField(
                          controller: descriptionControllerArb,
                          focusNode: descriptionArbNode,
                          onSubmitted: (value) {
                            FocusScope.of(context).requestFocus(productUrlNode);
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(left: 10, top: 5),
                            hintText: 'Enter Description',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      10.height,
                      const Text(
                        "Product URL",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: TextField(
                          controller: productUrlController,
                          focusNode: productUrlNode,
                          onSubmitted: (value) {},
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(left: 10, top: 5),
                            hintText: 'Enter Product URL',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20), // Replaced .height
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildImagePicker(
                            'Front Photo',
                            _frontImage,
                            () => _pickImage(0),
                            context.width() * 0.4,
                            context.height() * 0.2,
                            context.width() * 0.4,
                            context.height() * 0.05,
                            15,
                            12,
                          ),
                          _buildImagePicker(
                            'Back Photo',
                            _backImage,
                            () => _pickImage(1),
                            context.width() * 0.4,
                            context.height() * 0.2,
                            context.width() * 0.4,
                            context.height() * 0.05,
                            15,
                            12,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10), // Replaced .height
                      Center(
                        child: Wrap(
                          spacing: 10,
                          children: [
                            _buildImagePicker(
                              'Optional\nPhoto 1',
                              _optionalImages[0],
                              () => _pickImage(2, optionalIndex: 0),
                              context.width() * 0.2,
                              context.height() * 0.1,
                              context.width() * 0.27,
                              context.height() * 0.04,
                              10,
                              8,
                            ),
                            _buildImagePicker(
                              'Optional\nPhoto 2',
                              _optionalImages[1],
                              () => _pickImage(2, optionalIndex: 1),
                              context.width() * 0.2,
                              context.height() * 0.1,
                              context.width() * 0.27,
                              context.height() * 0.04,
                              10,
                              8,
                            ),
                            _buildImagePicker(
                              'Optional\nPhoto 3',
                              _optionalImages[2],
                              () => _pickImage(2, optionalIndex: 2),
                              context.width() * 0.2,
                              context.height() * 0.1,
                              context.width() * 0.27,
                              context.height() * 0.04,
                              10,
                              8,
                            ),
                          ],
                        ),
                      ),
                      20.height,
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();

                            if (_frontImage == null && _backImage == null) {
                              toast("Please select front and back image");
                              return;
                            }

                            if (productNameEngController.text.isEmpty ||
                                productNameArbController.text.isEmpty ||
                                sizeController.text.isEmpty) {
                              toast("Please fill the mendatory feilds");
                              return;
                            }

                            setState(() {
                              isLoading = true;
                            });

                            AddGtinController.postProduct(
                              productNameEngController.text.trim(),
                              productNameArbController.text.trim(),
                              brandsNameEngValue,
                              productTypeValue.toString(),
                              originValue.toString(),
                              packageTypeValue.toString(),
                              unitCodeValue.toString(),
                              sizeController.text.trim(),
                              isGpcByMyself
                                  ? searchController.text.trim()
                                  : gpcValue.toString(),
                              isGpcByMyself ? "custom" : "semantic",
                              gpcValue.toString(),
                              countryOfSaleValue.toString(),
                              descriptionControllerEng.text.trim(),
                              hsCodeValue.toString(),
                              descriptionControllerEng.text.trim(),
                              descriptionControllerArb.text.trim(),
                              productUrlController.text.trim(),
                              brandsNameArbValue.toString(),
                              productTypeValue.toString(),
                              _frontImage,
                              _backImage,
                              _optionalImages,
                            ).then((value) {
                              setState(() {
                                productNameEngController.clear();
                                productNameArbController.clear();
                                sizeController.clear();
                                descriptionControllerEng.clear();
                                descriptionControllerArb.clear();
                                productUrlController.clear();
                                _frontImage = null;
                                _backImage = null;
                                _optionalImages[0] = null;
                                _optionalImages[1] = null;
                                _optionalImages[2] = null;
                                isLoading = false;
                              });
                              context.read<GtinCubit>().getGtinData();

                              toast("GtIN Product Added Successfully!");

                              Navigator.of(context).pop();
                            }).onError((error, stackTrace) {
                              toast(error
                                  .toString()
                                  .replaceAll("Exception:", ""));
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          child: state is InsertGtinLoading
                              ? const Center(child: CircularProgressIndicator())
                              : const Text('Add GTIN'),
                        ),
                      ),
                      10.height,
                    ],
                  ),
                ),
              ),
              Visibility(
                  visible: isLoading,
                  child: const Center(child: CircularProgressIndicator()))
            ],
          );
        },
      ),
    );
  }

  File? _frontImage;
  File? _backImage;
  final List<File?> _optionalImages = [null, null, null];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(int imageType, {int? optionalIndex}) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        switch (imageType) {
          case 0:
            _frontImage = File(pickedFile.path);
            break;
          case 1:
            _backImage = File(pickedFile.path);
            break;
          case 2:
            if (optionalIndex != null) {
              _optionalImages[optionalIndex] = File(pickedFile.path);
            }
            break;
        }
      }
    });
  }

  Widget _buildImagePicker(
    String label,
    File? image,
    VoidCallback onTap,
    double width,
    double height,
    double btnWidth,
    double btnHeight,
    double textSize,
    double btnText,
  ) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(8.0),
          width: width,
          height: height,
          color: Colors.grey[200],
          child: image != null
              ? Image.file(image)
              : Center(
                  child: Text(
                  label,
                  style: TextStyle(fontSize: textSize),
                )),
        ),
        SizedBox(
          width: btnWidth,
          height: btnHeight,
          child: ElevatedButton(
            onPressed: onTap,
            child: Text(
              'Select Image',
              style: TextStyle(fontSize: btnText),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final Function(String?) onChanged;
  final String hintText;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: DropdownButtonFormField<String>(
        value: value.isNotEmpty ? value : null,
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        isExpanded: true,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 10, top: 5),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

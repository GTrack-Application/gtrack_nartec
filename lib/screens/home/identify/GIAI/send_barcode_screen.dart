// ignore_for_file: unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/cubit/fats_cubit.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/cubit/fats_state.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/model/brand_model.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/model/category_model.dart';

class SendBarcodeScreen extends StatefulWidget {
  final Map<String, dynamic> assetData;

  const SendBarcodeScreen({
    super.key,
    required this.assetData,
  });

  @override
  State<SendBarcodeScreen> createState() => _SendBarcodeScreenState();
}

class _SendBarcodeScreenState extends State<SendBarcodeScreen> {
  final TextEditingController _modelController = TextEditingController();
  CategoryModel? selectedCategory;
  List<CategoryModel> categories = [];
  BrandModel? selectedBrand;
  List<BrandModel> brands = [];

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  // Focus nodes
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();

  final FatsCubit fatsCubit = FatsCubit();

  final List<AssetItem> assetItems = [];

  @override
  void initState() {
    super.initState();
    fatsCubit.getCategories();
  }

  @override
  void dispose() {
    _modelController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Asset Location Form'),
        backgroundColor: AppColors.skyBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<FatsCubit, FatsState>(
        bloc: fatsCubit,
        listener: (context, state) {
          if (state is FatsCategoryLoaded) {
            setState(() {
              categories = state.categories;
            });
          } else if (state is FatsBrandLoaded) {
            setState(() {
              brands = state.brands;
            });
          } else if (state is FatsCategoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Error loading categories: ${state.message}')),
            );
          } else if (state is FatsBrandError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error loading brands: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   padding: const EdgeInsets.all(16),
                //   decoration: BoxDecoration(
                //     border: Border.all(color: Colors.grey),
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       const Text('Asset Location Information',
                //           style: TextStyle(fontWeight: FontWeight.bold)),
                //       const SizedBox(height: 8),
                //       _buildInfoRow('Country:',
                //           widget.assetData['country']?.nameEn ?? ''),
                //       _buildInfoRow(
                //           'State:', widget.assetData['state']?.name ?? ''),
                //       _buildInfoRow(
                //           'City:', widget.assetData['city']?.name ?? ''),
                //       _buildInfoRow('Area:', widget.assetData['area'] ?? ''),
                //       _buildInfoRow(
                //           'Department:', widget.assetData['department'] ?? ''),
                //       _buildInfoRow('Department Code:',
                //           widget.assetData['departmentCode'] ?? ''),
                //       _buildInfoRow('Business Name:',
                //           widget.assetData['businessName'] ?? ''),
                //       _buildInfoRow('Building Name:',
                //           widget.assetData['buildingName'] ?? ''),
                //       _buildInfoRow('Building Number:',
                //           widget.assetData['buildingNumber'] ?? ''),
                //       _buildInfoRow('Floor Number:',
                //           widget.assetData['floorNumber'] ?? ''),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 16),
                const Text('Category'),
                BlocBuilder<FatsCubit, FatsState>(
                  bloc: fatsCubit,
                  builder: (context, state) {
                    return DropdownButtonFormField<CategoryModel>(
                      dropdownColor: Colors.white,
                      decoration: const InputDecoration(
                        hintText: 'Select Category',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedCategory,
                      items: categories.map((CategoryModel category) {
                        return DropdownMenuItem<CategoryModel>(
                          value: category,
                          child: Text(
                              "${category.mainDescription} - ${category.subCategoryCode}"),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                          selectedBrand = null;
                          // Fetch brands when category is selected
                          if (value != null) {
                            fatsCubit.getBrands(value.id.toString());
                          }
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Text('Search Category'),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Type and search',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Brand'),
                          BlocBuilder<FatsCubit, FatsState>(
                            bloc: fatsCubit,
                            builder: (context, state) {
                              // Clear selected brand when loading new brands
                              if (state is FatsBrandLoading) {
                                selectedBrand = null;
                              }

                              return DropdownButtonFormField<BrandModel>(
                                dropdownColor: Colors.white,
                                decoration: const InputDecoration(
                                  hintText: 'Select Brand',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                value: selectedBrand,
                                items: brands.map((BrandModel brand) {
                                  return DropdownMenuItem<BrandModel>(
                                    value: brand,
                                    child: Text(brand.name ?? ''),
                                  );
                                }).toList(),
                                onChanged: selectedCategory == null
                                    ? null
                                    : (BrandModel? value) {
                                        setState(() {
                                          selectedBrand = value;
                                        });
                                      },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        const Text(''),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.add_box_outlined,
                              color: AppColors.primary,
                            ),
                            onPressed: () {
                              if (selectedCategory == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Please select a category first'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  final TextEditingController brandController =
                                      TextEditingController();
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: const Text('Add Brand'),
                                    content: BlocConsumer<FatsCubit, FatsState>(
                                      bloc: fatsCubit,
                                      listener: (context, state) {
                                        if (state is FatsAddBrandLoaded) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(state.message),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        } else if (state is FatsAddBrandError) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(state.message),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },
                                      builder: (context, state) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('Brand of Assets'),
                                            const SizedBox(height: 8),
                                            TextField(
                                              controller: brandController,
                                              decoration: const InputDecoration(
                                                hintText:
                                                    'Type the asset brand',
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    actions: [
                                      FilledButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: FilledButton.styleFrom(
                                          backgroundColor: Colors.grey,
                                        ),
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      FilledButton(
                                        onPressed: () {
                                          if (brandController.text.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Please enter brand name'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            return;
                                          }

                                          fatsCubit.addBrand(
                                            name: brandController.text,
                                            mainCode: selectedCategory!
                                                    .mainCategoryCode ??
                                                '',
                                            majorCode: selectedCategory!
                                                    .subCategoryCode ??
                                                '',
                                            giaiCategoryId:
                                                selectedCategory!.id.toString(),
                                          );
                                        },
                                        child: const Text(
                                          'Submit & Save',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Model'),
                          TextFormField(
                            controller: _modelController,
                            decoration: const InputDecoration(
                              hintText: 'Type the asset model',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        const Text(''),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_drop_down_circle),
                            onPressed: () {
                              if (_modelController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Please select a brand and enter a model'),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              } else {
                                setState(() {
                                  // Add the new item to the list
                                  assetItems.add(
                                    AssetItem(
                                      type: selectedBrand?.name ?? '',
                                      model: _modelController.text,
                                      qty: 1,
                                      assetClass:
                                          selectedCategory?.mainDescription ??
                                              '',
                                      mCode:
                                          selectedCategory?.mainCategoryCode ??
                                              '',
                                      sCode:
                                          selectedCategory?.subCategoryCode ??
                                              '',
                                      majorDescription:
                                          selectedCategory?.mainDescription ??
                                              '',
                                      minorDescription:
                                          selectedCategory?.subDescription ??
                                              '',
                                      country:
                                          widget.assetData['country']?.nameEn ??
                                              '',
                                      state:
                                          widget.assetData['state']?.name ?? '',
                                      city:
                                          widget.assetData['city']?.name ?? '',
                                      area: widget.assetData['area'] ?? '',
                                      department:
                                          widget.assetData['department'] ?? '',
                                      departmentCode:
                                          widget.assetData['departmentCode'] ??
                                              '',
                                      businessName:
                                          widget.assetData['businessName'] ??
                                              '',
                                      buildingName:
                                          widget.assetData['buildingName'] ??
                                              '',
                                      buildingNumber:
                                          widget.assetData['buildingNumber'] ??
                                              '',
                                      floorNumber:
                                          widget.assetData['floorNumber'] ?? '',
                                    ),
                                  );
                                  // Clear the model input
                                  _modelController.clear();
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Initial Asset Information',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...assetItems
                          .map((item) => Column(
                                children: [
                                  _buildInfoRow('Type :', item.type),
                                  _buildInfoRow('Model :', item.model),
                                  _buildInfoRow('QTY :', item.qty.toString()),
                                  _buildInfoRow(
                                      'Asset Class :', item.assetClass),
                                  _buildInfoRow('M-Code :', item.mCode),
                                  _buildInfoRow('S-Code :', item.sCode),
                                  _buildInfoRow('Major Description :',
                                      item.majorDescription),
                                  _buildInfoRow('Minor Description :',
                                      item.minorDescription),
                                  // _buildInfoRow('Country :', item.country),
                                  // _buildInfoRow('State :', item.state),
                                  // _buildInfoRow('City :', item.city),
                                  // _buildInfoRow('Area :', item.area),
                                  // _buildInfoRow(
                                  //     'Department :', item.department),
                                  // _buildInfoRow(
                                  //     'Department Code :', item.departmentCode),
                                  // _buildInfoRow(
                                  //     'Business Name :', item.businessName),
                                  // _buildInfoRow(
                                  //     'Building Name :', item.buildingName),
                                  // _buildInfoRow(
                                  //     'Building Number :', item.buildingNumber),
                                  // _buildInfoRow(
                                  //     'Floor Number :', item.floorNumber),
                                  const Divider(),
                                ],
                              ))
                          .toList(),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                BlocConsumer<FatsCubit, FatsState>(
                  bloc: fatsCubit,
                  listener: (context, state) {
                    if (state is FatsSendBarcodeLoaded) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Successfully Send for Barcode',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                FilledButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      );

                      // empty the assetItems list
                      assetItems.clear();
                    } else if (state is FatsSendBarcodeError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text(state.message.replaceAll('Exception: ', '')),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.skyBlue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          fatsCubit.sendBarcode(assetItems);
                        },
                        child: state is FatsSendBarcodeLoading
                            ? const Text(
                                'Sending...',
                                style: TextStyle(color: Colors.white),
                              )
                            : const Text(
                                'Send for Barcode',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label),
          const SizedBox(width: 8),
          if (label == 'QTY :') ...[
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                final index = assetItems
                    .indexWhere((item) => item.qty.toString() == value);
                if (index != -1) {
                  updateQuantity(index, false);
                }
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
            Text(value),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                final index = assetItems
                    .indexWhere((item) => item.qty.toString() == value);
                if (index != -1) {
                  updateQuantity(index, true);
                }
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ] else ...[
            Expanded(child: Text(value)),
          ],
          if (label == 'Minor Description :') ...[
            Builder(
              builder: (context) {
                // Find the exact item that matches all properties
                final index = assetItems.indexWhere((item) =>
                    item.minorDescription == value &&
                    item.type ==
                        assetItems[assetItems.indexWhere(
                                (element) => element.minorDescription == value)]
                            .type &&
                    item.model ==
                        assetItems[assetItems.indexWhere(
                                (element) => element.minorDescription == value)]
                            .model);

                return IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    setState(() {
                      assetItems.removeAt(index);
                    });
                  },
                  style: IconButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  void updateQuantity(int index, bool increment) {
    setState(() {
      if (increment) {
        assetItems[index].qty++;
      } else if (assetItems[index].qty > 1) {
        assetItems[index].qty--;
      }
    });
  }
}

class AssetItem {
  final String type;
  final String model;
  int qty;
  final String assetClass;
  final String mCode;
  final String sCode;
  final String majorDescription;
  final String minorDescription;
  final String country;
  final String state;
  final String city;
  final String area;
  final String department;
  final String departmentCode;
  final String businessName;
  final String buildingName;
  final String buildingNumber;
  final String floorNumber;

  AssetItem({
    required this.type,
    required this.model,
    this.qty = 1,
    required this.assetClass,
    required this.mCode,
    required this.sCode,
    required this.majorDescription,
    required this.minorDescription,
    required this.country,
    required this.state,
    required this.city,
    required this.area,
    required this.department,
    required this.departmentCode,
    required this.businessName,
    required this.buildingName,
    required this.buildingNumber,
    required this.floorNumber,
  });
}

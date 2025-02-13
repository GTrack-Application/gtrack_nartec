import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/Identify/sscc/sscc_cubit.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/screens/home/identify/SSCC/sscc_cubit/add_sscc_cubit.dart';
import 'package:gtrack_nartec/screens/home/identify/SSCC/sscc_cubit/add_sscc_state.dart';
import 'package:gtrack_nartec/screens/home/identify/controller/add_gtin_controller.dart';

class AddSsccFormScreen extends StatefulWidget {
  const AddSsccFormScreen({super.key});

  @override
  _AddSsccFormScreenState createState() => _AddSsccFormScreenState();
}

class _AddSsccFormScreenState extends State<AddSsccFormScreen> {
  final List<int> extensionDigits = List<int>.generate(10, (i) => i); // 0 to 9
  final List<String> ssccTypes = ['Pallet', 'Label'];
  int? selectedExtensionDigit;
  String? selectedSsccType;
  List<String> countriesIdList = [];

  // by pallet
  TextEditingController vendorIdController = TextEditingController();
  TextEditingController vendorNameController = TextEditingController();
  TextEditingController productIdController = TextEditingController();
  TextEditingController productDescController = TextEditingController();
  TextEditingController serialNoController = TextEditingController();
  TextEditingController itemCodeController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController useByController = TextEditingController();
  TextEditingController batchNoController = TextEditingController();
  TextEditingController boxOfController = TextEditingController();

  FocusNode vendorIdFocusNode = FocusNode();
  FocusNode vendorNameFocusNode = FocusNode();
  FocusNode productIdFocusNode = FocusNode();
  FocusNode productDescFocusNode = FocusNode();
  FocusNode serialNoFocusNode = FocusNode();
  FocusNode itemCodeFocusNode = FocusNode();
  FocusNode qtyFocusNode = FocusNode();
  FocusNode useByFocusNode = FocusNode();
  FocusNode batchNoFocusNode = FocusNode();
  FocusNode boxOfFocusNode = FocusNode();

  // by label
  TextEditingController hsnSkuNoController = TextEditingController();
  TextEditingController poNoController = TextEditingController();
  TextEditingController expirationDateController = TextEditingController();
  TextEditingController vendorId2Controller = TextEditingController();
  TextEditingController cartonQtyController = TextEditingController();
  TextEditingController shipToController = TextEditingController();
  TextEditingController shipDateController = TextEditingController();
  TextEditingController vendorItemNoController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController shortQtyCodeController = TextEditingController();
  TextEditingController cartonController = TextEditingController();
  String? originValue;
  List<String> originList = [];

  FocusNode hsnSkuNoFocusNode = FocusNode();
  FocusNode poNoFocusNode = FocusNode();
  FocusNode expirationDateFocusNode = FocusNode();
  FocusNode vendorId2FocusNode = FocusNode();
  FocusNode cartonQtyFocusNode = FocusNode();
  FocusNode shipToFocusNode = FocusNode();
  FocusNode shipDateFocusNode = FocusNode();
  FocusNode vendorItemNoFocusNode = FocusNode();
  FocusNode descFocusNode = FocusNode();
  FocusNode shortQtyCodeFocusNode = FocusNode();
  FocusNode cartonFocusNode = FocusNode();
  FocusNode originFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () async {
        var origin = await AddGtinController.fetchOrigin();
        originList = origin.map((e) => e.countryName.toString()).toList();
        originList = originList.toSet().toList();
        countriesIdList = origin.map((e) => e.id.toString()).toList();
        countriesIdList = countriesIdList.toSet().toList();
        setState(() {});
      },
    );
  }

  AddSSCCCubit addSSCCCubit = AddSSCCCubit();

  @override
  void dispose() {
    vendorIdController.dispose();
    vendorNameController.dispose();
    productIdController.dispose();
    productDescController.dispose();
    serialNoController.dispose();
    itemCodeController.dispose();
    qtyController.dispose();
    useByController.dispose();
    batchNoController.dispose();
    boxOfController.dispose();
    hsnSkuNoController.dispose();
    poNoController.dispose();
    expirationDateController.dispose();
    vendorId2Controller.dispose();
    cartonQtyController.dispose();
    shipToController.dispose();
    shipDateController.dispose();
    vendorItemNoController.dispose();
    descController.dispose();
    shortQtyCodeController.dispose();
    cartonController.dispose();

    vendorIdFocusNode.dispose();
    vendorNameFocusNode.dispose();
    productIdFocusNode.dispose();
    productDescFocusNode.dispose();
    serialNoFocusNode.dispose();
    itemCodeFocusNode.dispose();
    qtyFocusNode.dispose();
    useByFocusNode.dispose();
    batchNoFocusNode.dispose();
    boxOfFocusNode.dispose();
    hsnSkuNoFocusNode.dispose();
    poNoFocusNode.dispose();
    expirationDateFocusNode.dispose();
    vendorId2FocusNode.dispose();
    cartonQtyFocusNode.dispose();
    shipToFocusNode.dispose();
    shipDateFocusNode.dispose();
    vendorItemNoFocusNode.dispose();
    descFocusNode.dispose();
    shortQtyCodeFocusNode.dispose();
    cartonFocusNode.dispose();
    originFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = const InputDecoration(
      labelText: '',
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      labelStyle: TextStyle(fontSize: 14),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('SSCC Form'),
        backgroundColor: AppColors.skyBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: inputDecoration.copyWith(
                        labelText: 'Extension Digit',
                      ),
                      value: selectedExtensionDigit,
                      onChanged: (int? newValue) {
                        setState(() {
                          selectedExtensionDigit = newValue;
                        });
                      },
                      items: extensionDigits
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString(),
                              style: const TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: inputDecoration.copyWith(
                        labelText: 'SSCC Type',
                      ),
                      value: selectedSsccType,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSsccType = newValue;
                        });
                      },
                      items: ssccTypes
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child:
                              Text(value, style: const TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              selectedSsccType == 'Pallet'
                  ? Column(
                      children: [
                        TextFormField(
                          controller: vendorIdController,
                          focusNode: vendorIdFocusNode,
                          decoration:
                              inputDecoration.copyWith(labelText: 'Vendor ID'),
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(fontSize: 14),
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(vendorNameFocusNode);
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: vendorNameController,
                          focusNode: vendorNameFocusNode,
                          decoration: inputDecoration.copyWith(
                              labelText: 'Vendor Name'),
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(fontSize: 14),
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(productIdFocusNode);
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: productIdController,
                          focusNode: productIdFocusNode,
                          decoration:
                              inputDecoration.copyWith(labelText: 'Product ID'),
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(fontSize: 14),
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(productDescFocusNode);
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: productDescController,
                          focusNode: productDescFocusNode,
                          decoration: inputDecoration.copyWith(
                              labelText: 'Product Description'),
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(fontSize: 14),
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(serialNoFocusNode);
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: serialNoController,
                          focusNode: serialNoFocusNode,
                          decoration:
                              inputDecoration.copyWith(labelText: 'Serial No'),
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(fontSize: 14),
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(itemCodeFocusNode);
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: itemCodeController,
                          focusNode: itemCodeFocusNode,
                          decoration:
                              inputDecoration.copyWith(labelText: 'Item Code'),
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(fontSize: 14),
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(qtyFocusNode);
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: qtyController,
                          focusNode: qtyFocusNode,
                          decoration:
                              inputDecoration.copyWith(labelText: 'Qty'),
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(fontSize: 14),
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(useByFocusNode);
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: useByController,
                          focusNode: useByFocusNode,
                          decoration: inputDecoration.copyWith(
                            labelText: 'Use By',
                            suffixIcon: IconButton(
                              onPressed: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2025),
                                );
                                if (picked != null) {
                                  useByController.text =
                                      picked.toString().split(' ')[0];
                                }
                              },
                              icon: const Icon(Icons.calendar_today, size: 20),
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(fontSize: 14),
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(batchNoFocusNode);
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: batchNoController,
                          focusNode: batchNoFocusNode,
                          decoration:
                              inputDecoration.copyWith(labelText: 'Batch No'),
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(fontSize: 14),
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(boxOfFocusNode);
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: boxOfController,
                          focusNode: boxOfFocusNode,
                          decoration:
                              inputDecoration.copyWith(labelText: 'Box Of'),
                          textInputAction: TextInputAction.done,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    )
                  : selectedSsccType == 'Label'
                      ? Column(
                          children: [
                            TextFormField(
                              controller: hsnSkuNoController,
                              focusNode: hsnSkuNoFocusNode,
                              decoration: inputDecoration.copyWith(
                                  labelText: 'HSN/SKU No'),
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(fontSize: 14),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(poNoFocusNode);
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: poNoController,
                              focusNode: poNoFocusNode,
                              decoration:
                                  inputDecoration.copyWith(labelText: 'PO No'),
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(fontSize: 14),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(expirationDateFocusNode);
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: expirationDateController,
                              focusNode: expirationDateFocusNode,
                              decoration: inputDecoration.copyWith(
                                labelText: 'Expiration Date',
                                suffixIcon: IconButton(
                                  onPressed: () async {
                                    final DateTime? picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2025),
                                    );
                                    if (picked != null) {
                                      expirationDateController.text =
                                          picked.toString().split(' ')[0];
                                    }
                                  },
                                  icon: const Icon(Icons.calendar_today,
                                      size: 20),
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(fontSize: 14),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(vendorId2FocusNode);
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: vendorId2Controller,
                              focusNode: vendorId2FocusNode,
                              decoration: inputDecoration.copyWith(
                                  labelText: 'Vendor ID'),
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(fontSize: 14),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(cartonQtyFocusNode);
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: cartonQtyController,
                              focusNode: cartonQtyFocusNode,
                              decoration: inputDecoration.copyWith(
                                  labelText: 'Carton Qty'),
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(fontSize: 14),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(shipToFocusNode);
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: shipToController,
                              focusNode: shipToFocusNode,
                              decoration: inputDecoration.copyWith(
                                  labelText: 'Ship To'),
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(fontSize: 14),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(shipDateFocusNode);
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: shipDateController,
                              focusNode: shipDateFocusNode,
                              decoration: inputDecoration.copyWith(
                                labelText: 'Ship Date',
                                suffixIcon: IconButton(
                                  onPressed: () async {
                                    final DateTime? picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2025),
                                    );
                                    if (picked != null) {
                                      shipDateController.text =
                                          picked.toString().split(' ')[0];
                                    }
                                  },
                                  icon: const Icon(Icons.calendar_today,
                                      size: 20),
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(fontSize: 14),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(vendorItemNoFocusNode);
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: vendorItemNoController,
                              focusNode: vendorItemNoFocusNode,
                              decoration: inputDecoration.copyWith(
                                  labelText: 'Vendor Item No'),
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(fontSize: 14),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(descFocusNode);
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: descController,
                              focusNode: descFocusNode,
                              decoration: inputDecoration.copyWith(
                                  labelText: 'Description'),
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(fontSize: 14),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(shortQtyCodeFocusNode);
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: shortQtyCodeController,
                              focusNode: shortQtyCodeFocusNode,
                              decoration: inputDecoration.copyWith(
                                  labelText: 'Short Qty Code'),
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(fontSize: 14),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(cartonFocusNode);
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: cartonController,
                              focusNode: cartonFocusNode,
                              decoration:
                                  inputDecoration.copyWith(labelText: 'Carton'),
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(fontSize: 14),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(originFocusNode);
                              },
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              decoration: inputDecoration.copyWith(
                                labelText: 'Origin',
                              ),
                              focusNode: originFocusNode,
                              value: originValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  originValue = newValue;
                                });
                              },
                              isExpanded: true,
                              items: originList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style: const TextStyle(fontSize: 14)),
                                );
                              }).toList(),
                            ),
                          ],
                        )
                      : Container(),
              const SizedBox(height: 10),
              BlocConsumer<AddSSCCCubit, AddSSCCState>(
                bloc: addSSCCCubit,
                listener: (context, state) {
                  if (state is AddSSCCAddedByPallet) {
                    BlocProvider.of<SsccCubit>(context).getSsccData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("SSCC Added by Pallet Successfully"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  } else if (state is AddSSCCAddedByLabel) {
                    BlocProvider.of<SsccCubit>(context).getSsccData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("SSCC Added by Label Successfully"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  } else if (state is AddSSCCError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      if (selectedSsccType == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select SSCC Type'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (selectedSsccType == 'Pallet') {
                        if (vendorIdController.text.isEmpty ||
                            vendorNameController.text.isEmpty ||
                            productIdController.text.isEmpty ||
                            productDescController.text.isEmpty ||
                            serialNoController.text.isEmpty ||
                            itemCodeController.text.isEmpty ||
                            qtyController.text.isEmpty ||
                            useByController.text.isEmpty ||
                            batchNoController.text.isEmpty ||
                            boxOfController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill all fields'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                      } else if (selectedSsccType == 'Label') {
                        if (hsnSkuNoController.text.isEmpty ||
                            poNoController.text.isEmpty ||
                            expirationDateController.text.isEmpty ||
                            vendorId2Controller.text.isEmpty ||
                            cartonQtyController.text.isEmpty ||
                            shipToController.text.isEmpty ||
                            shipDateController.text.isEmpty ||
                            vendorItemNoController.text.isEmpty ||
                            descController.text.isEmpty ||
                            shortQtyCodeController.text.isEmpty ||
                            cartonController.text.isEmpty ||
                            originValue == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill all fields'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                      }

                      if (selectedSsccType == 'Pallet') {
                        addSSCCCubit.addSSCCByPallet(
                          "pallet",
                          vendorIdController.text.trim(),
                          vendorNameController.text.trim(),
                          productIdController.text.trim(),
                          productDescController.text.trim(),
                          serialNoController.text.trim(),
                          itemCodeController.text.trim(),
                          qtyController.text.trim(),
                          useByController.text.trim(),
                          batchNoController.text.trim(),
                          boxOfController.text.trim(),
                        );
                      } else if (selectedSsccType == 'Label') {
                        addSSCCCubit.addSSCCByLabel(
                          "label",
                          hsnSkuNoController.text.trim(),
                          poNoController.text.trim(),
                          expirationDateController.text.trim(),
                          vendorId2Controller.text.trim(),
                          cartonQtyController.text.trim(),
                          shipToController.text.trim(),
                          shipDateController.text.trim(),
                          vendorItemNoController.text.trim(),
                          descController.text.trim(),
                          shortQtyCodeController.text.trim(),
                          cartonController.text.trim(),
                          countriesIdList[originList.indexOf(originValue!)],
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.skyBlue,
                    ),
                    child: state is AddSSCCLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Submit'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

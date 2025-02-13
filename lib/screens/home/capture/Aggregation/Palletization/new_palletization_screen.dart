// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, avoid_print, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtrack_nartec/constants/app_images.dart';
import 'package:gtrack_nartec/controllers/capture/Aggregation/Palletization/generate_pallet_controller.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_dialogs.dart';
import 'package:gtrack_nartec/global/widgets/ElevatedButtonWidget.dart';
import 'package:gtrack_nartec/global/widgets/appBar/appBar_widget.dart';
import 'package:gtrack_nartec/global/widgets/text/text_widget.dart';
import 'package:gtrack_nartec/global/widgets/text_field/text_form_field_widget.dart';
import 'package:gtrack_nartec/models/capture/aggregation/palletization/GetControlledSerialBySerialNoModel.dart';

class NewPalletizationScreen extends StatefulWidget {
  const NewPalletizationScreen({super.key});

  @override
  State<NewPalletizationScreen> createState() => _NewPalletizationScreenState();
}

class _NewPalletizationScreenState extends State<NewPalletizationScreen> {
  TextEditingController noOfBoxController = TextEditingController();
  TextEditingController qtyPerBoxController = TextEditingController();
  TextEditingController serialNoController = TextEditingController();

  FocusNode noOfBoxFocusNode = FocusNode();
  FocusNode qtyPerBoxFocusNode = FocusNode();
  FocusNode serialNoFocusNode = FocusNode();

  String total = "0";
  List<GetControlledSerialBySerialNoModel> table = [];
  List<bool> isMarked = [];

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  enableButton() {
    double? totalBoxes = double.tryParse(noOfBoxController.text);
    double? qtyPerBox = double.tryParse(qtyPerBoxController.text);

    double multiply = 0;

    if (totalBoxes != null && qtyPerBox != null) {
      multiply = totalBoxes * qtyPerBox;
    }

    if (multiply == table.length && multiply != 0) {
      setState(() {
        isButtonEnabled = true;
      });
    } else {
      setState(() {
        isButtonEnabled = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    noOfBoxController.dispose();
    qtyPerBoxController.dispose();
    serialNoController.dispose();

    noOfBoxFocusNode.dispose();
    qtyPerBoxFocusNode.dispose();
    serialNoFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBarWidget(
          backgroundColor: AppColors.pink,
          autoImplyLeading: true,
          onPressed: () {
            Get.back();
          },
          title: "Palletization".toUpperCase(),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                child: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 10),
                    child: const TextWidget(
                      text: "No. of Box",
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10, right: 20),
                      child: TextFormFieldWidget(
                        controller: noOfBoxController,
                        focusNode: noOfBoxFocusNode,
                        hintText: "Enter No. of Box",
                        readOnly: false,
                        onEditingComplete: () {
                          noOfBoxFocusNode.unfocus();
                          FocusScope.of(context)
                              .requestFocus(qtyPerBoxFocusNode);
                        },
                        onChanged: (value) {
                          enableButton();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 10),
                    child: const TextWidget(
                      text: "Qty Per Box",
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10, right: 20),
                      child: TextFormFieldWidget(
                        controller: qtyPerBoxController,
                        focusNode: qtyPerBoxFocusNode,
                        hintText: "Enter Qty Per Box",
                        onChanged: (value) {
                          enableButton();
                        },
                        readOnly: false,
                        onEditingComplete: () {
                          qtyPerBoxFocusNode.unfocus();
                          FocusScope.of(context)
                              .requestFocus(serialNoFocusNode);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: const TextWidget(
                  text: " Serial No*",
                  fontSize: 16,
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: TextFormFieldWidget(
                        controller: serialNoController,
                        width: MediaQuery.of(context).size.width * 0.73,
                        focusNode: serialNoFocusNode,
                        hintText: "Enter Serial No",
                        onEditingComplete: () {
                          onSearch();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          onSearch();
                        },
                        child: Image.asset(
                          AppImages.finder,
                          width: 45,
                          height: 45,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: PaginatedDataTable(
                  rowsPerPage: 3,
                  columns: const [
                    DataColumn(
                        label: Text(
                      'GTIN',
                      style: TextStyle(color: Colors.black),
                    )),
                    DataColumn(
                        label: Text(
                      'SERIAL NO',
                      style: TextStyle(color: Colors.black),
                    )),
                    DataColumn(
                        label: Text(
                      'EXP DATE',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'BATCH',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'MANUFACTURING DATE',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                  ],
                  source: StudentDataSource(table, context),
                  showCheckboxColumn: false,
                  showFirstLastButtons: true,
                  arrowHeadColor: AppColors.pink,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: ElevatedButtonWidget(
                      title: "Generate Pallet",
                      onPressed: () {
                        onGeneratePallet();
                      },
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 50,
                      fontSize: 15,
                      color: isButtonEnabled ? AppColors.pink : AppColors.grey,
                      textColor: Colors.white,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      const TextWidget(
                        text: "TOTAL",
                        fontSize: 15,
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                            child: TextWidget(text: total),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String grabSerialNumber(String input) {
    // Remove spaces before and after each dash
    input = input.replaceAll(' - ', '-');

    if ('-'.allMatches(input).length >= 5) {
      // Split the string into parts
      List<String> parts = input.split('-');

      // Get the parts from the 5th dash onwards and join them back together
      String result = parts.sublist(4).join('-');
      print("new result $result");
      return result; // Outputs: 5561000957-04062026-173
    } else {
      print('old result $input');
      return input;
    }
  }

  void onSearch() async {
    if (serialNoController.text.isEmpty) {
      FocusScope.of(context).unfocus();
      return;
    }

    if (noOfBoxController.text.isEmpty || qtyPerBoxController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter No of Boxes and QTY per Box"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    AppDialogs.loadingDialog(context);
    // split the controller value and get the value after 5th -
    serialNoController.text = grabSerialNumber(serialNoController.text.trim());

    GeneratePalletController.generatePallet(
      serialNoController.text.trim(),
    ).then((value) {
      bool test =
          table.map((e) => e.serialNo).toList().contains(value[0].serialNo);
      if (test) {
        AppDialogs.closeDialog();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Serial No ${value[0].serialNo} already exists."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        table.add(value[0]);
        total = table.length.toString();
        serialNoController.clear();
      });
      enableButton();

      FocusScope.of(context).requestFocus(serialNoFocusNode);
      AppDialogs.closeDialog();
    }).onError((error, stackTrace) {
      AppDialogs.closeDialog();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceAll("Exception:", "")),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void onGeneratePallet() {
    if (isButtonEnabled) {
      AppDialogs.loadingDialog(context);
      GeneratePalletController.insertPallet(
        table[0].gTIN ?? "",
        int.tryParse(noOfBoxController.text.trim()) ?? 0,
        int.tryParse(qtyPerBoxController.text.trim()) ?? 0,
        table.map((e) => e.serialNo ?? "").toList(),
      ).then((value) {
        setState(() {
          noOfBoxController.clear();
          qtyPerBoxController.clear();
          serialNoController.clear();
          table.clear();
          total = "0";
        });
        AppDialogs.closeDialog();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("SSCC Generated and Details Saved Successfully."),
            backgroundColor: Colors.green,
          ),
        );
      }).onError((error, stackTrace) {
        AppDialogs.closeDialog();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceAll("Exception:", "")),
            backgroundColor: Colors.red,
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Please scan the serial values equal to the total No of items in the boxes"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class StudentDataSource extends DataTableSource {
  List<GetControlledSerialBySerialNoModel> table;
  BuildContext ctx;

  StudentDataSource(
    this.table,
    this.ctx,
  );

  @override
  DataRow? getRow(int index) {
    if (index >= table.length) {
      return null;
    }

    final tble = table[index];

    return DataRow.byIndex(
      index: index,
      onSelectChanged: (value) {},
      cells: [
        DataCell(SelectableText(tble.gTIN ?? "")),
        DataCell(SelectableText(tble.serialNo ?? "")),
        DataCell(SelectableText(tble.eXPIRYDATE ?? "")),
        DataCell(SelectableText(tble.bATCH ?? "")),
        DataCell(SelectableText(tble.mANUFACTURINGDATE ?? "")),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => table.length;

  @override
  int get selectedRowCount => 0;
}

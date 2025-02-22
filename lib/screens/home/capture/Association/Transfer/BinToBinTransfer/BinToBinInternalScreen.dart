// ignore_for_file: avoid_print, sized_box_for_whitespace, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtrack_nartec/constants/app_images.dart';
import 'package:gtrack_nartec/controllers/capture/Association/Transfer/BinToBinInternalTransfer/BinToBinInternalTableDataController.dart';
import 'package:gtrack_nartec/controllers/capture/Association/Transfer/BinToBinInternalTransfer/GetAllDistinctItemCodesFromTblMappedBarcodesController.dart';
import 'package:gtrack_nartec/controllers/capture/Association/Transfer/BinToBinInternalTransfer/NewOne.dart';
import 'package:gtrack_nartec/controllers/capture/Association/Transfer/BinToBinInternalTransfer/updateByPalletController.dart';
import 'package:gtrack_nartec/controllers/capture/Association/Transfer/BinToBinInternalTransfer/updateBySerialController.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_dialogs.dart';
import 'package:gtrack_nartec/global/widgets/ElevatedButtonWidget.dart';
import 'package:gtrack_nartec/global/widgets/appBar/appBar_widget.dart';
import 'package:gtrack_nartec/global/widgets/text/text_widget.dart';
import 'package:gtrack_nartec/global/widgets/text_field/text_form_field_widget.dart';
import 'package:gtrack_nartec/models/capture/Association/Mapping/Sales_Order/getMappedBarcodedsByItemCodeAndBinLocationModel.dart';
import 'package:gtrack_nartec/models/reveiving/supplier_receipt/BinToBinInternalModel.dart';

class BinToBinInternalScreen extends StatefulWidget {
  const BinToBinInternalScreen({super.key});

  @override
  State<BinToBinInternalScreen> createState() => _BinToBinInternalScreenState();
}

class _BinToBinInternalScreenState extends State<BinToBinInternalScreen> {
  final TextEditingController _palletIdController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _locationFromController = TextEditingController();
  final TextEditingController _locationToController = TextEditingController();

  String total = "0";
  String total2 = "0";
  List<getMappedBarcodedsByItemCodeAndBinLocationModel> table = [];
  List<BinToBinInternalModel> table2 = [];
  List<bool> isMarked = [];

  List<getMappedBarcodedsByItemCodeAndBinLocationModel> filterTable = [];

  String _site = "By Serial";

  final TextEditingController _searchController2 = TextEditingController();
  String? dropDownValue2;
  List<String> dropDownList2 = [];
  List<String> filterList2 = [];

  // ScrollController
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      AppDialogs.showLoadingDialog(context);
      GetAllDistinctItemCodesFromTblMappedBarcodesController.getAllTable()
          .then((value) {
        print("Retrieved values: $value");

        if (value.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No item codes found"),
              backgroundColor: Colors.orange,
            ),
          );
          Navigator.of(context).pop();
          return;
        }

        setState(() {
          dropDownList2 = value.toSet().toList();
          dropDownValue2 = dropDownList2[0];
          filterList2 = dropDownList2;
        });

        Navigator.of(context).pop();
      }).onError((error, stackTrace) {
        print("Error loading item codes: $error");
        print("Stacktrace: $stackTrace");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error loading item codes: ${error.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop();
      });
    });
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
          title: "Bin To Bin Transfer".toUpperCase(),
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: const TextWidget(
                  text: "Item Code*",
                  fontSize: 13,
                ),
              ),
              Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                    width: MediaQuery.of(context).size.width * 0.70,
                    margin: const EdgeInsets.only(left: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: DropdownButton(
                        value: dropDownValue2,
                        underline: Container(),
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 30,
                        iconEnabledColor: Colors.black,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        items: dropDownList2
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            dropDownValue2 = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * 0.15,
                    margin: const EdgeInsets.only(left: 10),
                    child: IconButton(
                      onPressed: () {
                        // show dialog box for search
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: TextWidget(
                                text: "Search",
                                color: Colors.blue[900]!,
                                fontSize: 15,
                              ),
                              content: TextFormFieldWidget(
                                controller: _searchController2,
                                readOnly: false,
                                hintText: "Enter/Scan Item Code",
                                width: MediaQuery.of(context).size.width * 0.9,
                                onEditingComplete: () {
                                  setState(() {
                                    filterList2 = dropDownList2
                                        .where((element) => element
                                            .toLowerCase()
                                            .contains(_searchController2.text
                                                .toLowerCase()))
                                        .toList();
                                    dropDownValue2 = dropDownList2[0];
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: TextWidget(
                                    text: "Cancel",
                                    color: Colors.blue[900]!,
                                    fontSize: 15,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // filter list based on search
                                    setState(() {
                                      filterList2 = dropDownList2
                                          .where((element) => element
                                              .toLowerCase()
                                              .contains(_searchController2.text
                                                  .toLowerCase()))
                                          .toList();
                                      dropDownValue2 = filterList2[0];
                                    });

                                    Navigator.pop(context);
                                  },
                                  child: TextWidget(
                                    text: "Search",
                                    color: Colors.blue[900]!,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Container(
                margin: const EdgeInsets.only(left: 20),
                child: const TextWidget(
                  text: "Scan Bin (FROM)*",
                  fontSize: 13,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: TextFormFieldWidget(
                  controller: _locationFromController,
                  hintText: "Enter/Scan Bin Location From",
                  width: MediaQuery.of(context).size.width * 0.9,
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),

              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(left: 20),
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                child: ElevatedButtonWidget(
                  color: AppColors.pink.withOpacity(0.2),
                  textColor: AppColors.pink,
                  title: "Search",
                  onPressed: () {
                    if (dropDownList2.isEmpty ||
                        _locationFromController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text("Please select Item Code and Bin Location"),
                          backgroundColor: Colors.red,
                        ),
                      );

                      return;
                    }
                    onSearch();
                  },
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
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
                      'Item Code',
                      style: TextStyle(color: Colors.black),
                    )),
                    DataColumn(
                        label: Text(
                      'Item Desc',
                      style: TextStyle(color: Colors.black),
                    )),
                    DataColumn(
                        label: Text(
                      'GTIN',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'Remarks',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'User',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'Classification',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'Main Location',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'Bin Location',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'Int Code',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'Item Serial No.',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'Map Date',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'Pallet Code',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'Reference',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'SID',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'CID',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'PO',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'Trans',
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
              const SizedBox(height: 10),
              Container(
                color: AppColors.pink.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Flexible(
                      child: ListTile(
                        title: const Text(
                          'By Pallet',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: Radio(
                          value: "By Pallet",
                          groupValue: _site,
                          onChanged: (String? value) {
                            setState(() {
                              _site = value!;
                              print(_site);
                            });
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      child: ListTile(
                        title: const Text(
                          'By Serial',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: Radio(
                          value: "By Serial",
                          groupValue: _site,
                          onChanged: (String? value) {
                            setState(() {
                              _site = value!;
                              print(_site);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: TextWidget(
                  text: _site == "By Pallet" ? "Pallet ID" : "Serial No.",
                  fontSize: 13,
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
                        controller: _site == "By Pallet"
                            ? _palletIdController
                            : _serialNumberController,
                        hintText: _site == "By Pallet"
                            ? "Enter/Scan Pallet ID"
                            : "Enter/Scan Serial No.",
                        width: MediaQuery.of(context).size.width * 0.73,
                        onEditingComplete: () {
                          filterMethod();
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
                          FocusScope.of(context).unfocus();
                          AppDialogs.loadingDialog(context);
                          filterMethod().then((value) {
                            AppDialogs.closeDialog();
                          }).onError((error, stackTrace) {
                            AppDialogs.closeDialog();
                          });
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
              // Container(
              //     margin: const EdgeInsets.only(left: 10, top: 10),
              //     child: const TextWidget(text: "List of items on Pallets*")),
              const SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      showCheckboxColumn: false,
                      dataRowColor: WidgetStateColor.resolveWith(
                          (states) => Colors.grey.withOpacity(0.2)),
                      headingRowColor: WidgetStateColor.resolveWith(
                          (states) => AppColors.pink),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      border: TableBorder.all(
                        color: Colors.white,
                        width: 1,
                      ),
                      columns: const [
                        DataColumn(
                            label: Text(
                          'ID',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Item Code',
                          style: TextStyle(color: Colors.white),
                        )),
                        DataColumn(
                            label: Text(
                          'Item Desc',
                          style: TextStyle(color: Colors.white),
                        )),
                        DataColumn(
                            label: Text(
                          'GTIN',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Remarks',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'User',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Classification',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Main Location',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Bin Location',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Int Code',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Item Serial No.',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Map Date',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Pallet Code',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Reference',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'SID',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'CID',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'PO',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'Trans',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                      ],
                      rows: filterTable.map((e) {
                        return DataRow(onSelectChanged: (value) {}, cells: [
                          DataCell(
                              Text((filterTable.indexOf(e) + 1).toString())),
                          DataCell(Text(e.itemCode.toString())),
                          DataCell(Text(e.itemDesc ?? "")),
                          DataCell(Text(e.gTIN ?? "")),
                          DataCell(Text(e.remarks ?? "")),
                          DataCell(Text(e.user ?? "")),
                          DataCell(Text(e.classification ?? "")),
                          DataCell(Text(e.mainLocation ?? "")),
                          DataCell(Text(e.binLocation ?? "")),
                          DataCell(Text(e.intCode ?? "")),
                          DataCell(Text(e.itemSerialNo ?? "")),
                          DataCell(Text(e.mapDate ?? "")),
                          DataCell(Text(e.palletCode ?? "")),
                          DataCell(Text(e.reference ?? "")),
                          DataCell(Text(e.sID ?? "")),
                          DataCell(Text(e.cID ?? "")),
                          DataCell(Text(e.pO ?? "")),
                          DataCell(Text(e.trans.toString() == "null"
                              ? "0"
                              : e.trans.toString())),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: TextWidget(
                  text: "Scan Location To:",
                  color: Colors.blue[900]!,
                  fontSize: 15,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: TextFormFieldWidget(
                  controller: _locationToController,
                  hintText: "Enter/Scan Bin Location To",
                  width: MediaQuery.of(context).size.width * 0.9,
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: ElevatedButtonWidget(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 50,
                      title: "Save",
                      textColor: Colors.white,
                      color: AppColors.pink,
                      onPressed: () {
                        // List<String> binLocationList = [];
                        // for (int i = 0; i < filterTable.length; i++) {
                        //   binLocationList
                        //       .add(filterTable[i].binLocation.toString());
                        // }

                        // List<String> serialNoList = [];
                        // for (int i = 0; i < filterTable.length; i++) {
                        //   serialNoList
                        //       .add(filterTable[i].itemSerialNo.toString());
                        // }

                        // setState(() {});

                        FocusScope.of(context).requestFocus(FocusNode());
                        AppDialogs.loadingDialog(context);

                        if (_site == "By Pallet") {
                          updateByPalletController
                              .updateBin(
                            filterTable,
                            _locationToController.text.toString().trim(),
                          )
                              .then((value) {
                            setState(() {
                              filterTable.clear();
                              table.clear();
                              _palletIdController.clear();
                              total2 = "0";

                              _scrollController.animateTo(
                                0.0,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 300),
                              );
                            });
                            AppDialogs.closeDialog();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Updated Successfully."),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }).onError((error, stackTrace) {
                            AppDialogs.closeDialog();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error
                                    .toString()
                                    .replaceAll("Exception:", "")),
                                backgroundColor: Colors.red,
                              ),
                            );
                          });
                          return;
                        }
                        if (_site == "By Serial") {
                          updateBySerialController
                              .updateBin(
                            filterTable,
                            _locationToController.text.toString().trim(),
                          )
                              .then((value) {
                            setState(() {
                              table.clear();
                              filterTable.clear();

                              _serialNumberController.clear();

                              total2 = "0";

                              // scroll the page up to the top automatically
                              _scrollController.animateTo(
                                0.0,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 300),
                              );
                            });
                            AppDialogs.closeDialog();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Updated Successfully."),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }).onError(
                            (error, stackTrace) {
                              AppDialogs.closeDialog();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(error
                                      .toString()
                                      .replaceAll("Exception:", "")),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                          );
                          return;
                        }
                      },
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(
                          child: TextWidget(text: "Total: "),
                        ),
                        Center(
                          child: TextWidget(text: total2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Future searchMethod() async {
    AppDialogs.loadingDialog(context);
    BinToBinInternalTableDataController.getAllTable(
            _locationToController.text.trim().toString())
        .then((value) {
      setState(() {
        table = value;
        isMarked = List<bool>.filled(
          table.length,
          false,
        );
        total = table.length.toString();

        _serialNumberController.clear();
        _palletIdController.clear();

        FocusScope.of(context).requestFocus(FocusNode());
      });
      AppDialogs.closeDialog();
    }).onError(
      (error, stackTrace) {
        AppDialogs.closeDialog();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceAll("Exception:", "")),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }

  Future filterMethod() async {
    if (_site == "By Pallet") {
      // if pallet id is empty
      if (_palletIdController.text.toString().trim().isEmpty) {
        FocusScope.of(context).requestFocus(FocusNode());
      }

      // if pallet code is already exists on filterTable then show an error message
      if (filterTable
          .map((e) => e.palletCode.toString())
          .toList()
          .contains(_palletIdController.text.trim())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Pallet ID already exists on the table."),
            backgroundColor: Colors.red,
          ),
        );
        FocusScope.of(context).requestFocus(FocusNode());

        return;
      }

      // if pallet id is not contain in the list
      if (!table
          .map((e) => e.palletCode.toString())
          .toList()
          .contains(_palletIdController.text.trim())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Pallet ID not found"),
            backgroundColor: Colors.red,
          ),
        );
        FocusScope.of(context).requestFocus(FocusNode());

        return;
      }

      setState(() {
        // add data in filter table which contains the same pallet id
        for (var data in table) {
          if (data.palletCode.toString().trim() ==
              _palletIdController.text.toString().trim()) {
            filterTable.add(data);
          }
        }

        total2 = filterTable.length.toString();
        _palletIdController.clear();
        FocusScope.of(context).requestFocus(FocusNode());
      });

      return;
    }
    if (_site == "By Serial") {
      // if serial number is empty
      if (_serialNumberController.text.toString().trim().isEmpty) {
        FocusScope.of(context).requestFocus(FocusNode());
      }

      // if serial no is already exists on filterTable then show an error message
      if (filterTable
          .map((e) => e.itemSerialNo.toString())
          .toList()
          .contains(_serialNumberController.text.trim())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Serial No. already exists on table."),
            backgroundColor: Colors.red,
          ),
        );
        FocusScope.of(context).requestFocus(FocusNode());

        return;
      }

      // if serial no is not contain in the list
      if (!table
          .map((e) => e.itemSerialNo.toString())
          .toList()
          .contains(_serialNumberController.text.trim())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Serial No. not found."),
            backgroundColor: Colors.red,
          ),
        );
        FocusScope.of(context).requestFocus(FocusNode());

        return;
      }

      setState(() {
        // add data in filter table which contains the same serial no
        for (var data in table) {
          if (data.itemSerialNo.toString().trim() ==
              _serialNumberController.text.toString().trim()) {
            filterTable.add(data);
          }
        }

        _serialNumberController.clear();

        total2 = filterTable.length.toString();
        FocusScope.of(context).requestFocus(FocusNode());
      });

      return;
    }
  }

  void onSearch() async {
    FocusScope.of(context).requestFocus(FocusNode());
    AppDialogs.loadingDialog(context);
    NewOne.getData(
      dropDownValue2.toString().trim(),
      _locationFromController.text.toString().trim(),
    ).then((value) {
      setState(() {
        // filterList2 = value.map((e) => e.itemCode.toString()).toSet().toList();
        // filterList2.removeWhere((element) => element == "");

        // filterList3 =
        //     value.map((e) => e.binLocation.toString()).toSet().toList();
        // filterList3.removeWhere((element) => element == "");

        table = value;

        isMarked = List<bool>.filled(
          table.length,
          false,
        );

        total = table.length.toString();
      });
      AppDialogs.closeDialog();
    }).onError((error, stackTrace) {
      setState(() {
        table = [];
        total = "0";
      });

      AppDialogs.closeDialog();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceAll("Exception:", "")),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}

class StudentDataSource extends DataTableSource {
  List<getMappedBarcodedsByItemCodeAndBinLocationModel> e;
  BuildContext ctx;

  StudentDataSource(
    this.e,
    this.ctx,
  );

  @override
  DataRow? getRow(int index) {
    if (index >= e.length) {
      return null;
    }

    final student = e[index];

    return DataRow.byIndex(
      index: index,
      onSelectChanged: (value) {},
      cells: [
        DataCell(SelectableText(student.itemCode ?? "")),
        DataCell(SelectableText(student.itemDesc ?? "")),
        DataCell(SelectableText(student.gTIN ?? "")),
        DataCell(SelectableText(student.remarks ?? "")),
        DataCell(SelectableText(student.user ?? "")),
        DataCell(SelectableText(student.classification ?? "")),
        DataCell(SelectableText(student.mainLocation ?? "")),
        DataCell(SelectableText(student.binLocation ?? "")),
        DataCell(SelectableText(student.intCode ?? "")),
        DataCell(SelectableText(student.itemSerialNo ?? "")),
        DataCell(SelectableText(student.mapDate ?? "")),
        DataCell(SelectableText(student.palletCode ?? "")),
        DataCell(SelectableText(student.reference ?? "")),
        DataCell(SelectableText(student.sID ?? "")),
        DataCell(SelectableText(student.cID ?? "")),
        DataCell(SelectableText(student.pO ?? "")),
        DataCell(
          SelectableText(
            student.trans.toString() == "null" ? "0" : student.trans.toString(),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => e.length;

  @override
  int get selectedRowCount => 0;
}

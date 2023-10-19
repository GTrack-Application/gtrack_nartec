// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/controllers/capture/Aggregation/Palletization/getmapBarcodeDataByItemCodeController.dart';
import 'package:gtrack_mobile_app/controllers/capture/Association/Shipping/Sales_Order/GetAllTblDZonesController.dart';
import 'package:gtrack_mobile_app/controllers/capture/Association/Shipping/Sales_Order/GetFirstTableData.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_dialogs.dart';
import 'package:gtrack_mobile_app/global/widgets/ElevatedButtonWidget.dart';
import 'package:gtrack_mobile_app/global/widgets/text/text_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text_field/text_form_field_widget.dart';
import 'package:gtrack_mobile_app/models/capture/Association/Mapping/Sales_Order/getMappedBarcodedsByItemCodeAndBinLocationModel.dart';

// ignore: must_be_immutable
class RawMaterialsToWIPScreen2 extends StatefulWidget {
  num id;
  num poDetailId;
  num poHeaderId;
  num assignToUserId;
  num vendorId;
  String purchaseOrder;
  num memberId;
  String createDate;
  num supplierId;
  String productName;
  num quantity;
  num price;
  num priceSubtotal;
  num priceTotal;
  String dateOrder;
  String state;
  String partnerName;
  String binLocation;

  RawMaterialsToWIPScreen2({
    Key? key,
    required this.id,
    required this.poDetailId,
    required this.poHeaderId,
    required this.assignToUserId,
    required this.vendorId,
    required this.purchaseOrder,
    required this.memberId,
    required this.createDate,
    required this.supplierId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.priceSubtotal,
    required this.priceTotal,
    required this.dateOrder,
    required this.state,
    required this.partnerName,
    required this.binLocation,
  }) : super(key: key);

  @override
  State<RawMaterialsToWIPScreen2> createState() =>
      _RawMaterialsToWIPScreen2State();
}

class _RawMaterialsToWIPScreen2State extends State<RawMaterialsToWIPScreen2> {
  final TextEditingController LocationToController = TextEditingController();

  String result = "0";
  String result2 = "0";
  List<String> serialNoList = [];
  List<bool> isMarked = [];

  List<getMappedBarcodedsByItemCodeAndBinLocationModel> table1 = [];

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1)).then((value) {
      AppDialogs.loadingDialog(context);
      GetMapBarcodeDataByItemCodeController.getData().then((value) {
        for (int i = 0; i < value.length; i++) {
          setState(() {
            dropDownList.add(value[i].bIN ?? "");
            Set<String> set = dropDownList.toSet();
            dropDownList = set.toList();
          });
        }

        setState(() {
          dropDownValue = dropDownList[0];
          filterList = dropDownList;
        });
      });

      GetFirstTableData.getData(
        widget.productName,
        widget.binLocation,
      ).then((value) {
        setState(() {
          table1 = value;
          result = table1.length.toString();
        });
        AppDialogs.closeDialog();
      }).onError((error, stackTrace) {
        setState(() {
          table1 = [];
          result = "0";
        });
      });

      GetAllTblDZonesController.getData().then((value2) {
        for (int i = 0; i < value2.length; i++) {
          setState(() {
            dropDownList2.add(value2[i].dZONE ?? "");
            Set<String> set = dropDownList2.toSet();
            dropDownList2 = set.toList();
          });
        }

        setState(() {
          dropDownValue2 = dropDownList2[0];
          filterList2 = dropDownList2;
        });
        AppDialogs.closeDialog();
      }).onError((error, stackTrace) {
        AppDialogs.closeDialog();
        setState(() {
          dropDownValue2 = "";
          filterList2 = [];
        });
      });
    }).onError((error, stackTrace) {
      AppDialogs.closeDialog();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceAll("Exception:", ""),
          ),
        ),
      );
    });
  }

  final TextEditingController _searchController2 = TextEditingController();
  String? dropDownValue2;
  List<String> dropDownList2 = [];
  List<String> filterList2 = [];

  final TextEditingController _searchController = TextEditingController();
  String? dropDownValue;
  List<String> dropDownList = [];
  List<String> filterList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                  bottom: 10,
                  top: 10,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.pink,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                "Picklist ID",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                widget.supplierId.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Job Order No.",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.state,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "User ID",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.quantity.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: const TextWidget(
                  text: "Scan Bin (FROM)*",
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                    width: MediaQuery.of(context).size.width * 0.73,
                    margin: const EdgeInsets.only(left: 20),
                    child: DropdownSearch<String>(
                      filterFn: (item, filter) {
                        return item
                            .toLowerCase()
                            .contains(filter.toLowerCase());
                      },
                      enabled: true,
                      dropdownButtonProps: const DropdownButtonProps(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                      ),
                      items: filterList,
                      onChanged: (value) {
                        setState(() {
                          dropDownValue = value!;
                        });
                      },
                      selectedItem: dropDownValue,
                    ),
                  ),
                  Container(
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
                                controller: _searchController,
                                readOnly: false,
                                hintText: "Enter/Scan Location",
                                width: MediaQuery.of(context).size.width * 0.9,
                                onEditingComplete: () {
                                  setState(() {
                                    dropDownList = dropDownList
                                        .where((element) => element
                                            .toLowerCase()
                                            .contains(_searchController.text
                                                .toLowerCase()))
                                        .toList();
                                    dropDownValue = dropDownList[0];
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
                                      filterList = dropDownList
                                          .where((element) => element
                                              .toLowerCase()
                                              .contains(_searchController.text
                                                  .toLowerCase()))
                                          .toList();
                                      dropDownValue = filterList[0];
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
              Container(
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: TextWidget(
                  text: "Scan Bin Location:",
                  color: Colors.blue[900]!,
                  fontSize: 15,
                ),
              ),
              Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                    width: MediaQuery.of(context).size.width * 0.73,
                    margin: const EdgeInsets.only(left: 20),
                    child: DropdownSearch<String>(
                      filterFn: (item, filter) {
                        return item
                            .toLowerCase()
                            .contains(filter.toLowerCase());
                      },
                      enabled: true,
                      dropdownButtonProps: const DropdownButtonProps(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                      ),
                      items: filterList2,
                      onChanged: (value) {
                        setState(() {
                          dropDownValue2 = value!;
                        });
                      },
                      selectedItem: dropDownValue2,
                    ),
                  ),
                  Container(
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
                                hintText: "Enter/Scan Location",
                                width: MediaQuery.of(context).size.width * 0.9,
                                onEditingComplete: () {
                                  setState(() {
                                    dropDownList2 = dropDownList2
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
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
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
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Pallet Code',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Reference',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'S-ID',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'C-ID',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'PO',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Trans',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  source: StudentDataSource(table1, context),
                  showCheckboxColumn: false,
                  showFirstLastButtons: true,
                  arrowHeadColor: AppColors.pink,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: TextWidget(
                  text: "Scan Location To*",
                  color: Colors.blue[900]!,
                  fontSize: 15,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: TextFormFieldWidget(
                  controller: LocationToController,
                  readOnly: false,
                  hintText: "Enter/Scan Location To",
                  width: MediaQuery.of(context).size.width * 0.9,
                  onEditingComplete: () {},
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButtonWidget(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.9,
                  title: "Complete",
                  onPressed: () {},
                  textColor: Colors.white,
                  color: AppColors.pink,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentDataSource extends DataTableSource {
  List<getMappedBarcodedsByItemCodeAndBinLocationModel> students;
  BuildContext ctx;

  StudentDataSource(
    this.students,
    this.ctx,
  );

  @override
  DataRow? getRow(int index) {
    if (index >= students.length) {
      return null;
    }

    final student = students[index];

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
        DataCell(Row(
          children: [
            SelectableText(student.itemSerialNo ?? ""),
            IconButton(
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(text: student.itemSerialNo ?? ""),
                );
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(
                    content: Text("Copied to Clipboard"),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              icon: const Icon(
                Icons.copy,
                size: 15,
                color: Colors.blue,
              ),
            ),
          ],
        )),
        DataCell(SelectableText(student.mapDate ?? "")),
        DataCell(SelectableText(student.palletCode ?? "")),
        DataCell(SelectableText(student.reference ?? "")),
        DataCell(SelectableText(student.sID ?? "")),
        DataCell(SelectableText(student.cID ?? "")),
        DataCell(SelectableText(student.pO ?? "")),
        DataCell(SelectableText(student.trans.toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => students.length;

  @override
  int get selectedRowCount => 0;
}

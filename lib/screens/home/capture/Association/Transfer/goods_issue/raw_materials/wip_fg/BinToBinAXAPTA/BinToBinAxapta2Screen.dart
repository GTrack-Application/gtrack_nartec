// ignore_for_file: must_be_immutable, non_constant_identifier_names, avoid_print

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gtrack_nartec/controllers/capture/Aggregation/Palletization/getmapBarcodeDataByItemCodeController.dart';
import 'package:gtrack_nartec/controllers/capture/Association/Shipping/Warehouse_Transfer/BinToBinFromAXAPTA/getPalletTableController.dart';
import 'package:gtrack_nartec/controllers/capture/Association/Shipping/Warehouse_Transfer/BinToBinFromAXAPTA/getSerialTableController.dart';
import 'package:gtrack_nartec/controllers/capture/Association/Shipping/Warehouse_Transfer/BinToBinFromAXAPTA/insertAllDataController.dart';
import 'package:gtrack_nartec/controllers/capture/Association/Transfer/RawMaterialsToWIP/GetSalesPickingListCLRMByAssignToUserAndVendorController.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_dialogs.dart';
import 'package:gtrack_nartec/global/widgets/ElevatedButtonWidget.dart';
import 'package:gtrack_nartec/global/widgets/text/text_widget.dart';
import 'package:gtrack_nartec/global/widgets/text_field/text_form_field_widget.dart';
import 'package:gtrack_nartec/models/capture/mapping_barcode/GetShipmentReceivedTableModel.dart';

class WIPtoFGBinToBinAxapta2Screen extends StatefulWidget {
  String TRANSFERID;
  int TRANSFERSTATUS;
  String INVENTLOCATIONIDFROM;
  String INVENTLOCATIONIDTO;
  String ITEMID;
  int QTYTRANSFER;
  int QTYRECEIVED;
  String CREATEDDATETIME;
  String GROUPID;

  WIPtoFGBinToBinAxapta2Screen({
    super.key,
    required this.TRANSFERID,
    required this.TRANSFERSTATUS,
    required this.INVENTLOCATIONIDFROM,
    required this.INVENTLOCATIONIDTO,
    required this.ITEMID,
    required this.QTYTRANSFER,
    required this.QTYRECEIVED,
    required this.CREATEDDATETIME,
    required this.GROUPID,
  });

  @override
  State<WIPtoFGBinToBinAxapta2Screen> createState() =>
      _WIPtoFGBinToBinAxapta2ScreenState();
}

class _WIPtoFGBinToBinAxapta2ScreenState
    extends State<WIPtoFGBinToBinAxapta2Screen> {
  final TextEditingController _transferIdController = TextEditingController();
  final TextEditingController _locationReferenceController =
      TextEditingController();
  final TextEditingController _scanSerialandPalletController =
      TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  String result = "0";
  List<String> serialNoList = [];

  List<GetShipmentReceivedTableModel> table = [];

  @override
  void initState() {
    super.initState();
    _transferIdController.text = widget.TRANSFERID;

    Future.delayed(const Duration(seconds: 1)).then((value) {
      AppDialogs.loadingDialog(context);
      GetMapBarcodeDataByItemCodeController.getData().then((value) {
        AppDialogs.closeDialog();
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
      }).onError((error, stackTrace) {
        AppDialogs.closeDialog();
        setState(() {
          _locationReferenceController.text = "Location Reference";
        });
      });
    });
  }

  String _site = "By Serial";

  String? dropDownValue;
  List<String> dropDownList = [];
  List<String> filterList = [];

  // make focus node
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(bottom: 20),
              decoration: const BoxDecoration(
                color: AppColors.pink,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 20, top: 10),
                      child: const TextWidget(
                        text: "Transfer ID#",
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: TextFormFieldWidget(
                        controller: _transferIdController,
                        readOnly: true,
                        hintText: "Transfer ID Number",
                        width: MediaQuery.of(context).size.width * 0.9,
                        onEditingComplete: () {},
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 10),
                        const TextWidget(
                          text: "From:",
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.INVENTLOCATIONIDFROM,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 10),
                        const Text(
                          "Item Code:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.ITEMID,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text(
                              "Qty Received",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.QTYRECEIVED.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              "Qty Transfer",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.QTYTRANSFER.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              "Group ID",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.GROUPID.toString(),
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
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Flexible(
                            child: ListTile(
                              title: Text(
                                'By Pallet',
                                style: TextStyle(
                                  color: Colors.blue[900],
                                  fontSize: 13,
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
                              title: Text(
                                'By Serial',
                                style: TextStyle(
                                  color: Colors.blue[900]!,
                                  fontSize: 13,
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
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, top: 10),
              child: TextWidget(
                text: _site == 'By Pallet' ? "Scan Pallet#" : "Scan Serial#",
                color: Colors.blue[900]!,
                fontSize: 15,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: TextFormFieldWidget(
                controller: _scanSerialandPalletController,
                readOnly: false,
                focusNode: focusNode,
                hintText: "Enter/Scan Pallet No",
                width: MediaQuery.of(context).size.width * 0.9,
                onEditingComplete: () {
                  if (_site == "By Pallet") {
                    byPalletMethod();
                    return;
                  }
                  if (_site == "By Serial") {
                    bySerialMethod();
                    return;
                  }
                },
              ),
            ),
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
                    dataRowColor: MaterialStateColor.resolveWith(
                        (states) => Colors.grey.withOpacity(0.2)),
                    headingRowColor: MaterialStateColor.resolveWith(
                        (states) => AppColors.pink),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    border: TableBorder.all(
                      color: Colors.black,
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
                          label: Text('Item Code',
                              style: TextStyle(color: Colors.white))),
                      DataColumn(
                          label: Text('Item Desc',
                              style: TextStyle(color: Colors.white))),
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
                        'ItemSerialNo',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                      DataColumn(
                        label: Text(
                          'Map Date',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Pallet Code',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Reference',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'SID',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'CID',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'PO',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Trans',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    rows: table.map((e) {
                      return DataRow(onSelectChanged: (value) {}, cells: [
                        DataCell(Text((table.indexOf(e) + 1).toString())),
                        DataCell(Text(e.itemCode ?? "")),
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
                        DataCell(Text(e.pO ?? '')),
                        DataCell(Text(e.trans.toString())),
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
                      return item.toLowerCase().contains(filter.toLowerCase());
                    },
                    enabled: true,
                    popupProps: const PopupProps.menu(),
                    // dropdownButtonProps: const DropdownButtonProps(
                    //   icon: Icon(
                    //     Icons.arrow_drop_down,
                    //     color: Colors.black,
                    //   ),
                    // ),
                    // items: filterList,
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
            const SizedBox(height: 10),
            Center(
              child: ElevatedButtonWidget(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.9,
                title: "Save",
                onPressed: () {
                  insertData();
                },
                textColor: Colors.white,
                color: AppColors.pink,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void insertData() {
    print("hello");
    if (table.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please Scan Pallet or Serial, Table is empty"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (widget.QTYRECEIVED >= widget.QTYTRANSFER) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("All Quantities have been received"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (table.length > widget.QTYTRANSFER - widget.QTYRECEIVED) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "You can only scan ${widget.QTYTRANSFER - widget.QTYRECEIVED} more items"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    AppDialogs.loadingDialog(context);
    InsertAllDataController.postDataToWIPtoFG(
      table,
      widget.TRANSFERID,
      widget.TRANSFERSTATUS,
      widget.INVENTLOCATIONIDFROM,
      widget.INVENTLOCATIONIDTO,
      widget.ITEMID,
      widget.QTYTRANSFER,
      widget.QTYRECEIVED,
      table[0].mainLocation.toString(),
      dropDownValue.toString(),
      DateTime.now().toString(),
      widget.GROUPID,
    ).then((value) async {
      AppDialogs.closeDialog();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Data inserted and updated successfully."),
      ));

      RawMaterialsToWIPController.insertGtrackEPCISLog(
        "stock_transfer",
        table[0].gTIN!,
        table[0].binLocation!,
        dropDownValue.toString(),
        'manufacturing',
      ).then((value) {
        print("EPCIS Log Inserted");
      }).onError((error, stackTrace) {
        print("EPCIS Log error: $error");
      });

      setState(() {
        table.clear();
        _scanSerialandPalletController.clear();
        widget.QTYRECEIVED = widget.QTYRECEIVED + 1;
      });
    }).onError((error, stackTrace) {
      AppDialogs.closeDialog();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString().replaceAll("Exception:", "")),
      ));
    });
  }

  void byPalletMethod() {
    if (_scanSerialandPalletController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please Scan Pallet"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    // if a pallet no is already exist then show the error
    if (table.any((element) =>
        element.palletCode == _scanSerialandPalletController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Pallet No already exist"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    FocusScope.of(context).requestFocus(FocusNode());
    AppDialogs.loadingDialog(context);

    GetPalletTableController.getAllTable(
            _scanSerialandPalletController.text.trim())
        .then((value) {
      setState(() {
        table.addAll(value);
        _scanSerialandPalletController.clear();
      });
      // focus back to pallet type
      AppDialogs.closeDialog();
      // focus back to pallet type
      FocusScope.of(context).requestFocus(focusNode);
    }).onError((error, stackTrace) {
      AppDialogs.closeDialog();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString().replaceAll("Exception:", "")),
      ));
    });
  }

  void bySerialMethod() {
    if (_scanSerialandPalletController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please Scan Serial"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    // if a serial no is already exist then show the error
    if (table.any((element) =>
        element.itemSerialNo == _scanSerialandPalletController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Serial No already exist"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    FocusScope.of(context).requestFocus(FocusNode());
    AppDialogs.loadingDialog(context);
    GetSerialTableController.getAllTable(
            _scanSerialandPalletController.text.trim())
        .then((value) {
      setState(() {
        // append the value to the table
        table.addAll(value);
        _scanSerialandPalletController.clear();
      });
      AppDialogs.closeDialog();
      FocusScope.of(context).requestFocus(focusNode);
    }).onError((error, stackTrace) {
      AppDialogs.closeDialog();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString().replaceAll("Exception:", "")),
      ));
    });
  }
}

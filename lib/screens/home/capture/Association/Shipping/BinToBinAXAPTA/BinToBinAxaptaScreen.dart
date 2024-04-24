// ignore_for_file: use_build_context_synchronously, avoid_print, non_constant_identifier_names, prefer_final_fields, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_images.dart';
import 'package:gtrack_mobile_app/controllers/capture/Association/Shipping/Warehouse_Transfer/BinToBinFromAXAPTA/GetQtyReceivedController.dart';
import 'package:gtrack_mobile_app/controllers/capture/Association/Shipping/Warehouse_Transfer/BinToBinFromAXAPTA/getAxaptaTableData.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_dialogs.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/widgets/appBar/appBar_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text/text_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text_field/text_form_field_widget.dart';
import 'package:gtrack_mobile_app/models/capture/Association/Mapping/BinToBinAxapta/GetAxaptaTableModel.dart';

import 'BinToBinAxapta2Screen.dart';

class BinToBinAxaptaScreen extends StatefulWidget {
  const BinToBinAxaptaScreen({super.key});

  @override
  State<BinToBinAxaptaScreen> createState() => _BinToBinAxaptaScreenState();
}

class _BinToBinAxaptaScreenState extends State<BinToBinAxaptaScreen> {
  TextEditingController _transferController = TextEditingController();
  String total = "0";

  List<GetAxaptaTableDataModel> GetShipmentPalletizingList = [];
  List<bool> isMarked = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBarWidget(
          backgroundColor: AppColors.pink,
          onPressed: () {
            Navigator.of(context).pop();
          },
          title: "Internal Transfer".toUpperCase(),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.only(right: 10),
                child: Image.asset(
                  AppImages.delete,
                  width: 30,
                  height: 30,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: const TextWidget(
                  text: "Transfer ID*",
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
                        controller: _transferController,
                        hintText: "Enter/Scan Transfer ID",
                        width: MediaQuery.of(context).size.width * 0.73,
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
              Container(
                margin: const EdgeInsets.only(left: 10, top: 10),
                child: const TextWidget(
                  text: "Shipment Details*",
                  fontSize: 16,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
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
                            label: Text(
                          'TRANSFER ID',
                          style: TextStyle(color: Colors.white),
                        )),
                        DataColumn(
                            label: Text(
                          'TRANSFER STATUS',
                          style: TextStyle(color: Colors.white),
                        )),
                        DataColumn(
                            label: Text(
                          'INVENT LOCATION ID FROM',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'INVENT LOCATION ID To',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'ITEM ID',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'QTY TRANSFER',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'QTY RECEIVED',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'CREATED DATE TIME',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'GROUP ID',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                      ],
                      rows: GetShipmentPalletizingList.map((e) {
                        return DataRow(
                            onSelectChanged: (value) async {
                              // qty transfer is equal or greater than qty received
                              if (e.qTYRECEIVED! >= e.qTYTRANSFER!) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "All Quantities have been transfered."),
                                  ),
                                );
                                return;
                              }
                              AppDialogs.loadingDialog(context);
                              num numb =
                                  await GetQtyReceivedController.getAllTable(
                                      e.tRANSFERID.toString(),
                                      e.iTEMID.toString());
                              try {
                                print("numb: $numb");
                                if (numb >= e.qTYTRANSFER!) {
                                  AppDialogs.closeDialog();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "All Quantities have been transfered."),
                                    ),
                                  );
                                  return;
                                }
                                AppDialogs.closeDialog();
                                setState(() {
                                  isMarked[GetShipmentPalletizingList.indexOf(
                                      e)] = value!;
                                });
                                AppNavigator.goToPage(
                                  context: context,
                                  screen: BinToBinAxapta2Screen(
                                    TRANSFERID: e.tRANSFERID ?? "",
                                    TRANSFERSTATUS:
                                        int.parse(e.tRANSFERSTATUS.toString()),
                                    INVENTLOCATIONIDFROM:
                                        e.iNVENTLOCATIONIDFROM ?? "",
                                    INVENTLOCATIONIDTO:
                                        e.iNVENTLOCATIONIDTO ?? "",
                                    ITEMID: e.iTEMID ?? "",
                                    QTYTRANSFER:
                                        int.parse(e.qTYTRANSFER.toString()),
                                    QTYRECEIVED: int.parse(numb.toString()),
                                    CREATEDDATETIME: e.cREATEDDATETIME ?? "",
                                    GROUPID: e.gROUPID ?? "",
                                  ),
                                );
                              } catch (e) {
                                AppDialogs.closeDialog();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e
                                        .toString()
                                        .replaceAll("Exception:", "")),
                                  ),
                                );
                              }
                            },
                            cells: [
                              DataCell(Text(
                                  (GetShipmentPalletizingList.indexOf(e) + 1)
                                      .toString())),
                              DataCell(Text(e.tRANSFERID ?? "")),
                              DataCell(Text(e.tRANSFERSTATUS.toString())),
                              DataCell(Text(e.iNVENTLOCATIONIDFROM ?? "")),
                              DataCell(Text(e.iNVENTLOCATIONIDTO ?? "")),
                              DataCell(Text(e.iTEMID ?? "")),
                              DataCell(Text(e.qTYTRANSFER.toString())),
                              DataCell(Text(e.qTYRECEIVED.toString())),
                              DataCell(Text(e.cREATEDDATETIME ?? "")),
                              DataCell(Text(e.gROUPID ?? "")),
                            ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const TextWidget(text: "TOTAL"),
                  const SizedBox(width: 10),
                  Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: TextWidget(text: total),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSearch() async {
    FocusScope.of(context).requestFocus(FocusNode());
    AppDialogs.loadingDialog(context);
    GetAxaptaTableDataController.getAllTable(_transferController.text.trim())
        .then((value) {
      AppDialogs.closeDialog();
      setState(() {
        GetShipmentPalletizingList = value;
        isMarked = List<bool>.generate(
            GetShipmentPalletizingList.length, (index) => false);
        total = GetShipmentPalletizingList.length.toString();
      });
    }).onError((error, stackTrace) {
      AppDialogs.closeDialog();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceAll("Exception:", "")),
        ),
      );
    });
  }
}

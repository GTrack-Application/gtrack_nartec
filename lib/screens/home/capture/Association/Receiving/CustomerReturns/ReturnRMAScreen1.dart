// ignore_for_file: prefer_final_fields, sized_box_for_whitespace, prefer_typing_uninitialized_variables, unnecessary_import

import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtrack_mobile_app/constants/app_images.dart';
import 'package:gtrack_mobile_app/controllers/capture/Association/Receivingg/CustomerReturns/getWmsReturnSalesOrderByReturnItemNumController.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_dialogs.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/widgets/appBar/appBar_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text/text_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text_field/text_form_field_widget.dart';
import 'package:gtrack_mobile_app/models/capture/Association/ReceivingModel/CustomerReturns/GetWmsReturnSalesOrderByReturnItemNumModel.dart';

import 'ReturnRMAScreen2.dart';

var recQty;

class ReturnRMAScreen1 extends StatefulWidget {
  const ReturnRMAScreen1({super.key});

  @override
  State<ReturnRMAScreen1> createState() => _ReturnRMAScreen1State();
}

class _ReturnRMAScreen1State extends State<ReturnRMAScreen1> {
  TextEditingController _searchController = TextEditingController();
  String total = "0";
  List<getWmsReturnSalesOrderByReturnItemNumModel> table = [];
  List<bool> isMarked = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBarWidget(
            backgroundColor: AppColors.pink,
            autoImplyLeading: true,
            onPressed: () {
              Get.back();
            },
            title: "Return  RMA".toUpperCase(),
            actions: [
              GestureDetector(
                onTap: () {
                  Get.back();
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
                  margin: const EdgeInsets.only(left: 20, top: 5),
                  child: const TextWidget(
                    text: "RMA*",
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
                          controller: _searchController,
                          hintText: "Enter/Scan RMA",
                          width: MediaQuery.of(context).size.width * 0.73,
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                            if (_searchController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please enter RMA",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            AppDialogs.loadingDialog(context);
                            getWmsReturnSalesOrderByReturnItemNumController
                                .getData(_searchController.text.trim())
                                .then((value) {
                              setState(() {
                                table = value;
                                isMarked = List<bool>.generate(
                                    table.length, (index) => false);
                                total = table.length.toString();

                                recQty = table[0].eXPECTEDRETQTY;
                              });
                              AppDialogs.closeDialog();
                            }).onError((error, stackTrace) {
                              AppDialogs.closeDialog();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    error
                                        .toString()
                                        .replaceAll("Exception", ""),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            });
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
                            if (_searchController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please enter RMA",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            AppDialogs.loadingDialog(context);

                            getWmsReturnSalesOrderByReturnItemNumController
                                .getData(_searchController.text.trim())
                                .then((value) {
                              setState(() {
                                table = value;
                                isMarked = List<bool>.generate(
                                    table.length, (index) => false);
                                total = table.length.toString();

                                recQty = table[0].eXPECTEDRETQTY;
                              });
                              AppDialogs.closeDialog();
                            }).onError((error, stackTrace) {
                              AppDialogs.closeDialog();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    error
                                        .toString()
                                        .replaceAll("Exception", ""),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            });
                          },
                          child: Image.asset(
                            AppImages.finder,
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: 50,
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
                    text: "Items*",
                    fontSize: 16,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.55,
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
                            'ITEM ID',
                            style: TextStyle(color: Colors.white),
                          )),
                          DataColumn(
                              label: Text(
                            'ITEM NAME',
                            style: TextStyle(color: Colors.white),
                          )),
                          DataColumn(
                              label: Text(
                            'EXPECTED RET QTY',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'SALES ID',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'RETURN ITEM NUM',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'INVENT SITE ID',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'INVENT LOCATION ID',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'CONFIG ID',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'WMS LOCATION ID',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                        ],
                        rows: table.map((e) {
                          return DataRow(
                              onSelectChanged: (value) {
                                AppNavigator.goToPage(
                                  context: context,
                                  screen: ReturnRMAScreen2(
                                    cONFIGID: e.cONFIGID.toString(),
                                    eXPECTEDRETQTY: recQty,
                                    iNVENTLOCATIONID:
                                        e.iNVENTLOCATIONID.toString(),
                                    iNVENTSITEID: e.iNVENTSITEID.toString(),
                                    iTEMID: e.iTEMID.toString(),
                                    nAME: e.nAME.toString(),
                                    rETURNITEMNUM: e.rETURNITEMNUM.toString(),
                                    sALESID: e.sALESID.toString(),
                                    wMSLOCATIONID: e.wMSLOCATIONID.toString(),
                                    tble: e,
                                  ),
                                );
                              },
                              cells: [
                                DataCell(
                                    Text((table.indexOf(e) + 1).toString())),
                                DataCell(Text(e.iTEMID.toString())),
                                DataCell(Text(e.nAME.toString())),
                                DataCell(Text(e.eXPECTEDRETQTY.toString())),
                                DataCell(Text(e.sALESID.toString())),
                                DataCell(Text(e.rETURNITEMNUM.toString())),
                                DataCell(Text(e.iNVENTSITEID.toString())),
                                DataCell(Text(e.iNVENTLOCATIONID.toString())),
                                DataCell(Text(e.cONFIGID.toString())),
                                DataCell(Text(e.wMSLOCATIONID.toString())),
                              ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    const TextWidget(text: "TOTAL"),
                    const SizedBox(width: 5),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
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
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously, avoid_print, non_constant_identifier_names, prefer_final_fields, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:gtrack_nartec/constants/app_images.dart';
import 'package:gtrack_nartec/controllers/capture/Association/Shipping/Warehouse_Transfer/BinToBinFromAXAPTA/GetQtyReceivedController.dart';
import 'package:gtrack_nartec/controllers/capture/Association/Shipping/Warehouse_Transfer/BinToBinFromAXAPTA/getAxaptaTableData.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_dialogs.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/global/widgets/appBar/appBar_widget.dart';
import 'package:gtrack_nartec/global/widgets/text/text_widget.dart';
import 'package:gtrack_nartec/global/widgets/text_field/text_form_field_widget.dart';
import 'package:gtrack_nartec/models/capture/Association/Mapping/BinToBinAxapta/GetAxaptaTableModel.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Transfer/goods_issue/raw_materials/wip_fg/BinToBinAXAPTA/BinToBinAxapta2Screen.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/Transfer/goods_issue/raw_materials/wip_fg/BinToBinAXAPTA/bin_to_bin_details_screen.dart';

class WIPtoFGBinToBinAxaptaScreen extends StatefulWidget {
  const WIPtoFGBinToBinAxaptaScreen({super.key});

  @override
  State<WIPtoFGBinToBinAxaptaScreen> createState() =>
      _WIPtoFGBinToBinAxaptaScreenState();
}

class _WIPtoFGBinToBinAxaptaScreenState
    extends State<WIPtoFGBinToBinAxaptaScreen> {
  TextEditingController _transferController = TextEditingController();
  String total = "0";

  List<GetAxaptaTableDataModel> table = [];
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
          title: "WIP to FG",
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
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  itemCount: table.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      ),
                      child: ListTile(
                        onTap: () {
                          // qty transfer is equal or greater than qty received
                          if (table[index].qTYRECEIVED! >=
                              table[index].qTYTRANSFER!) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "All Quantities have been transfered."),
                              ),
                            );
                            return;
                          }
                          AppDialogs.loadingDialog(context);
                          GetQtyReceivedController.getAllTable(
                                  table[index].tRANSFERID.toString(),
                                  table[index].iTEMID.toString())
                              .then((value) {
                            AppDialogs.closeDialog();
                            if (value >= table[index].qTYTRANSFER!) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "All Quantities have been transfered."),
                                ),
                              );
                              return;
                            }
                            AppNavigator.goToPage(
                              context: context,
                              screen: WIPtoFGBinToBinAxapta2Screen(
                                TRANSFERID: table[index].tRANSFERID ?? "",
                                TRANSFERSTATUS: int.parse(
                                    table[index].tRANSFERSTATUS.toString()),
                                INVENTLOCATIONIDFROM:
                                    table[index].iNVENTLOCATIONIDFROM ?? "",
                                INVENTLOCATIONIDTO:
                                    table[index].iNVENTLOCATIONIDTO ?? "",
                                ITEMID: table[index].iTEMID ?? "",
                                QTYTRANSFER: int.parse(
                                    table[index].qTYTRANSFER.toString()),
                                QTYRECEIVED: int.parse(value.toString()),
                                CREATEDDATETIME:
                                    table[index].cREATEDDATETIME ?? "",
                                GROUPID: table[index].gROUPID ?? "",
                              ),
                            );
                          }).onError((error, stackTrace) {
                            AppDialogs.closeDialog();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error
                                    .toString()
                                    .replaceAll("Exception:", "")),
                              ),
                            );
                          });
                        },
                        contentPadding: const EdgeInsets.all(10),
                        title: Text(
                          "${table[index].iTEMID}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "Transfer Status: ${table[index].tRANSFERSTATUS}",
                          style: const TextStyle(fontSize: 13),
                        ),
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: AppColors.pink,
                          child: TextWidget(
                            text: (index + 1).toString(),
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            AppNavigator.goToPage(
                                context: context,
                                screen: BinToBinDetailsScreen(
                                    employees: table[index]));
                          },
                          child: Image.asset("assets/icons/view.png"),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Container(
            //   height: MediaQuery.of(context).size.height * 0.5,
            //   decoration: BoxDecoration(
            //     border: Border.all(
            //       color: Colors.grey,
            //       width: 1,
            //     ),
            //   ),
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.vertical,
            //     child: SingleChildScrollView(
            //       scrollDirection: Axis.horizontal,
            //       child: DataTable(
            //         showCheckboxColumn: false,
            //         dataRowColor: MaterialStateColor.resolveWith(
            //             (states) => Colors.grey.withOpacity(0.2)),
            //         headingRowColor: MaterialStateColor.resolveWith(
            //             (states) => AppColors.pink),
            //         decoration: BoxDecoration(
            //           border: Border.all(
            //             color: Colors.grey,
            //             width: 1,
            //           ),
            //         ),
            //         border: TableBorder.all(
            //           color: Colors.black,
            //           width: 1,
            //         ),
            //         columns: const [
            //           DataColumn(
            //               label: Text(
            //             'ID',
            //             style: TextStyle(color: Colors.white),
            //             textAlign: TextAlign.center,
            //           )),
            //           DataColumn(
            //               label: Text(
            //             'TRANSFER ID',
            //             style: TextStyle(color: Colors.white),
            //           )),
            //           DataColumn(
            //               label: Text(
            //             'TRANSFER STATUS',
            //             style: TextStyle(color: Colors.white),
            //           )),
            //           DataColumn(
            //               label: Text(
            //             'INVENT LOCATION ID FROM',
            //             style: TextStyle(color: Colors.white),
            //             textAlign: TextAlign.center,
            //           )),
            //           DataColumn(
            //               label: Text(
            //             'INVENT LOCATION ID To',
            //             style: TextStyle(color: Colors.white),
            //             textAlign: TextAlign.center,
            //           )),
            //           DataColumn(
            //               label: Text(
            //             'ITEM ID',
            //             style: TextStyle(color: Colors.white),
            //             textAlign: TextAlign.center,
            //           )),
            //           DataColumn(
            //               label: Text(
            //             'QTY TRANSFER',
            //             style: TextStyle(color: Colors.white),
            //             textAlign: TextAlign.center,
            //           )),
            //           DataColumn(
            //               label: Text(
            //             'QTY RECEIVED',
            //             style: TextStyle(color: Colors.white),
            //             textAlign: TextAlign.center,
            //           )),
            //           DataColumn(
            //               label: Text(
            //             'CREATED DATE TIME',
            //             style: TextStyle(color: Colors.white),
            //             textAlign: TextAlign.center,
            //           )),
            //           DataColumn(
            //               label: Text(
            //             'GROUP ID',
            //             style: TextStyle(color: Colors.white),
            //             textAlign: TextAlign.center,
            //           )),
            //         ],
            //         rows: table.map((e) {
            //           return DataRow(
            //               onSelectChanged: (value) async {
            //                 // qty transfer is equal or greater than qty received
            //                 if (e.qTYRECEIVED! >= e.qTYTRANSFER!) {
            //                   ScaffoldMessenger.of(context).showSnackBar(
            //                     const SnackBar(
            //                       content: Text(
            //                           "All Quantities have been transfered."),
            //                     ),
            //                   );
            //                   return;
            //                 }
            //                 AppDialogs.loadingDialog(context);
            //                 num numb =
            //                     await GetQtyReceivedController.getAllTable(
            //                         e.tRANSFERID.toString(),
            //                         e.iTEMID.toString());
            //                 try {
            //                   print("numb: $numb");
            //                   if (numb >= e.qTYTRANSFER!) {
            //                     AppDialogs.closeDialog();
            //                     ScaffoldMessenger.of(context).showSnackBar(
            //                       const SnackBar(
            //                         content: Text(
            //                             "All Quantities have been transfered."),
            //                       ),
            //                     );
            //                     return;
            //                   }
            //                   AppDialogs.closeDialog();
            //                   setState(() {
            //                     isMarked[table.indexOf(e)] = value!;
            //                   });
            //                   AppNavigator.goToPage(
            //                     context: context,
            //                     screen: BinToBinAxapta2Screen(
            //                       TRANSFERID: e.tRANSFERID ?? "",
            //                       TRANSFERSTATUS:
            //                           int.parse(e.tRANSFERSTATUS.toString()),
            //                       INVENTLOCATIONIDFROM:
            //                           e.iNVENTLOCATIONIDFROM ?? "",
            //                       INVENTLOCATIONIDTO:
            //                           e.iNVENTLOCATIONIDTO ?? "",
            //                       ITEMID: e.iTEMID ?? "",
            //                       QTYTRANSFER:
            //                           int.parse(e.qTYTRANSFER.toString()),
            //                       QTYRECEIVED: int.parse(numb.toString()),
            //                       CREATEDDATETIME: e.cREATEDDATETIME ?? "",
            //                       GROUPID: e.gROUPID ?? "",
            //                     ),
            //                   );
            //                 } catch (e) {
            //                   AppDialogs.closeDialog();
            //                   ScaffoldMessenger.of(context).showSnackBar(
            //                     SnackBar(
            //                       content: Text(e
            //                           .toString()
            //                           .replaceAll("Exception:", "")),
            //                     ),
            //                   );
            //                 }
            //               },
            //               cells: [
            //                 DataCell(Text((table.indexOf(e) + 1).toString())),
            //                 DataCell(Text(e.tRANSFERID ?? "")),
            //                 DataCell(Text(e.tRANSFERSTATUS.toString())),
            //                 DataCell(Text(e.iNVENTLOCATIONIDFROM ?? "")),
            //                 DataCell(Text(e.iNVENTLOCATIONIDTO ?? "")),
            //                 DataCell(Text(e.iTEMID ?? "")),
            //                 DataCell(Text(e.qTYTRANSFER.toString())),
            //                 DataCell(Text(e.qTYRECEIVED.toString())),
            //                 DataCell(Text(e.cREATEDDATETIME ?? "")),
            //                 DataCell(Text(e.gROUPID ?? "")),
            //               ]);
            //         }).toList(),
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const TextWidget(text: "TOTAL"),
                  const SizedBox(width: 10),
                  Container(
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: TextWidget(
                        text: total,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSearch() async {
    FocusScope.of(context).requestFocus(FocusNode());
    AppDialogs.loadingDialog(context);
    GetAxaptaTableDataController.getAllTable(_transferController.text.trim())
        .then((value) {
      setState(() {
        _transferController.clear();
        table = value;
        isMarked = List<bool>.generate(table.length, (index) => false);
        total = table.length.toString();
      });
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
}

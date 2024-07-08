// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, avoid_print, file_names

import 'package:gtrack_mobile_app/constants/app_images.dart';
import 'package:gtrack_mobile_app/controllers/capture/Aggregation/Palletization/GetShipmentPalletizingController.dart';
import 'package:gtrack_mobile_app/controllers/capture/Aggregation/Palletization/ValidateShipmentIdFromShipmentReveivedClController.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_dialogs.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/widgets/appBar/appBar_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text/text_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text_field/text_form_field_widget.dart';
import 'package:gtrack_mobile_app/models/capture/aggregation/palletization/GetTransferDistributionByTransferIdModel.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Aggregation/Palletization/PalletProceedScreen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class ShipmentPalletizingScreen extends StatefulWidget {
  const ShipmentPalletizingScreen({super.key});

  @override
  State<ShipmentPalletizingScreen> createState() =>
      _ShipmentPalletizingScreenState();
}

class _ShipmentPalletizingScreenState extends State<ShipmentPalletizingScreen> {
  TextEditingController transferIdController = TextEditingController();
  TextEditingController shipmentIdController = TextEditingController();

  String total = "0";
  List<GetTransferDistributionByTransferIdModel> table = [];
  List<bool> isMarked = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    transferIdController.dispose();
  }

  bool isShipmentId = false;

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
              Container(
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: const TextWidget(
                  text: " Transfer ID*",
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
                        controller: transferIdController,
                        width: MediaQuery.of(context).size.width * 0.73,
                        onEditingComplete: () {
                          onClick();
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
                          onClick();
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
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: const TextWidget(
                  text: " Filter by Shipment ID*",
                  fontSize: 16,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: TextFormFieldWidget(
                  controller: shipmentIdController,
                  readOnly: isShipmentId == true ? true : false,
                  width: MediaQuery.of(context).size.width * 0.9,
                  onEditingComplete: () {
                    onShipmentSearch();
                  },
                ),
              ),
              const SizedBox(height: 10),
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
                          'ALS_PACKINGSLIPREF',
                          style: TextStyle(color: Colors.white),
                        )),
                        DataColumn(
                            label: Text(
                          'ALS_TRANSFERORDERTYPE',
                          style: TextStyle(color: Colors.white),
                        )),
                        DataColumn(
                            label: Text(
                          'TRANSFER ID',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'INVENT LOCATION ID FROM',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'INVENT LOCATION ID TO',
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
                          'ITEM ID',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'ITEM NAME',
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
                        DataColumn(
                            label: Text(
                          'SHIPMENT ID',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                      ],
                      rows: table.map((e) {
                        return DataRow(
                            onSelectChanged: (value) async {
                              if (e.sHIPMENTID == null || e.sHIPMENTID == "") {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Please Enter Shipment id."),
                                  backgroundColor: Colors.redAccent,
                                  duration: Duration(seconds: 1),
                                ));
                                return;
                              }

                              FocusScope.of(context).requestFocus(FocusNode());
                              if (isShipmentId == false) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      "Shipment ID not found in tbl_Shipment_Received_CL"),
                                  backgroundColor: Colors.redAccent,
                                  duration: Duration(seconds: 1),
                                ));
                                return;
                              }
                              Get.to(() => PalletProceedScreen(
                                    iNVENTLOCATIONIDFROM:
                                        e.iNVENTLOCATIONIDFROM ?? "",
                                    iNVENTLOCATIONIDTO:
                                        e.iNVENTLOCATIONIDTO ?? "",
                                    iTEMID: e.iTEMID ?? "",
                                    tRANSFERID: e.tRANSFERID ?? "",
                                    shipmentId: e.sHIPMENTID!,
                                    ALS_PACKINGSLIPREF:
                                        e.aLSPACKINGSLIPREF ?? "",
                                    ALS_TRANSFERORDERTYPE: int.parse(
                                        e.aLSTRANSFERORDERTYPE.toString()),
                                    QTYTRANSFER:
                                        int.parse(e.qTYTRANSFER.toString()),
                                    ITEMNAME: e.iTEMNAME ?? "",
                                    CONFIGID: e.cONFIGID ?? "",
                                    WMSLOCATIONID: e.wMSLOCATIONID ?? "",
                                  ));
                            },
                            cells: [
                              DataCell(Text(e.aLSPACKINGSLIPREF ?? "")),
                              DataCell(Text(e.aLSTRANSFERORDERTYPE.toString())),
                              DataCell(Text(e.tRANSFERID ?? "")),
                              DataCell(Text(e.iNVENTLOCATIONIDFROM ?? "")),
                              DataCell(Text(e.iNVENTLOCATIONIDTO ?? "")),
                              DataCell(Text(e.qTYTRANSFER.toString())),
                              DataCell(Text(e.iTEMID.toString())),
                              DataCell(Text(e.iTEMNAME ?? "")),
                              DataCell(Text(e.cONFIGID ?? "")),
                              DataCell(Text(e.wMSLOCATIONID ?? "")),
                              DataCell(Text(e.sHIPMENTID ?? "")),
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
                  const TextWidget(
                    text: "TOTAL",
                    fontSize: 15,
                  ),
                  const SizedBox(width: 5),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: 30,
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void onClick() async {
    AppDialogs.loadingDialog(context);
    GetShipmentPalletizingController.getShipmentPalletizing(
            transferIdController.text.trim())
        .then((value) {
      setState(() {
        table = value;
        total = value.length.toString();
        shipmentIdController.text = value[0].sHIPMENTID ?? "";
        if (value[0].sHIPMENTID != null && value[0].sHIPMENTID != "") {
          isShipmentId = true;
        } else {
          isShipmentId = false;
        }
      });
      // Hide keyboard
      FocusScope.of(context).requestFocus(FocusNode());
      AppDialogs.closeDialog();
    }).onError((error, stackTrace) {
      setState(() {
        table = [];
        total = "0";
        isShipmentId = false;
      });
      AppDialogs.closeDialog();
      toast(
        error.toString().replaceAll("Exception:", ""),
        bgColor: Colors.red,
        textColor: Colors.white,
      );
    });
  }

  void onShipmentSearch() async {
    FocusScope.of(context).requestFocus(FocusNode());
    AppDialogs.loadingDialog(context);
    bool value = await ValidateShipmentIdFromShipmentReveivedClController
        .palletizeSerialNo(shipmentIdController.text.trim());
    try {
      if (value) {
        setState(() {
          isShipmentId = true;
        });
        AppDialogs.closeDialog();

        toast(
          "Shipment ID is valid.",
          bgColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        setState(() {
          isShipmentId = false;
        });
        AppDialogs.closeDialog();

        toast(
          "Shipment ID not found in the tbl_Shipment_Received_CL.",
          bgColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print(e);
    }
  }
}

class StudentDataSource extends DataTableSource {
  List<GetTransferDistributionByTransferIdModel> table;
  BuildContext ctx;
  String? shipmentId;
  bool isShipmentId;

  StudentDataSource(
    this.table,
    this.ctx,
    this.shipmentId,
    this.isShipmentId,
  );

  @override
  DataRow? getRow(int index) {
    if (index >= table.length) {
      return null;
    }

    final tble = table[index];

    return DataRow.byIndex(
      index: index,
      onSelectChanged: (value) {
        if (shipmentId == null || shipmentId == "") {
          ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
            content: Text("Please Enter Shipment id."),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 1),
          ));
          return;
        }

        FocusScope.of(ctx).requestFocus(FocusNode());
        if (isShipmentId == false) {
          ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
            content: Text("Shipment ID not found in tbl_Shipment_Received_CL"),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 1),
          ));
          return;
        }
        AppNavigator.goToPage(
          context: ctx,
          screen: PalletProceedScreen(
            iNVENTLOCATIONIDFROM: tble.iNVENTLOCATIONIDFROM ?? "",
            iNVENTLOCATIONIDTO: tble.iNVENTLOCATIONIDTO ?? "",
            iTEMID: tble.iTEMID ?? "",
            tRANSFERID: tble.tRANSFERID ?? "",
            shipmentId: shipmentId!,
            ALS_PACKINGSLIPREF: tble.aLSPACKINGSLIPREF ?? "",
            ALS_TRANSFERORDERTYPE:
                int.parse(tble.aLSTRANSFERORDERTYPE.toString()),
            QTYTRANSFER: int.parse(tble.qTYTRANSFER.toString()),
            ITEMNAME: tble.iTEMNAME ?? "",
            CONFIGID: tble.cONFIGID ?? "",
            WMSLOCATIONID: tble.wMSLOCATIONID ?? "",
          ),
        );
      },
      cells: [
        DataCell(SelectableText(tble.aLSPACKINGSLIPREF ?? "")),
        DataCell(SelectableText(tble.aLSTRANSFERORDERTYPE.toString())),
        DataCell(SelectableText(tble.tRANSFERID ?? "")),
        DataCell(SelectableText(tble.iNVENTLOCATIONIDFROM ?? "")),
        DataCell(SelectableText(tble.iNVENTLOCATIONIDTO ?? "")),
        DataCell(SelectableText(tble.qTYTRANSFER.toString())),
        DataCell(SelectableText(tble.iTEMID.toString())),
        DataCell(SelectableText(tble.iTEMNAME ?? "")),
        DataCell(SelectableText(tble.cONFIGID ?? "")),
        DataCell(SelectableText(tble.wMSLOCATIONID ?? "")),
        DataCell(SelectableText(tble.sHIPMENTID ?? "")),
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

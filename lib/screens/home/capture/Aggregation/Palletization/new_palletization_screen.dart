// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, avoid_print, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtrack_mobile_app/constants/app_images.dart';
import 'package:gtrack_mobile_app/controllers/capture/Aggregation/Palletization/GetShipmentPalletizingController.dart';
import 'package:gtrack_mobile_app/controllers/capture/Aggregation/Palletization/ValidateShipmentIdFromShipmentReveivedClController.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_dialogs.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/widgets/ElevatedButtonWidget.dart';
import 'package:gtrack_mobile_app/global/widgets/appBar/appBar_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text/text_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text_field/text_form_field_widget.dart';
import 'package:gtrack_mobile_app/models/capture/aggregation/palletization/GetTransferDistributionByTransferIdModel.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Aggregation/Palletization/PalletProceedScreen.dart';

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
  List<GetTransferDistributionByTransferIdModel> table = [];
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
                        readOnly: isShipmentId == true ? true : false,
                        onEditingComplete: () {
                          onShipmentSearch();
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
                        readOnly: isShipmentId == true ? true : false,
                        onEditingComplete: () {
                          onShipmentSearch();
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
                        child: Image.asset(AppImages.finder,
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: 60,
                            fit: BoxFit.cover),
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
                  source: StudentDataSource(
                    table,
                    context,
                    "Hello",
                    true,
                  ),
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
                      onPressed: () {},
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

  void onClick() async {
    AppDialogs.loadingDialog(context);
    GetShipmentPalletizingController.getShipmentPalletizing(
            noOfBoxController.text.trim())
        .then((value) {
      setState(() {
        table = value;
        total = value.length.toString();
        qtyPerBoxController.text = value[0].sHIPMENTID ?? "";
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.toString().replaceAll("Exception:", ""))));
    });
  }

  void onShipmentSearch() async {
    FocusScope.of(context).requestFocus(FocusNode());
    AppDialogs.loadingDialog(context);
    bool value = await ValidateShipmentIdFromShipmentReveivedClController
        .palletizeSerialNo(qtyPerBoxController.text.trim());
    try {
      if (value) {
        setState(() {
          isShipmentId = true;
        });
        AppDialogs.closeDialog();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Shipment ID is valid."),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ));
      } else {
        setState(() {
          isShipmentId = false;
        });
        AppDialogs.closeDialog();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Shipment ID not found in tbl_Shipment_Received_CL"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 1),
        ));
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

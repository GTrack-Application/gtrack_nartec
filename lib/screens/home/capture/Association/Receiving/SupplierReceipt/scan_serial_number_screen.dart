import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtrack_mobile_app/constants/app_images.dart';
import 'package:gtrack_mobile_app/controllers/Receiving/supplier_receipt/GetAllTableZoneController.dart';
import 'package:gtrack_mobile_app/controllers/Receiving/supplier_receipt/GetAllTblShipmentReceivedCLController.dart';
import 'package:gtrack_mobile_app/controllers/Receiving/supplier_receipt/GetItemNameByItemIdController.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_dialogs.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_mobile_app/global/widgets/text/text_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text_field/text_form_field_widget.dart';
import 'package:velocity_x/velocity_x.dart';

import 'save_screen.dart';
import 'shipment_dispatching_screen.dart';

// ignore: must_be_immutable
class ScanSerialNumberScreen extends StatefulWidget {
  String sHIPMENTID;
  String cONTAINERID;
  String aRRIVALWAREHOUSE;
  String iTEMNAME;
  String iTEMID;
  String pURCHID;
  String cLASSIFICATION;
  String sERIALNUM;
  String rCVDCONFIGID;
  String gTIN;
  String rZONE;
  String pALLETCODE;
  String bIN;
  String rEMARKS;
  num pOQTY;
  num rCVQTY;
  num rEMAININGQTY;
  String createdDateTime;

  ScanSerialNumberScreen({
    Key? key,
    required this.sHIPMENTID,
    required this.cONTAINERID,
    required this.aRRIVALWAREHOUSE,
    required this.iTEMNAME,
    required this.iTEMID,
    required this.pURCHID,
    required this.cLASSIFICATION,
    required this.sERIALNUM,
    required this.rCVDCONFIGID,
    required this.gTIN,
    required this.rZONE,
    required this.pALLETCODE,
    required this.bIN,
    required this.rEMARKS,
    required this.pOQTY,
    required this.rCVQTY,
    required this.rEMAININGQTY,
    required this.createdDateTime,
  }) : super(key: key);

  @override
  State<ScanSerialNumberScreen> createState() => _ScanSerialNumberScreenState();
}

class _ScanSerialNumberScreenState extends State<ScanSerialNumberScreen> {
  final TextEditingController _jobOrderNoController = TextEditingController();
  final TextEditingController _containerNoController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _gtinNoController = TextEditingController();
  final TextEditingController _receivingZoneController =
      TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  String dropdownValue = 'Select Zone';
  List<String> dropdownList = ['Select Zone'];

  String itemName = '';
  String cond = '';

  @override
  void initState() {
    super.initState();

    _jobOrderNoController.text = widget.sHIPMENTID;
    _containerNoController.text = widget.cONTAINERID;
    _itemNameController.text = itemName;
    _weightController.text = "13";
    _heightController.text = "310";
    _widthController.text = "335";
    _lengthController.text = "500";

    Future.delayed(Duration.zero, () {
      AppDialogs.loadingDialog(context);
      GetAllTableZoneController.getAllTableZone().then((value) {
        dropdownValue = dropdownList[0];
        for (int i = 0; i < value.length; i++) {
          dropdownList.add(value[i].rZONE.toString());
          // convert the dropdownList to a list of strings
          dropdownList = dropdownList.toSet().toList();
        }

        GetAllTblShipmentReceivedCLController.getAllTableZone(
          widget.cONTAINERID,
          widget.sHIPMENTID,
          widget.iTEMID,
        ).then((value) {
          setState(() {
            rCQTY = value;
          });
        }).onError((error, stackTrace) {
          setState(() {
            rCQTY = 0;
          });
          AppDialogs.closeDialog();
        });

        GetItemNameByItemIdController.getName(widget.iTEMID).then((value) {
          setState(() {
            itemName = value[0].itemDesc ?? "";
            _itemNameController.text = value[0].itemDesc ?? "";
            cond = value[0].classification ?? "";
          });
          AppDialogs.closeDialog();

          // GetTblStockMasterByItemIdController.getData(widget.itemId)
          //     .then((value) {
          //   setState(() {
          //     _widthController.text =
          //         double.parse(value[0].width.toString()).toString();
          //     _heightController.text =
          //         double.parse(value[0].height.toString()).toString();
          //     _lengthController.text =
          //         double.parse(value[0].length.toString()).toString();
          //     _weightController.text =
          //         double.parse(value[0].weight.toString()).toString();
          //   });
          // AppDialogs.closeDialog();
          // }).onError((error, stackTrace) {
          //   AppDialogs.closeDialog();

          //   setState(() {
          //     _widthController.text = "";
          //     _heightController.text = "";
          //     _lengthController.text = "";
          //   });
          // });
        }).onError((error, stackTrace) {
          setState(() {
            itemName = "";
            _itemNameController.text = "";
            cond = "";
          });
          AppDialogs.closeDialog();

          // GetTblStockMasterByItemIdController.getData(widget.iTEMID)
          //     .then((value) {
          //   setState(() {
          //     _widthController.text =
          //         double.parse(value[0].width.toString()).toString();
          //     _heightController.text =
          //         double.parse(value[0].height.toString()).toString();
          //     _lengthController.text =
          //         double.parse(value[0].length.toString()).toString();
          //     _weightController.text =
          //         double.parse(value[0].weight.toString()).toString();
          //   });
          //   AppDialogs.closeDialog();
          // }).onError((error, stackTrace) {
          //   setState(() {
          //     _widthController.text = "";
          //     _heightController.text = "";
          //     _lengthController.text = "";
          //   });
          //   AppDialogs.closeDialog();
          // });
        });
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceAll("Exception:", "")),
          ),
        );
        AppDialogs.closeDialog();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                  margin: const EdgeInsets.only(left: 20, top: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                            AppImages.delete,
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                      const TextWidget(
                        text: "JOB ORDER NO*",
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 5),
                      TextFormFieldWidget(
                        controller: _jobOrderNoController,
                        width: MediaQuery.of(context).size.width * 0.9,
                        hintText: "Job Order No",
                        readOnly: true,
                      ),
                      const SizedBox(height: 10),
                      const TextWidget(
                        text: "CONTAINER NO*",
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 5),
                      TextFormFieldWidget(
                        controller: _containerNoController,
                        width: MediaQuery.of(context).size.width * 0.9,
                        hintText: "Container No",
                        readOnly: true,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                const TextWidget(
                                  text: "Item Code:",
                                  fontSize: 16,
                                  color: AppColors.white,
                                ),
                                const SizedBox(height: 10),
                                TextWidget(
                                  text: "PO QTY*\n${widget.pOQTY.toString()}",
                                  fontSize: 15,
                                  color: AppColors.white,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                TextWidget(
                                  text: widget.iTEMID,
                                  fontSize: 16,
                                  color: AppColors.white,
                                ),
                                const SizedBox(height: 10),
                                TextWidget(
                                  text: "Received*\n$rCQTY",
                                  fontSize: 15,
                                  color: AppColors.white,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const TextWidget(
                                  text: "CON",
                                  fontSize: 16,
                                  color: AppColors.white,
                                ),
                                const SizedBox(height: 10),
                                TextWidget(
                                  text: cond,
                                  fontSize: 15,
                                  color: AppColors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: const TextWidget(
                  text: "Item Name",
                  fontSize: 15,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: TextFormFieldWidget(
                  controller: _itemNameController,
                  width: MediaQuery.of(context).size.width * 0.9,
                  hintText: "Item Name",
                  readOnly: true,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: const TextWidget(
                  text: "GTIN",
                  fontSize: 15,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: TextFormFieldWidget(
                  controller: _gtinNoController,
                  width: MediaQuery.of(context).size.width * 0.9,
                  hintText: "Enter/Scan GTIN No",
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: const TextWidget(
                  text: "Receiving Zone",
                  fontSize: 15,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                width: MediaQuery.of(context).size.width * 0.9,
                child: DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    showSelectedItems: true,
                    disabledItemFn: (String s) => s.startsWith('I'),
                  ),
                  items: dropdownList,
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    baseStyle: TextStyle(fontSize: 15),
                    dropdownSearchDecoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Enter/Scan Receiving Zone",
                      hintStyle: TextStyle(fontSize: 15),
                    ),
                  ),
                  enabled: true,
                  onChanged: (value) {
                    setState(() {
                      _receivingZoneController.text = value!;
                      dropdownValue = value;
                    });
                  },
                  selectedItem: "Select Receiving Zone",
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextWidget(
                    text: "Length",
                    fontSize: 15,
                  ),
                  TextWidget(
                    text: "Width",
                    fontSize: 15,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextFormFieldWidget(
                    controller: _lengthController,
                    width: MediaQuery.of(context).size.width * 0.4,
                    hintText: "Enter Length",
                  ),
                  TextFormFieldWidget(
                    controller: _widthController,
                    width: MediaQuery.of(context).size.width * 0.4,
                    hintText: "Enter Width",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextWidget(
                    text: "Height",
                    fontSize: 15,
                  ),
                  TextWidget(
                    text: "Weight",
                    fontSize: 15,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextFormFieldWidget(
                    controller: _heightController,
                    width: MediaQuery.of(context).size.width * 0.4,
                    hintText: "Enter Length",
                  ),
                  TextFormFieldWidget(
                    controller: _weightController,
                    width: MediaQuery.of(context).size.width * 0.4,
                    hintText: "Enter Weight",
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: PrimaryButtonWidget(
                  backgroungColor: AppColors.pink,
                  text: "Scan Serial Number",
                  onPressed: () {
                    if (_gtinNoController.text.trim().isEmpty ||
                        _lengthController.text.trim().isEmpty ||
                        _weightController.text.trim().isEmpty ||
                        _heightController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter all the required fields"),
                        ),
                      );
                      return;
                    }
                    AppNavigator.replaceTo(
                      context: context,
                      screen: SaveScreen(
                        aRRIVALWAREHOUSE: widget.aRRIVALWAREHOUSE,
                        bIN: widget.bIN,
                        cLASSIFICATION: widget.cLASSIFICATION,
                        cONTAINERID: widget.cONTAINERID,
                        createdDateTime: widget.createdDateTime,
                        gTIN: widget.gTIN,
                        iTEMID: widget.iTEMID,
                        iTEMNAME: widget.iTEMNAME,
                        pALLETCODE: widget.pALLETCODE,
                        pOQTY: widget.pOQTY,
                        pURCHID: widget.pURCHID,
                        rCVDCONFIGID: widget.rCVDCONFIGID,
                        rCVQTY: widget.rCVQTY,
                        rEMAININGQTY: widget.rEMAININGQTY,
                        rEMARKS: widget.rEMARKS,
                        rZONE: widget.rZONE,
                        sERIALNUM: widget.sERIALNUM,
                        sHIPMENTID: widget.sHIPMENTID,
                        length: double.parse(
                            _lengthController.text.trim().toString()),
                        width: double.parse(
                            _widthController.text.trim().toString()),
                        height: double.parse(
                            _heightController.text.trim().toString()),
                        weight: double.parse(
                            _weightController.text.trim().toString()),
                      ),
                    );
                  },
                ).box.width(context.width * 0.9).make(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

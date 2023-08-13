import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/controllers/Receiving/supplier_receipt/GetShipmentDataController.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/widgets/loading/loading_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text/text_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text_field/text_form_field_widget.dart';
import 'package:gtrack_mobile_app/models/reveiving/supplier_receipt/DummyModel.dart';

import 'scan_serial_number_screen.dart';

int rCQTY = 0;

class ShipmentDispatchingScreen extends StatefulWidget {
  const ShipmentDispatchingScreen({super.key});

  @override
  State<ShipmentDispatchingScreen> createState() =>
      _ShipmentDispatchingScreenState();
}

class _ShipmentDispatchingScreenState extends State<ShipmentDispatchingScreen> {
  final TextEditingController _shipmentIdController = TextEditingController();
  final TextEditingController _filterController = TextEditingController();
  String total = "0";
  List<bool> isMarked = [];
  List<DummyModel> table = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Supplier Receipt".toUpperCase())),
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
                  text: "Shipment ID*",
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
                        controller: _shipmentIdController,
                        width: MediaQuery.of(context).size.width * 0.73,
                        onEditingComplete: () {
                          // hide keyboard
                          FocusScope.of(context).unfocus();
                          const LoadingWidget();
                          GetShipmentDataController.getShipmentData(
                                  _shipmentIdController.text.trim())
                              .then((value) {
                            setState(() {
                              table = value;
                              total = table.length.toString();
                              isMarked = List<bool>.filled(table.length, false);
                            });
                            Navigator.pop(context);
                          }).onError((error, stackTrace) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(error
                                    .toString()
                                    .replaceAll("Exception:", ""))));
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
                          const LoadingWidget();
                          GetShipmentDataController.getShipmentData(
                                  _shipmentIdController.text.trim())
                              .then((value) {
                            setState(() {
                              table = value;
                              total = table.length.toString();
                              isMarked = List<bool>.filled(table.length, false);
                              Navigator.pop(context);
                            });
                          }).onError((error, stackTrace) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(error
                                    .toString()
                                    .replaceAll("Exception:", ""))));
                          });
                        },
                        child: Image.asset('assets/finder.png',
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: 60,
                            fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
              ),
              total != "0"
                  ? Container(
                      margin: const EdgeInsets.only(left: 20, top: 10),
                      child: const TextWidget(
                        text: " Filter By Container ID*",
                        fontSize: 16,
                      ),
                    )
                  : Container(),
              total != "0"
                  ? Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: TextFormFieldWidget(
                        controller: _filterController,
                        width: MediaQuery.of(context).size.width * 0.9,
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                          // Filter by Container Id
                          setState(() {
                            table = table
                                .where((element) => element.cONTAINERID!
                                    .contains(_filterController.text.trim()))
                                .toList();
                            total = table.length.toString();
                            isMarked = List<bool>.filled(table.length, false);
                          });
                        },
                      ),
                    )
                  : Container(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 10),
                    child: const TextWidget(
                      text: "Shipment Details*",
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      const TextWidget(
                        text: "TOTAL",
                        fontSize: 16,
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 50,
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
                ],
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
                          (states) => AppColors.primary),
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
                          'PURCH ID',
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
                          'SHIPMENT ID',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'SHIPMENT STATUS',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                        DataColumn(
                            label: Text(
                          'CONTAINER ID',
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
                          'QTY',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                      ],
                      rows: table.map((e) {
                        return DataRow(
                            onSelectChanged: (value) {
                              // keybord hide
                              FocusScope.of(context).requestFocus(FocusNode());
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return ScanSerialNumberScreen(
                                  containerId: e.cONTAINERID ?? "",
                                  itemId: e.iTEMID ?? "",
                                  qty: e.qTY ?? 0,
                                  shipmentId: e.sHIPMENTID ?? "",
                                  shipmentStatus:
                                      int.parse(e.sHIPMENTSTATUS.toString()),
                                  purchId: e.pURCHID ?? "",
                                  createdDateTime: e.cREATEDDATETIME ?? "",
                                );
                              }));
                            },
                            cells: [
                              DataCell(Text((table.indexOf(e) + 1).toString())),
                              DataCell(Text(e.pURCHID ?? "")),
                              DataCell(Text(e.cREATEDDATETIME ?? "")),
                              DataCell(Text(e.sHIPMENTID ?? "")),
                              DataCell(Text(e.sHIPMENTSTATUS.toString())),
                              DataCell(Text(e.cONTAINERID ?? "")),
                              DataCell(Text(e.iTEMID ?? "")),
                              DataCell(Text(e.qTY.toString())),
                            ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

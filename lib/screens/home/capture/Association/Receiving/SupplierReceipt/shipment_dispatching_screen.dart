import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_images.dart';
import 'package:gtrack_mobile_app/controllers/Receiving/supplier_receipt/GetShipmentDataController.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_dialogs.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_snakbars.dart';
import 'package:gtrack_mobile_app/global/widgets/text/text_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text_field/text_form_field_widget.dart';
import 'package:gtrack_mobile_app/models/reveiving/supplier_receipt/GetShipmentDataFromShipmentExpectedRModel.dart';

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
  List<GetShipmentDataFromShipmentExpectedRModel> table = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Supplier Receipt".toUpperCase(),
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.pink,
      ),
      body: SingleChildScrollView(
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
                      child: Image.asset(AppImages.finder,
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
              height: MediaQuery.of(context).size.height * 0.6,
              margin: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.grey,
                  width: 1,
                ),
              ),
              child: PaginatedDataTable(
                rowsPerPage: 5,
                columns: const [
                  DataColumn(
                      label: Text(
                    'SHIPMENT ID',
                    style: TextStyle(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                      label: Text(
                    'CONTAINER ID',
                    style: TextStyle(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                      label: Text(
                    'ARRIVAL WAREHOUSE',
                    style: TextStyle(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                      label: Text(
                    'ITEM NAME',
                    style: TextStyle(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                      label: Text(
                    'ITEM ID',
                    style: TextStyle(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                      label: Text(
                    'PURCH ID',
                    style: TextStyle(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                      label: Text(
                    'CLASSIFICATION',
                    style: TextStyle(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                      label: Text(
                    'SERIAL NUM',
                    style: TextStyle(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                      label: Text(
                    'RCVD CONFIG ID',
                    style: TextStyle(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                      label: Text(
                    'GTIN',
                    style: TextStyle(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                      label: Text(
                    'RZONE',
                    style: TextStyle(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                      label: Text(
                    'PALLET CODE',
                    style: TextStyle(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                      label: Text(
                    'BIN',
                    style: TextStyle(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                      label: Text(
                    'REMARKS',
                    style: TextStyle(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                      label: Text(
                    'PO QTY',
                    style: TextStyle(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                      label: Text(
                    'RCV QTY',
                    style: TextStyle(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                      label: Text(
                    'REMAINING QTY',
                    style: TextStyle(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                      label: Text(
                    'TRX DATE TIME',
                    style: TextStyle(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  )),
                ],
                source: TableDataSource(table, context),
                showCheckboxColumn: false,
                showFirstLastButtons: true,
                arrowHeadColor: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void onSearch() async {
    FocusScope.of(context).unfocus();
    AppDialogs.loadingDialog(context);
    GetShipmentDataController.getShipmentData(_shipmentIdController.text.trim())
        .then((value) {
      setState(() {
        table = value;
        total = table.length.toString();
        isMarked = List<bool>.filled(table.length, false);
      });
      AppDialogs.closeDialog();
    }).onError((error, stackTrace) {
      AppDialogs.closeDialog();
      AppSnackbars.normal(
          context, error.toString().replaceAll("Exception:", ""));
    });
  }
}

class TableDataSource extends DataTableSource {
  List<GetShipmentDataFromShipmentExpectedRModel> data;
  BuildContext ctx;

  TableDataSource(
    this.data,
    this.ctx,
  );

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final instance = data[index];

    return DataRow.byIndex(
      index: index,
      onSelectChanged: (value) {
        FocusScope.of(ctx).requestFocus(FocusNode());
        AppNavigator.goToPage(
          context: ctx,
          screen: ScanSerialNumberScreen(
            aRRIVALWAREHOUSE: instance.aRRIVALWAREHOUSE ?? "",
            bIN: instance.bIN ?? "",
            cLASSIFICATION: instance.cLASSIFICATION ?? "",
            cONTAINERID: instance.cONTAINERID ?? "",
            gTIN: instance.gTIN ?? "",
            iTEMID: instance.iTEMID ?? "",
            iTEMNAME: instance.iTEMNAME ?? "",
            pALLETCODE: instance.pALLETCODE ?? "",
            pOQTY: instance.pOQTY ?? 0,
            pURCHID: instance.pURCHID ?? "",
            rCVDCONFIGID: instance.rCVDCONFIGID ?? "",
            rCVQTY: instance.rCVQTY ?? 0,
            rEMAININGQTY: instance.rEMAININGQTY ?? 0,
            rEMARKS: instance.rEMARKS ?? "",
            rZONE: instance.rZONE ?? "",
            sERIALNUM: instance.sERIALNUM ?? "",
            sHIPMENTID: instance.sHIPMENTID ?? "",
            createdDateTime: instance.tRXDATETIME ?? "",
            totalRows: data.length,
          ),
        );
      },
      cells: [
        DataCell(SelectableText(instance.sHIPMENTID ?? "")),
        DataCell(SelectableText(instance.cONTAINERID ?? "")),
        DataCell(SelectableText(instance.aRRIVALWAREHOUSE ?? "")),
        DataCell(SelectableText(instance.iTEMNAME ?? "")),
        DataCell(SelectableText(instance.iTEMID ?? "")),
        DataCell(SelectableText(instance.pURCHID ?? "")),
        DataCell(SelectableText(instance.cLASSIFICATION ?? "")),
        DataCell(SelectableText(instance.sERIALNUM ?? "")),
        DataCell(SelectableText(instance.rCVDCONFIGID ?? "")),
        DataCell(SelectableText(instance.gTIN ?? "")),
        DataCell(SelectableText(instance.rZONE ?? "")),
        DataCell(SelectableText(instance.pALLETCODE ?? "")),
        DataCell(SelectableText(instance.bIN ?? "")),
        DataCell(SelectableText(instance.rEMARKS ?? "")),
        DataCell(SelectableText(instance.pOQTY.toString() == "null"
            ? "0"
            : instance.pOQTY.toString())),
        DataCell(Text(instance.rCVQTY.toString() == "null"
            ? "0"
            : instance.rCVQTY.toString())),
        DataCell(Text(instance.rEMAININGQTY.toString() == "null"
            ? "0"
            : instance.rEMAININGQTY.toString())),
        DataCell(Text(instance.tRXDATETIME ?? "")),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

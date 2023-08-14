import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_images.dart';
import 'package:gtrack_mobile_app/controllers/Receiving/supplier_receipt/GetShipmentDataController.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_dialogs.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_snakbars.dart';
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
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: PaginatedDataTable(
                  rowsPerPage: 5,
                  columns: const [
                    DataColumn(
                        label: Text(
                      'PURCH ID',
                      style: TextStyle(color: AppColors.primary),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'CREATED DATE TIME',
                      style: TextStyle(color: AppColors.primary),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'SHIPMENT ID',
                      style: TextStyle(color: AppColors.primary),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'SHIPMENT STATUS',
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
                      'ITEM ID',
                      style: TextStyle(color: AppColors.primary),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'QTY',
                      style: TextStyle(color: Colors.white),
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
      AppSnackbars.danger(context, error.toString());
    });
  }
}

class TableDataSource extends DataTableSource {
  List<DummyModel> data;
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
              containerId: instance.cONTAINERID ?? "",
              itemId: instance.iTEMID ?? "",
              qty: instance.qTY ?? 0,
              shipmentId: instance.sHIPMENTID ?? "",
              shipmentStatus: int.parse(instance.sHIPMENTSTATUS.toString()),
              purchId: instance.pURCHID ?? "",
              createdDateTime: instance.cREATEDDATETIME ?? "",
            ));
      },
      cells: [
        DataCell(Text(instance.pURCHID ?? "")),
        DataCell(Text(instance.cREATEDDATETIME ?? "")),
        DataCell(Text(instance.sHIPMENTID ?? "")),
        DataCell(Text(instance.sHIPMENTSTATUS.toString())),
        DataCell(Text(instance.cONTAINERID ?? "")),
        DataCell(Text(instance.iTEMID ?? "")),
        DataCell(Text(instance.qTY.toString())),
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

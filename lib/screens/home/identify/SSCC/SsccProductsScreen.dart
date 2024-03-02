import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/controllers/Identify/SSCC/SsccController.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_dialogs.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_snakbars.dart';
import 'package:gtrack_mobile_app/models/Identify/SSCC/SsccProductsModel.dart';

class SsccProductsScreen extends StatefulWidget {
  const SsccProductsScreen({super.key});

  @override
  State<SsccProductsScreen> createState() => _SsccProductsScreenState();
}

class _SsccProductsScreenState extends State<SsccProductsScreen> {
  String total = "0";
  List<bool> isMarked = [];
  List<SsccProductsModel> table = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      onSearch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SSCC Products".toUpperCase(),
        ),
        backgroundColor: AppColors.skyBlue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              margin: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.grey,
                  width: 1,
                ),
              ),
              child: PaginatedDataTable(
                rowsPerPage: 10,
                columns: const [
                  DataColumn(
                      label: Text(
                    'SSCC ID',
                    style: TextStyle(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                      label: Text(
                    'Type',
                    style: TextStyle(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                      label: Text(
                    'SSCC Barcode Number',
                    style: TextStyle(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  )),
                ],
                source: TableDataSource(table, context),
                showCheckboxColumn: false,
                showFirstLastButtons: true,
                arrowHeadColor: AppColors.skyBlue,
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
    SsccController.getProducts().then((value) {
      setState(() {
        table = value;
        total = table.length.toString();
        isMarked = List<bool>.filled(table.length, false);
      });
      AppDialogs.closeDialog();
    }).onError((error, stackTrace) {
      AppDialogs.closeDialog();
      AppSnackbars.danger(
          context, error.toString().replaceAll("Exception:", ""));
    });
  }
}

class TableDataSource extends DataTableSource {
  List<SsccProductsModel> data;
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
      onSelectChanged: (value) {},
      cells: [
        DataCell(Text(instance.ssccId.toString() == "null"
            ? "0"
            : instance.ssccId.toString())),
        DataCell(Text(instance.type ?? "")),
        DataCell(Text(instance.sSCCBarcodeNumber ?? "")),
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

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/controllers/Identify/SSCC/SsccController.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_dialogs.dart';
import 'package:gtrack_mobile_app/models/Identify/SSCC/SsccProductsModel.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nb_utils/nb_utils.dart';

class SsccProductsScreen extends StatefulWidget {
  const SsccProductsScreen({super.key});

  @override
  State<SsccProductsScreen> createState() => _SsccProductsScreenState();
}

class _SsccProductsScreenState extends State<SsccProductsScreen> {
  String total = "0";
  List<bool> isMarked = [];
  List<SsccProductsModel> table = [];

  TextEditingController searchController = TextEditingController();

  String? userId, gcp, memberCategoryDescription;

  @override
  void initState() {
    super.initState();
    AppPreferences.getUserId().then((value) => userId = value);
    AppPreferences.getGcp().then((value) => gcp = value);
    AppPreferences.getMemberCategoryDescription()
        .then((value) => memberCategoryDescription = value);
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
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Member ID",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    gcp.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/add_Icon.png',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Ionicons.search_outline),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "SSCC List",
                    style: TextStyle(fontSize: 18),
                  ),
                  Icon(
                    Ionicons.filter_outline,
                    size: 30,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            PaginatedDataTable(
              rowsPerPage: 5,
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
      toast(error.toString().replaceAll("Exception:", ""));
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

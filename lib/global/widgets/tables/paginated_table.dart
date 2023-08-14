import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';

class PaginatedTable extends StatelessWidget {
  final List<String> columns;
  final List<String> cells;
  const PaginatedTable({
    Key? key,
    required this.columns,
    required this.cells,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: PaginatedDataTable(
        rowsPerPage: 5,
        columns: columns.map((e) => DataColumn(label: Text(e))).toList(),
        source: DataSource(context, cells),
        showCheckboxColumn: false,
        showFirstLastButtons: true,
        arrowHeadColor: AppColors.primary,
      ),
    );
  }
}

class DataSource extends DataTableSource {
  final List<String> cells;
  BuildContext ctx;

  DataSource(
    this.ctx,
    this.cells,
  );

  @override
  DataRow? getRow(int index) {
    if (index >= cells.length) {
      return null;
    }

    return DataRow.byIndex(
      index: index,
      onSelectChanged: (value) {
        FocusScope.of(ctx).requestFocus(FocusNode());
        // AppNavigator.goToPage(
        //     context: ctx,
        //     screen: ScanSerialNumberScreen(
        //       containerId: student.cONTAINERID ?? "",
        //       itemId: student.iTEMID ?? "",
        //       qty: student.qTY ?? 0,
        //       shipmentId: student.sHIPMENTID ?? "",
        //       shipmentStatus: int.parse(student.sHIPMENTSTATUS.toString()),
        //       purchId: student.pURCHID ?? "",
        //       createdDateTime: student.cREATEDDATETIME ?? "",
        //     ));
      },
      cells: cells.map((e) => DataCell(Text(e))).toList(),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => cells.length;

  @override
  int get selectedRowCount => 0;
}

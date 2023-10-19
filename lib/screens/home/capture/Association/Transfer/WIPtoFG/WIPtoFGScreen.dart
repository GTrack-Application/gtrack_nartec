import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/global/common/colors/app_colors.dart';
import 'package:gtrack_mobile_app/global/widgets/ElevatedButtonWidget.dart';
import 'package:gtrack_mobile_app/global/widgets/text/text_widget.dart';
import 'package:gtrack_mobile_app/global/widgets/text_field/text_form_field_widget.dart';
import 'package:gtrack_mobile_app/models/IDENTIFY/SSCC/SsccProductsModel.dart';

class WIPtoFGScreen extends StatefulWidget {
  const WIPtoFGScreen({super.key});

  @override
  State<WIPtoFGScreen> createState() => _WIPtoFGScreenState();
}

class _WIPtoFGScreenState extends State<WIPtoFGScreen> {
  final TextEditingController locationToController = TextEditingController();

  String total = "0";
  List<bool> isMarked = [];
  List<SsccProductsModel> table = [];

  String? dropDownValue = "Raw Material Warehouse";
  List<String> dropDownList = [
    "Raw Material Warehouse",
    "Plant Factory",
    "Finished Goods Warehouse",
    "Distribution Center",
  ];

  String? userId;

  void getCurrentUserId() {
    AppPreferences.getUserId().then((value) {
      setState(() {
        userId = value;
      });
    });
  }

  @override
  void initState() {
    getCurrentUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pink,
        title: const Text('WIP to FG'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                color: AppColors.pink.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TextWidget(
                      text: "Current Logged In User: ",
                      fontSize: 16,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: TextWidget(
                        text: userId ?? "",
                        fontSize: 16,
                        color: AppColors.pink,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
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
                  arrowHeadColor: AppColors.pink,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: const TextWidget(
                  text: "Scan Bin (FROM)*",
                  fontSize: 16,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.only(left: 20),
                child: DropdownSearch<String>(
                  filterFn: (item, filter) {
                    return item.toLowerCase().contains(filter.toLowerCase());
                  },
                  enabled: true,
                  dropdownButtonProps: const DropdownButtonProps(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                  ),
                  items: dropDownList,
                  onChanged: (value) {
                    setState(() {
                      dropDownValue = value!;
                    });
                  },
                  selectedItem: dropDownValue,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: TextWidget(
                  text: "Scan Location To*",
                  color: Colors.blue[900]!,
                  fontSize: 15,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: TextFormFieldWidget(
                  controller: locationToController,
                  readOnly: false,
                  hintText: "Enter/Scan Location To",
                  width: MediaQuery.of(context).size.width * 0.9,
                  onEditingComplete: () {},
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButtonWidget(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.9,
                  title: "Complete",
                  onPressed: () {},
                  textColor: Colors.white,
                  color: AppColors.pink,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
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

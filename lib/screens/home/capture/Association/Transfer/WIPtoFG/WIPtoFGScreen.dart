// ignore_for_file: file_names, use_build_context_synchronously

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/features/capture/cubits/association/transfer/wip_to_fg_bloc.dart';
import 'package:gtrack_nartec/blocs/global/global_states_events.dart';
import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/features/capture/controllers/Association/Transfer/RawMaterialsToWIP/GetSalesPickingListCLRMByAssignToUserAndVendorController.dart';
import 'package:gtrack_nartec/features/capture/controllers/Association/Transfer/WIPtoFG/wip_to_fg_controller.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_dialogs.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/global/widgets/ElevatedButtonWidget.dart';
import 'package:gtrack_nartec/global/widgets/text/text_widget.dart';
import 'package:gtrack_nartec/global/widgets/text_field/text_form_field_widget.dart';
import 'package:gtrack_nartec/features/capture/models/Association/Transfer/WipToFG/get_items_ln_wips_model.dart';

class WIPtoFGScreen extends StatefulWidget {
  const WIPtoFGScreen({super.key});

  @override
  State<WIPtoFGScreen> createState() => _WIPtoFGScreenState();
}

class _WIPtoFGScreenState extends State<WIPtoFGScreen> {
  final TextEditingController locationToController = TextEditingController();
  WipToFGBloc wipToFGBloc = WipToFGBloc();

  String total = "0";
  List<bool> isMarked = [];
  List<GetItemsLnWipsModel> tableData = [];

  String? dropDownValue = "Raw Material Warehouse";
  List<String> dropDownList = [
    "Raw Material Warehouse",
    "Plant Factory",
    "Finished Goods Warehouse",
    "Distribution Center",
  ];

  List<String> tableHeaders = [
    'Id',
    'Item Id',
    'Item Name',
    'Available Quantity',
    'Item Group Id',
    'Locations',
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
    initBloc();
    super.initState();
  }

  initBloc() {
    wipToFGBloc = wipToFGBloc..add(GlobalInitEvent());
  }

  getRecords(String location, String mainLocation) {
    return tableData.map((e) {
      return {
        "itemcode": e.itemId,
        "itemdesc": e.itemName,
        "binlocation": location,
        "trans": e.availableQuantity,
        "mainlocation": mainLocation
      };
    }).toList();
  }

  insertRecord() async {
    if (locationToController.text.trim().isEmpty || dropDownValue == null) {
      AppSnackbars.danger(context, "Please enter location");
      return;
    }

    AppDialogs.loadingDialog(context);
    WIPToFgController.insertManyIntoMappedBarcode(
      getRecords(
        locationToController.text.trim(),
        dropDownValue.toString(),
      ),
    ).then((value) {
      RawMaterialsToWIPController.insertEPCISEvent(
        "OBSERVE", // OBSERVE, ADD, DELETE
        tableData.length,
        "TRANSFER EVENT",
        "Internal Transfer",
        "Transfer",
        "urn:epc:id:sgln:6285084.00002.1",
        tableData[0].id!.toString(),
        tableData[0].itemId!.toString(),
      ).then((value) {
        AppDialogs.closeDialog();
        AppSnackbars.normal(context, 'Successfully Inserted');
      }).onError((error1, stackTrace) {
        AppDialogs.closeDialog();
        AppSnackbars.danger(
            context, error1.toString().replaceAll("Exception:", ""));
      });
      setState(() {
        locationToController.clear();
      });
      AppSnackbars.normal(context, 'Successfully Inserted');
    }).onError((error2, stackTrace) {
      AppDialogs.closeDialog();
      // AppSnackbars.danger(
      //     context, error2.toString().replaceAll("Exception:", ""));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pink,
        title: const Text('WIP to FG'),
      ),
      body: BlocConsumer<WipToFGBloc, GlobalState>(
        bloc: wipToFGBloc,
        listener: (context, state) {
          if (state is GlobalLoadedState) {
            tableData = state.data;
          }
        },
        builder: (context, state) {
          if (state is GlobalLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GlobalErrorState) {
            return SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                TextWidget(text: state.message),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButtonWidget(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.9,
                    title: "Retry",
                    onPressed: () {
                      wipToFGBloc.add(GlobalInitEvent());
                    },
                    textColor: Colors.white,
                    color: AppColors.pink,
                  ),
                ),
              ],
            ));
          } else {
            return SafeArea(
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
                        columns: tableHeaders.map((e) {
                          return DataColumn(
                              label: Text(
                            e,
                            style: const TextStyle(color: AppColors.primary),
                            textAlign: TextAlign.center,
                          ));
                        }).toList(),
                        source: TableDataSource(tableData, context),
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
                          return item
                              .toLowerCase()
                              .contains(filter.toLowerCase());
                        },
                        enabled: true,
                        popupProps: const PopupProps.menu(),
                        // items: dropDownList,
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
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButtonWidget(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.9,
                        title: "Complete",
                        onPressed: () async {
                          await insertRecord();
                        },
                        textColor: Colors.white,
                        color: AppColors.pink,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class TableDataSource extends DataTableSource {
  List<GetItemsLnWipsModel> data;
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
        DataCell(Text(
            instance.id.toString() == "null" ? "0" : instance.id.toString())),
        DataCell(Text(instance.itemId ?? "")),
        DataCell(Text(instance.itemName ?? "")),
        DataCell(Text(instance.availableQuantity.toString() == "null"
            ? "0"
            : instance.availableQuantity.toString())),
        DataCell(Text(instance.itemGroupId ?? "")),
        DataCell(Text(instance.locations ?? "")),
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

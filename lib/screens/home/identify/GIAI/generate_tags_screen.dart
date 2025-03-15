import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/widgets/buttons/primary_button.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/cubit/fats_cubit.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/cubit/fats_state.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/model/generate_tag_model.dart';

class GenerateTagsScreen extends StatefulWidget {
  const GenerateTagsScreen({super.key});

  @override
  State<GenerateTagsScreen> createState() => _GenerateTagsScreenState();
}

class _GenerateTagsScreenState extends State<GenerateTagsScreen> {
  final FatsCubit fatsCubit = FatsCubit();
  List<GenerateTagsModel> tags = [];

  @override
  void initState() {
    super.initState();
    fatsCubit.getTags();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.skyBlue,
        title: const Text('Generate Tags'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<FatsCubit, FatsState>(
            bloc: fatsCubit,
            listener: (context, state) {
              if (state is FatsGetTagsLoaded) {
                tags = state.tags;
              } else if (state is FatsGetTagsError) {
                tags = [];
              } else if (state is FatsGenerateTagsLoaded) {
                fatsCubit.getTags();
              } else if (state is FatsGenerateTagsError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message
                          .replaceAll('Exception:', '')
                          .replaceAll("Exception", ""),
                    ),
                    backgroundColor: AppColors.danger,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(10),
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Generate Asset Tags',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PrimaryButtonWidget(
                        text: "Generate Tag",
                        height: 35,
                        width: 150,
                        backgroundColor: AppColors.skyBlue,
                        onPressed: () {
                          fatsCubit.generateTags();
                        },
                        isLoading: state is FatsGenerateTagsLoading,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  PaginatedDataTable(
                    source: _TagDataSource(tags),
                    columns: const [
                      DataColumn(label: Text('No.')),
                      DataColumn(label: Text('Tag Number')),
                      DataColumn(label: Text('Major Category')),
                      DataColumn(label: Text('Major Category Description')),
                      DataColumn(label: Text('Minor Category')),
                      DataColumn(label: Text('Minor Category Description')),
                      DataColumn(label: Text('Serial No')),
                      DataColumn(label: Text('Asset Description')),
                      DataColumn(label: Text('Asset Type')),
                      DataColumn(label: Text('Asset Condition')),
                      DataColumn(label: Text('Manufacturer')),
                      DataColumn(label: Text('Created At')),
                      DataColumn(label: Text('Updated At')),
                    ],
                    rowsPerPage: 10,
                    header: const Text(
                      'Asset Tags',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    headingRowColor: WidgetStateProperty.all(Colors.white),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TagDataSource extends DataTableSource {
  final List<GenerateTagsModel> _data;

  _TagDataSource(this._data);

  @override
  DataRow getRow(int index) {
    final item = _data[index];
    return DataRow(cells: [
      DataCell(Text((index + 1).toString())),
      DataCell(Text(item.tagNumber ?? '')),
      DataCell(Text(item.majorCategory ?? '')),
      DataCell(Text(item.majorCategoryDescription ?? '')),
      DataCell(Text(item.minorCategory ?? '')),
      DataCell(Text(item.minorCategoryDescription ?? '')),
      DataCell(Text(item.serialNumber ?? '')),
      DataCell(Text(item.assetDescription ?? '')),
      DataCell(Text(item.assetType ?? '')),
      DataCell(Text(item.assetCondition ?? '')),
      DataCell(Text(item.manufacturer ?? '')),
      DataCell(Text(item.createdAt ?? '')),
      DataCell(Text(item.updatedAt ?? '')),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}

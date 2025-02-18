import 'package:flutter/material.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';

class GenerateTagsScreen extends StatefulWidget {
  const GenerateTagsScreen({super.key});

  @override
  State<GenerateTagsScreen> createState() => _GenerateTagsScreenState();
}

class _GenerateTagsScreenState extends State<GenerateTagsScreen> {
  final int _rowsPerPage = 10;
  int _currentPage = 0;
  final List<Map<String, String>> _sampleData = List.generate(
    50,
    (index) => {
      'no': (index + 1).toString(),
      'itemCode': 'ITEM${index + 1}',
      'description': 'Description for item ${index + 1}',
    },
  );

  List<TableRow> _getCurrentPageRows() {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (startIndex + _rowsPerPage).clamp(0, _sampleData.length);

    return [
      const TableRow(
        children: [
          TableCell(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('No.'),
            ),
          ),
          TableCell(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Item Code'),
            ),
          ),
          TableCell(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Description'),
            ),
          ),
        ],
      ),
      ..._sampleData
          .sublist(startIndex, endIndex)
          .map(
            (data) => TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(data['no']!),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(data['itemCode']!),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(data['description']!),
                  ),
                ),
              ],
            ),
          )
          .toList(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (_sampleData.length / _rowsPerPage).ceil();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.skyBlue,
        title: const Text('Generate Tags'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Generate Asset Tags'),
                FilledButton(
                  onPressed: () {
                    // Add your generate tag logic here
                  },
                  child: const Text('Generate Tag'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  border: TableBorder.all(),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2),
                  },
                  children: _getCurrentPageRows(),
                ),
              ),
            ),
            // Pagination controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _currentPage > 0
                      ? () => setState(() => _currentPage--)
                      : null,
                ),
                Text('${_currentPage + 1} / $totalPages'),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _currentPage < totalPages - 1
                      ? () => setState(() => _currentPage++)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

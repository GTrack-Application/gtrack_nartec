import 'package:flutter/material.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/models/capture/Association/Mapping/BinToBinAxapta/GetAxaptaTableModel.dart';

class BinToBinDetailsScreen extends StatefulWidget {
  const BinToBinDetailsScreen({super.key, required this.employees});

  final GetAxaptaTableDataModel employees;

  @override
  State<BinToBinDetailsScreen> createState() => _BinToBinDetailsScreenState();
}

class _BinToBinDetailsScreenState extends State<BinToBinDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.pink,
                    AppColors.pink.withOpacity(0.5),
                    Colors.pinkAccent.withOpacity(0.1),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 40,
              decoration: const BoxDecoration(
                // gradient color
                color: AppColors.pink,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Text(
                    'Product Information',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 50),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: MediaQuery.of(context).size.width * 0.98,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  KeyValueInfoWidget(
                    keyy: 'Item ID',
                    value: widget.employees.iTEMID ?? "null",
                  ),
                  KeyValueInfoWidget(
                    keyy: 'Group ID',
                    value: widget.employees.gROUPID ?? "null",
                  ),
                  KeyValueInfoWidget(
                    keyy: 'QTY Received',
                    value: widget.employees.qTYRECEIVED.toString(),
                  ),
                  KeyValueInfoWidget(
                    keyy: 'QTY Transfer',
                    value: widget.employees.qTYTRANSFER.toString(),
                  ),
                  KeyValueInfoWidget(
                    keyy: 'Transfer Status',
                    value: widget.employees.tRANSFERSTATUS.toString(),
                  ),
                  KeyValueInfoWidget(
                    keyy: 'Invent Location ID To',
                    value: widget.employees.iNVENTLOCATIONIDTO ?? "null",
                  ),
                  KeyValueInfoWidget(
                    keyy: 'Invent Location ID From',
                    value: widget.employees.iNVENTLOCATIONIDFROM ?? "null",
                  ),
                  KeyValueInfoWidget(
                    keyy: 'Created Date Time',
                    value: widget.employees.cREATEDDATETIME ?? "null",
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class KeyValueInfoWidget extends StatelessWidget {
  const KeyValueInfoWidget({
    super.key,
    required this.keyy,
    required this.value,
  });

  final String keyy;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.all(2),
              color: AppColors.primary,
              child: Text(
                keyy,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.only(right: 10),
              color: Colors.grey.withOpacity(0.4),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

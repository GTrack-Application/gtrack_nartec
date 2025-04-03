import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/capture_cubit.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/global/widgets/loading/loading_widget.dart';
import 'package:gtrack_nartec/models/capture/mapping/mapped_barcode_request_model.dart';
import 'package:gtrack_nartec/models/capture/mapping/stock_master_model.dart';
import 'package:intl/intl.dart';

class BarcodeMappingScreen extends StatefulWidget {
  const BarcodeMappingScreen({super.key});

  @override
  State<BarcodeMappingScreen> createState() => _BarcodeMappingScreenState();
}

class _BarcodeMappingScreenState extends State<BarcodeMappingScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _serialController = TextEditingController();
  final TextEditingController _gtinController = TextEditingController();
  final TextEditingController _manufactureController = TextEditingController();
  final TextEditingController _qrCodeController = TextEditingController();
  final TextEditingController _binLocationController = TextEditingController();
  final TextEditingController _batchController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();

  StockMasterModel? selectedItem;
  bool isLoading = false;
  late final CaptureCubit _captureCubit;

  @override
  void initState() {
    super.initState();
    _captureCubit = context.read<CaptureCubit>();
    _captureCubit.getStockMasterByItemName(null);
    _manufactureController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _serialController.dispose();
    _gtinController.dispose();
    _manufactureController.dispose();
    _qrCodeController.dispose();
    _binLocationController.dispose();
    _batchController.dispose();
    _expiryController.dispose();
    super.dispose();
  }

  void _searchItem() {
    if (_searchController.text.isNotEmpty) {
      _captureCubit.getStockMasterByItemName(_searchController.text);
    }
  }

  void _prefillFormIfDataExists(StockMasterModel item) {
    setState(() {
      selectedItem = item;
      _gtinController.text = item.gtin ?? '';
      _binLocationController.text = item.binLocation ?? '';

      if (item.expiryDate != null && item.expiryDate!.isNotEmpty) {
        _expiryController.text = item.expiryDate!;
      }

      if (item.batchNo != null && item.batchNo!.isNotEmpty) {
        _batchController.text = item.batchNo!;
      }
    });
  }

  void _saveBarcode() {
    if (_serialController.text.isEmpty ||
        _gtinController.text.isEmpty ||
        _binLocationController.text.isEmpty) {
      AppSnackbars.normal(context, 'Please fill all required fields');
      return;
    }

    if (selectedItem == null) {
      AppSnackbars.normal(context, 'Please search and select an item first');
      return;
    }

    // Create request model
    final mappedBarcode = MappedBarcodeRequestModel(
      itemCode: selectedItem?.itemCode ?? '',
      itemDesc: selectedItem?.itemDesc ?? '',
      gtin: _gtinController.text,
      mainLocation: selectedItem?.mainLocation ?? 'WAREHOUSE-A',
      binLocation: _binLocationController.text,
      length: double.tryParse(selectedItem!.length ?? '10.5') ?? 10.5,
      width: double.tryParse(selectedItem!.width ?? '5.2') ?? 5.2,
      height: double.tryParse(selectedItem!.height ?? '3.1') ?? 3.1,
      weight: double.tryParse(selectedItem!.weight ?? '2.5') ?? 2.5,
      trans: 100,
      expiryDate: _expiryController.text.isNotEmpty
          ? _expiryController.text
          : "2025-12-31",
      batchNo:
          _batchController.text.isNotEmpty ? _batchController.text : "123123",
    );

    _captureCubit.createMappedBarcode(mappedBarcode);
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pink,
        title: const Text('Barcode Mapping',
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<CaptureCubit, CaptureState>(
        listener: (context, state) {
          if (state is CaptureStockMasterSuccess) {
            if (state.data.isNotEmpty) {
              _prefillFormIfDataExists(state.data.first);
            }
          } else if (state is CaptureStockMasterEmpty) {
            AppSnackbars.normal(context, 'No items found with this name');
          } else if (state is CaptureStockMasterError) {
            AppSnackbars.danger(context, state.message);
          } else if (state is CaptureCreateMappedBarcodeSuccess) {
            AppSnackbars.success(context, state.message);
            // Clear form
            _serialController.clear();
            _searchController.clear();
            Navigator.pop(context);
          } else if (state is CaptureCreateMappedBarcodeError) {
            AppSnackbars.danger(context, state.message);
          }
        },
        builder: (context, state) {
          bool isLoading = state is CaptureStockMasterLoading ||
              state is CaptureCreateMappedBarcodeLoading;

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  hintText:
                                      'Search Item Number or Description here',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 16),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: _searchItem,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Scan Serial
                      const Text('Scan Serial*',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _serialController,
                        decoration: InputDecoration(
                          hintText: 'Scan Serial',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Scan GTIN
                      const Text('Scan GTIN*',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _gtinController,
                        decoration: InputDecoration(
                          hintText: 'Scan GTIN',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Manufacturing Date and QR Code
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Manufacturing Date',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                TextField(
                                  controller: _manufactureController,
                                  readOnly: true,
                                  onTap: () =>
                                      _selectDate(_manufactureController),
                                  decoration: InputDecoration(
                                    hintText: 'mm/dd/yyyy',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    suffixIcon:
                                        const Icon(Icons.calendar_today),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Scan QR Code',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                TextField(
                                  controller: _qrCodeController,
                                  decoration: InputDecoration(
                                    hintText: 'Scan QR Code',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Bin Location
                      const Text('Scan Binlocation*',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _binLocationController,
                        decoration: InputDecoration(
                          hintText: 'Scan Binlocation',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Batch # and Expiry Date
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Batch #',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                TextField(
                                  controller: _batchController,
                                  decoration: InputDecoration(
                                    hintText: 'Scan Binlocation',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Expiry Date',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                TextField(
                                  controller: _expiryController,
                                  readOnly: true,
                                  onTap: () => _selectDate(_expiryController),
                                  decoration: InputDecoration(
                                    hintText: 'mm/dd/yyyy',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    suffixIcon:
                                        const Icon(Icons.calendar_today),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // Cancel and Save Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text('Cancel',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _saveBarcode,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text('Save',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading) const LoadingWidget(),
            ],
          );
        },
      ),
    );
  }
}

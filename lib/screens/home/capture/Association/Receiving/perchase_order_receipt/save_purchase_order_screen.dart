import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/association/receiving/purchase_order_receipt/purchase_order_receipt_cubit.dart';
import 'package:gtrack_nartec/cubit/capture/association/receiving/purchase_order_receipt/purchase_order_receipt_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/purchase_order_receipt/purchase_order_details_model.dart';

class SavePurchaseOrderScreen extends StatefulWidget {
  const SavePurchaseOrderScreen({
    super.key,
    required this.purchaseOrderDetails,
  });

  final PurchaseOrderDetailsModel purchaseOrderDetails;

  @override
  State<SavePurchaseOrderScreen> createState() =>
      _SavePurchaseOrderScreenState();
}

class _SavePurchaseOrderScreenState extends State<SavePurchaseOrderScreen> {
  // Add controllers for text fields
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _batchNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _manufacturingDateController =
      TextEditingController();
  final TextEditingController _netWeightController = TextEditingController();
  final TextEditingController _transportGLNController = TextEditingController();
  final TextEditingController _putAwayLocationController =
      TextEditingController();
  final TextEditingController _receivedByController = TextEditingController();

  // Add FocusNodes
  final FocusNode _quantityFocus = FocusNode();
  final FocusNode _batchNumberFocus = FocusNode();
  final FocusNode _expiryDateFocus = FocusNode();
  final FocusNode _manufacturingDateFocus = FocusNode();
  final FocusNode _netWeightFocus = FocusNode();
  final FocusNode _transportGLNFocus = FocusNode();
  final FocusNode _putAwayLocationFocus = FocusNode();
  final FocusNode _receivedByFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _quantityController.text =
        widget.purchaseOrderDetails.purchaseOrderDetails!.first.quantity ?? '0';
  }

  @override
  void dispose() {
    // Dispose controllers
    _quantityController.dispose();
    _batchNumberController.dispose();
    _expiryDateController.dispose();
    _manufacturingDateController.dispose();
    _netWeightController.dispose();
    _transportGLNController.dispose();
    _putAwayLocationController.dispose();
    _receivedByController.dispose();

    // Dispose focus nodes
    _quantityFocus.dispose();
    _batchNumberFocus.dispose();
    _expiryDateFocus.dispose();
    _manufacturingDateFocus.dispose();
    _netWeightFocus.dispose();
    _transportGLNFocus.dispose();
    _putAwayLocationFocus.dispose();
    _receivedByFocus.dispose();

    super.dispose();
  }

  PurchaseOrderReceiptCubit cubit = PurchaseOrderReceiptCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.pink,
        title: const Text('Save Purchase Order'),
      ),
      body: BlocConsumer<PurchaseOrderReceiptCubit, PurchaseOrderReceiptState>(
        bloc: cubit,
        listener: (context, state) {
          if (state is CreatePurchaseOrderReceiptLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Purchase Order Receipt Created'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          }
          if (state is CreatePurchaseOrderReceiptError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(state.message.replaceAll('Exception:', '').trim()),
                backgroundColor: AppColors.danger,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.grey),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Purchase Order Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.pink,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildInfoColumn(
                            'PO Number',
                            widget.purchaseOrderDetails.purchaseOrderNumber ??
                                ''),
                        const SizedBox(height: 10),
                        _buildInfoColumn(
                            'GDTI', widget.purchaseOrderDetails.gdti ?? ''),
                        const SizedBox(height: 10),
                        _buildInfoColumn('Total Amount',
                            "SAR ${widget.purchaseOrderDetails.totalAmount ?? ''}"),
                        const SizedBox(height: 10),
                        _buildInfoColumn(
                            'Status', widget.purchaseOrderDetails.status ?? ''),
                        const SizedBox(height: 10),
                        _buildInfoColumn('Delivery Date',
                            widget.purchaseOrderDetails.deliveryDate ?? ''),
                        const SizedBox(height: 10),
                        _buildInfoColumn('Order Date',
                            widget.purchaseOrderDetails.orderDate ?? ''),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField('QUANTITY*', _quantityController,
                      TextInputType.number, _quantityFocus, _batchNumberFocus),
                  const SizedBox(height: 16),
                  _buildTextField('BATCH NUMBER*', _batchNumberController,
                      TextInputType.text, _batchNumberFocus, _expiryDateFocus),
                  const SizedBox(height: 16),
                  _buildDateField(
                      'EXPIRY DATE*', _expiryDateController, context,
                      focusNode: _expiryDateFocus,
                      nextFocus: _manufacturingDateFocus),
                  const SizedBox(height: 16),
                  _buildDateField('MANUFACTURING DATE*',
                      _manufacturingDateController, context,
                      focusNode: _manufacturingDateFocus,
                      nextFocus: _netWeightFocus),
                  const SizedBox(height: 16),
                  _buildTextField(
                      'NET WEIGHT*',
                      _netWeightController,
                      TextInputType.number,
                      _netWeightFocus,
                      _transportGLNFocus),
                  const SizedBox(height: 16),
                  _buildTextField(
                      'TRANSPORT GLN*',
                      _transportGLNController,
                      TextInputType.text,
                      _transportGLNFocus,
                      _putAwayLocationFocus),
                  const SizedBox(height: 16),
                  _buildTextField(
                      'PUT AWAY LOCATION*',
                      _putAwayLocationController,
                      TextInputType.text,
                      _putAwayLocationFocus,
                      _receivedByFocus),
                  const SizedBox(height: 16),
                  _buildTextField('RECEIVED BY*', _receivedByController,
                      TextInputType.text, _receivedByFocus),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_quantityController.text.isEmpty ||
                            _batchNumberController.text.isEmpty ||
                            _expiryDateController.text.isEmpty ||
                            _manufacturingDateController.text.isEmpty ||
                            _netWeightController.text.isEmpty ||
                            _transportGLNController.text.isEmpty ||
                            _putAwayLocationController.text.isEmpty ||
                            _receivedByController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill all the fields'),
                              backgroundColor: AppColors.danger,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        } else {
                          cubit.createPurchaseOrderReceipt(
                            widget.purchaseOrderDetails,
                            _quantityController.text,
                            _batchNumberController.text,
                            _expiryDateController.text,
                            _manufacturingDateController.text,
                            _netWeightController.text,
                            _transportGLNController.text,
                            _putAwayLocationController.text,
                            _receivedByController.text,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pink,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: state is CreatePurchaseOrderReceiptLoading
                          ? const CircularProgressIndicator(
                              color: AppColors.white,
                              strokeWidth: 2,
                            )
                          : const Text(
                              'SUBMIT',
                              style: TextStyle(color: AppColors.white),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      [TextInputType? keyboardType,
      FocusNode? focusNode,
      FocusNode? nextFocus]) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      focusNode: focusNode,
      onSubmitted: (_) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildDateField(
      String label, TextEditingController controller, BuildContext context,
      {FocusNode? focusNode, FocusNode? nextFocus}) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      readOnly: true,
      onSubmitted: (_) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          controller.text =
              "${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}";
          if (nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          }
        }
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
    );
  }
}

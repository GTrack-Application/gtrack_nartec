// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/features/capture/cubits/association/shipping/sales_order/sales_order_cubit.dart';
import 'package:gtrack_nartec/features/capture/cubits/association/shipping/sales_order/sales_order_state.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/common/utils/app_snakbars.dart';
import 'package:gtrack_nartec/features/capture/models/Association/Receiving/sales_order/map_model.dart';
import 'package:gtrack_nartec/features/capture/models/Association/Receiving/sales_order/sub_sales_order_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({
    super.key,
    required this.customerId,
    required this.salesOrderId,
    required this.mapModel,
    required this.subSalesOrder,
  });

  final String customerId;
  final String salesOrderId;
  final List<MapModel> mapModel;
  final List<SubSalesOrderModel> subSalesOrder;

  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  File? imageFile;

  Future<void> saveSignature() async {
    final signatureData = await _signaturePadKey.currentState!.toImage();
    final bytes =
        await signatureData.toByteData(format: ui.ImageByteFormat.png);

    if (bytes != null) {
      final buffer = bytes.buffer.asUint8List();

      // Check if the device is running Android 11 or higher
      if (await Permission.storage.isGranted ||
          await _requestStoragePermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/signature.png';
        imageFile = File(path);
        await imageFile!.writeAsBytes(buffer);
        salesOrderCubit.uploadSignature(imageFile!, widget.salesOrderId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission not granted')),
        );
      }
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    } else {
      // For Android 11 or higher
      if (await Permission.manageExternalStorage.request().isGranted) {
        return true;
      }
    }
    return false;
  }

  final SalesOrderCubit salesOrderCubit = SalesOrderCubit();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SalesOrderCubit, SalesOrderState>(
      bloc: salesOrderCubit,
      listener: (context, state) {
        if (state is SignatureUploadLoaded) {
          Navigator.pop(context);
          Navigator.pop(context);
          AppSnackbars.success(context, state.message);
        }
        if (state is SignatureUploadError) {
          AppSnackbars.danger(
              context, state.message.replaceAll("Exception: ", ""));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[50], // Subtle background color
          appBar: AppBar(
            backgroundColor: AppColors.pink,
            elevation: 0, // Remove shadow
            title: const Text("Receiver Signature"),
            centerTitle: true,
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_outlined, size: 22),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Please sign below',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SfSignaturePad(
                        key: _signaturePadKey,
                        backgroundColor: Colors.white,
                        strokeColor: Colors.black,
                        minimumStrokeWidth: 1.0,
                        maximumStrokeWidth: 4.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _signaturePadKey.currentState?.clear(),
                          icon:
                              const Icon(Icons.refresh, color: Colors.black54),
                          label: const Text('Clear'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[100],
                            foregroundColor: Colors.black54,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: saveSignature,
                          icon: const Icon(Icons.save),
                          label: state is SignatureUploadLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('Save Signature'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.pink,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

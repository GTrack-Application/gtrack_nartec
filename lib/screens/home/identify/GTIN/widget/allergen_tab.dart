// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/allergen_model.dart';

class AllergenTab extends StatelessWidget {
  final List<AllergenModel> allergens;

  const AllergenTab({super.key, required this.allergens});

  @override
  Widget build(BuildContext context) {
    if (allergens.isEmpty) {
      return const Center(
        child: Text(
          'No allergen information available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: allergens
          .map((allergen) => AllergenCard(allergen: allergen))
          .toList(),
    );
  }
}

class AllergenCard extends StatelessWidget {
  final AllergenModel allergen;
  final GlobalKey _cardKey = GlobalKey();

  AllergenCard({super.key, required this.allergen});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          // Card content for capture (without buttons)
          RepaintBoundary(
            key: _cardKey,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black, width: 2),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Allergen Information / معلومات الحساسية',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Product Info Section
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          'Product Name',
                          allergen.productName ?? 'N/A',
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          'Lot Number',
                          allergen.lotNumber ?? 'N/A',
                        ),
                      ],
                    ),
                  ),

                  // Allergen Details Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFB6C1),
                    ),
                    child: const Text(
                      'ALLERGEN DETAILS / تفاصيل حساسيات الطعام',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Allergen Info
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          'Allergen Name / اسم مسبب الحساسية',
                          allergen.allergenName ?? 'N/A',
                        ),
                        const Divider(),
                        _buildInfoRow(
                          'Type / النوع',
                          allergen.allergenType ?? 'N/A',
                        ),
                        const Divider(),
                        _buildInfoRow(
                          'Severity / الشدة',
                          allergen.severity ?? 'N/A',
                        ),
                        const Divider(),
                        _buildInfoRow(
                          'Source / المصدر',
                          allergen.allergenSource ?? 'N/A',
                        ),
                      ],
                    ),
                  ),

                  // Status Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFFF99),
                    ),
                    child: const Text(
                      'STATUS / الحالة',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Status Details
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        _buildStatusRow(
                          'Contains Allergen / يحتوي على مسببات الحساسية',
                          allergen.containsAllergen ?? false,
                        ),
                        const Divider(),
                        _buildStatusRow(
                          'May Contain / قد يحتوي',
                          allergen.mayContain ?? false,
                        ),
                        const Divider(),
                        _buildStatusRow(
                          'Cross Contamination Risk / خطر التلوث المتقاطع',
                          allergen.crossContaminationRisk ?? false,
                        ),
                      ],
                    ),
                  ),

                  // Production Information Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Color(0xFFB6C1FF),
                    ),
                    child: const Text(
                      'PRODUCTION INFORMATION / معلومات الإنتاج',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Production Details
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          'Production Date / تاريخ الإنتاج',
                          _formatDate(allergen.productionDate),
                        ),
                        const Divider(),
                        _buildInfoRow(
                          'Expiration Date / تاريخ انتهاء الصلاحية',
                          _formatDate(allergen.expirationDate),
                        ),
                      ],
                    ),
                  ),

                  // Footer Note
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(5),
                    child: const Text(
                      '* Always check the product packaging for the most current allergen information.\n* راجع دائماً التغليف للحصول على أحدث معلومات مسببات الحساسية.',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons (outside RepaintBoundary, so they won't be captured)
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                    'PNG', Colors.blue[900]!, () => _downloadAs('png')),
                _buildActionButton(
                    'JPG', Colors.blue[900]!, () => _downloadAs('jpg')),
                _buildActionButton(
                    'PDF', Colors.blue[900]!, () => _downloadAs('pdf')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {bool isRightAligned = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!isRightAligned) ...[
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
            ),
          ),
        ] else ...[
          Expanded(
            child: Text(value),
          ),
          Expanded(
            flex: 2,
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusRow(String label, bool value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value ? 'Yes / نعم' : 'No / لا',
          style: TextStyle(
            color: value ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Future<void> _downloadAs(String format) async {
    try {
      if (format == 'pdf') {
        await _generatePDF();
      } else {
        await _captureAndSave(format);
      }
    } catch (e) {
      print('Error downloading as $format: $e');
    }
  }

  Future<void> _captureAndSave(String format) async {
    try {
      RenderRepaintBoundary boundary =
          _cardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: format == 'png'
            ? ui.ImageByteFormat.png
            : ui.ImageByteFormat.rawRgba,
      );

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();

        final directory = await getTemporaryDirectory();
        final fileName =
            'allergen_info_${DateTime.now().millisecondsSinceEpoch}.$format';
        final file = File('${directory.path}/$fileName');

        await file.writeAsBytes(pngBytes);

        // Share the file
        await Share.shareXFiles([XFile(file.path)],
            text:
                'Allergen Information - ${allergen.productName ?? "Unknown Product"}');
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  Future<void> _generatePDF() async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.black, width: 2),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Header
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.black,
                    ),
                    child: pw.Text(
                      'Allergen Information / معلومات الحساسية',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.SizedBox(height: 10),

                  // Product Info
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                    child: pw.Column(
                      children: [
                        _buildPDFBilingualRow(
                            'Product Name', allergen.productName ?? 'N/A'),
                        pw.SizedBox(height: 8),
                        _buildPDFBilingualRow(
                            'Lot Number', allergen.lotNumber ?? 'N/A'),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 10),

                  // Allergen Details
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.pink100,
                    ),
                    child: pw.Text(
                      'ALLERGEN DETAILS / تفاصيل حساسيات الطعام',
                      style: pw.TextStyle(
                        fontSize: 15,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.SizedBox(height: 10),

                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                    child: pw.Column(
                      children: [
                        _buildPDFBilingualRow(
                          'Allergen Name / اسم مسبب الحساسية',
                          allergen.allergenName ?? 'N/A',
                        ),
                        pw.Divider(),
                        _buildPDFBilingualRow(
                            'Type / النوع', allergen.allergenType ?? 'N/A'),
                        pw.Divider(),
                        _buildPDFBilingualRow(
                            'Severity / الشدة', allergen.severity ?? 'N/A'),
                        pw.Divider(),
                        _buildPDFBilingualRow('Source / المصدر',
                            allergen.allergenSource ?? 'N/A'),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 10),

                  // Status
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.yellow100,
                    ),
                    child: pw.Text(
                      'STATUS / الحالة',
                      style: pw.TextStyle(
                        fontSize: 15,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.SizedBox(height: 10),

                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                    child: pw.Column(
                      children: [
                        _buildPDFStatusRow(
                            'Contains Allergen / يحتوي على مسببات الحساسية',
                            allergen.containsAllergen ?? false),
                        pw.Divider(),
                        _buildPDFStatusRow('May Contain / قد يحتوي',
                            allergen.mayContain ?? false),
                        pw.Divider(),
                        _buildPDFStatusRow(
                          'Cross Contamination Risk / خطر التلوث المتقاطع',
                          allergen.crossContaminationRisk ?? false,
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 10),

                  // Production Info
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue100,
                    ),
                    child: pw.Text(
                      'PRODUCTION INFORMATION / معلومات الإنتاج',
                      style: pw.TextStyle(
                        fontSize: 15,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.SizedBox(height: 10),

                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                    child: pw.Column(
                      children: [
                        _buildPDFBilingualRow('Production Date / تاريخ الإنتاج',
                            _formatDate(allergen.productionDate)),
                        pw.Divider(),
                        _buildPDFBilingualRow(
                          'Expiration Date / تاريخ انتهاء الصلاحية',
                          _formatDate(allergen.expirationDate),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 20),

                  // Footer
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text(
                      '* Always check the product packaging for the most current allergen information.\n* راجع دائماً التغليف للحصول على أحدث معلومات مسببات الحساسية.',
                      style: pw.TextStyle(
                        fontSize: 12,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

      final directory = await getTemporaryDirectory();
      final fileName =
          'allergen_info_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory.path}/$fileName');

      await file.writeAsBytes(await pdf.save());

      // Share the PDF
      await Share.shareXFiles([XFile(file.path)],
          text:
              'Allergen Information PDF - ${allergen.productName ?? "Unknown Product"}');
    } catch (e) {
      print('Error generating PDF: $e');
    }
  }

  pw.Widget _buildPDFBilingualRow(String label, String value,
      {bool isRightAligned = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          if (!isRightAligned) ...[
            pw.Expanded(
              flex: 2,
              child: pw.Text(
                label,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                value,
                style: pw.TextStyle(),
                textAlign: pw.TextAlign.right,
              ),
            ),
          ] else ...[
            pw.Expanded(
              child: pw.Text(
                value,
                style: pw.TextStyle(),
              ),
            ),
            pw.Expanded(
              flex: 2,
              child: pw.Text(
                label,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.right,
              ),
            ),
          ],
        ],
      ),
    );
  }

  pw.Widget _buildPDFStatusRow(String label, bool value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            value ? 'Yes / نعم' : 'No / لا',
            style: pw.TextStyle(
              color: value ? PdfColors.red : PdfColors.green,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              textAlign: pw.TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

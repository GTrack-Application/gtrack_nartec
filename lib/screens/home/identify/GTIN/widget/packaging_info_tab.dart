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
import 'package:image/image.dart' as img;

class PackagingInfoTab extends StatelessWidget {
  final List<dynamic> packagingInfo; // Replace with your actual packaging model type

  const PackagingInfoTab({super.key, required this.packagingInfo});

  @override
  Widget build(BuildContext context) {
    if (packagingInfo.isEmpty) {
      return const Center(
        child: Text(
          'No packaging information available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: packagingInfo
          .map((packaging) => PackagingCard(packaging: packaging))
          .toList(),
    );
  }
}

class PackagingCard extends StatelessWidget {
  final dynamic packaging; // Replace with your actual packaging model type
  final GlobalKey _cardKey = GlobalKey();

  PackagingCard({super.key, required this.packaging});

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
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Packaging Information\nمعلومات التعبئة والتغليف',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Thick divider
                  Container(
                    height: 4,
                    color: Colors.black,
                  ),

                  // Packaging Details Section
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          'Packaging Type:',
                          'نوع التعبئة /',
                          _getValue('packagingType', 'Carton'),
                        ),
                        const Divider(color: Colors.grey),
                        _buildInfoRow(
                          'Material:',
                          'المادة /',
                          _getValue('material', 'Paper Corrugated Box'),
                        ),
                        const Divider(color: Colors.grey),
                        _buildInfoRow(
                          'Weight:',
                          'الوزن /',
                          _getValue('weight', '100 kg'),
                        ),
                        const Divider(color: Colors.grey),
                        _buildInfoRow(
                          'Dimensions:',
                          'الأبعاد /',
                          _getValue('dimensions', 'N/A'),
                        ),
                        const Divider(color: Colors.grey),
                        _buildInfoRow(
                          'Capacity:',
                          'السعة /',
                          _getValue('capacity', 'N/A'),
                        ),
                        const Divider(color: Colors.grey),
                        _buildInfoRow(
                          'Color:',
                          'اللون /',
                          _getValue('color', 'Brown'),
                        ),
                        const Divider(color: Colors.grey),
                        _buildLabelingRow(
                          'Labeling:',
                          'التسمية /',
                          _getValue('labeling', '1 Carton contains 30 Bottles 1 bottle = 1 Liter\n1 Pallet contains 20 Carton'),
                        ),
                      ],
                    ),
                  ),

                  // Thick divider
                  Container(
                    height: 4,
                    color: Colors.black,
                  ),

                  // Environmental Impact Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    child: const Text(
                      'Environmental Impact / الأثر البيئي',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Environmental Details
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        _buildStatusRow(
                          'Recyclable:',
                          'قابل للتدوير /',
                          _getBooleanValue('recyclable', true),
                        ),
                        const SizedBox(height: 8),
                        _buildStatusRow(
                          'Biodegradable:',
                          'قابل للتحلل الحيوي /',
                          _getBooleanValue('biodegradable', true),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Status Section
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green, width: 1),
                      ),
                      child: Text(
                        'Status: ${_getValue('status', 'active')} / الحالة: نشط',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Footer Info
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(
                          'Domain: ${_getValue('domain', 'dl.gs1ksa.org')}',
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Barcode: ${_getValue('barcode', '6285561000957')}',
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons (outside RepaintBoundary, so they won't be captured)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
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

  Widget _buildInfoRow(String englishLabel, String arabicLabel, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: arabicLabel,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: ' $englishLabel',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelingRow(String englishLabel, String arabicLabel, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: arabicLabel,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: ' $englishLabel',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String englishLabel, String arabicLabel, bool value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: arabicLabel,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: ' $englishLabel',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: value ? Colors.green[100] : Colors.red[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value ? 'Yes / نعم' : 'No / لا',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: value ? Colors.green[800] : Colors.red[800],
            ),
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
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  String _getValue(String key, String defaultValue) {
    // Replace this with your actual data extraction logic
    // Example: return packaging[key]?.toString() ?? defaultValue;
    return defaultValue;
  }

  bool _getBooleanValue(String key, bool defaultValue) {
    // Replace this with your actual data extraction logic
    // Example: return packaging[key] ?? defaultValue;
    return defaultValue;
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
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        Uint8List finalBytes = pngBytes;
        String fileExtension = format.toLowerCase();

        // Convert to different formats using the image package
        if (format.toLowerCase() != 'png') {
          img.Image? decodedImage = img.decodePng(pngBytes);
          if (decodedImage != null) {
            switch (format.toLowerCase()) {
              case 'jpg':
              case 'jpeg':
                finalBytes = Uint8List.fromList(
                    img.encodeJpg(decodedImage, quality: 95));
                fileExtension = 'jpg';
                break;
              default:
                finalBytes = pngBytes;
                fileExtension = 'png';
            }
          }
        }

        final directory = await getTemporaryDirectory();
        final fileName =
            'packaging_info_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
        final file = File('${directory.path}/$fileName');

        await file.writeAsBytes(finalBytes);

        // Share the file
        await Share.shareXFiles([XFile(file.path)],
            text: 'Packaging Information');
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
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.black,
                    ),
                    child: pw.Text(
                      'Packaging Information\nمعلومات التعبئة والتغليف',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),

                  pw.SizedBox(height: 20),

                  // Packaging Details
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(12),
                    child: pw.Column(
                      children: [
                        _buildPDFInfoRow(
                          'Packaging Type: / نوع التعبئة',
                          _getValue('packagingType', 'Carton'),
                        ),
                        pw.Divider(),
                        _buildPDFInfoRow(
                          'Material: / المادة',
                          _getValue('material', 'Paper Corrugated Box'),
                        ),
                        pw.Divider(),
                        _buildPDFInfoRow(
                          'Weight: / الوزن',
                          _getValue('weight', '100 kg'),
                        ),
                        pw.Divider(),
                        _buildPDFInfoRow(
                          'Dimensions: / الأبعاد',
                          _getValue('dimensions', 'N/A'),
                        ),
                        pw.Divider(),
                        _buildPDFInfoRow(
                          'Capacity: / السعة',
                          _getValue('capacity', 'N/A'),
                        ),
                        pw.Divider(),
                        _buildPDFInfoRow(
                          'Color: / اللون',
                          _getValue('color', 'Brown'),
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 20),

                  // Environmental Impact
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(12),
                    child: pw.Text(
                      'Environmental Impact / الأثر البيئي',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),

                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 12),
                    child: pw.Column(
                      children: [
                        _buildPDFStatusRow(
                          'Recyclable: / قابل للتدوير',
                          _getBooleanValue('recyclable', true),
                        ),
                        pw.SizedBox(height: 8),
                        _buildPDFStatusRow(
                          'Biodegradable: / قابل للتحلل الحيوي',
                          _getBooleanValue('biodegradable', true),
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 20),

                  // Footer
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(12),
                    child: pw.Column(
                      children: [
                        pw.Text(
                          'Status: ${_getValue('status', 'active')} / الحالة: نشط',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          'Domain: ${_getValue('domain', 'dl.gs1ksa.org')}',
                          style: pw.TextStyle(fontSize: 12),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.Text(
                          'Barcode: ${_getValue('barcode', '6285561000957')}',
                          style: pw.TextStyle(fontSize: 12),
                          textAlign: pw.TextAlign.center,
                        ),
                      ],
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
          'packaging_info_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory.path}/$fileName');

      await file.writeAsBytes(await pdf.save());

      // Share the PDF
      await Share.shareXFiles([XFile(file.path)],
          text: 'Packaging Information PDF');
    } catch (e) {
      print('Error generating PDF: $e');
    }
  }

  pw.Widget _buildPDFInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
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
              textAlign: pw.TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPDFStatusRow(String label, bool value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(
          value ? 'Yes / نعم' : 'No / لا',
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            color: value ? PdfColors.green : PdfColors.red,
          ),
        ),
      ],
    );
  }
}
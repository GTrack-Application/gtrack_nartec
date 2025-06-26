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
import 'package:url_launcher/url_launcher.dart';

class LeafletInfoTab extends StatelessWidget {
  final List<dynamic>
      leafletInfo; // Replace with your actual leaflet model type

  const LeafletInfoTab({super.key, required this.leafletInfo});

  @override
  Widget build(BuildContext context) {
    if (leafletInfo.isEmpty) {
      return const Center(
        child: Text(
          'No leaflet information available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      children:
          leafletInfo.map((leaflet) => LeafletCard(leaflet: leaflet)).toList(),
    );
  }
}

class LeafletCard extends StatelessWidget {
  final dynamic leaflet; // Replace with your actual leaflet model type
  final GlobalKey _cardKey = GlobalKey();

  LeafletCard({super.key, required this.leaflet});

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
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Electronic Leaflet\nالنشرة الإلكترونية',
                      style: TextStyle(
                        color: Colors.black,
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

                  // Leaflet Details Section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          'Product ID:',
                          'معرف المنتج /',
                          _getValue('productId', '10032'),
                          isRightAligned: true,
                        ),
                        const Divider(color: Colors.grey),
                        _buildInfoRow(
                          'GTIN:',
                          'الرمز الشريطي /',
                          _getValue('gtin', '6285561000957'),
                          isRightAligned: true,
                        ),
                        const Divider(color: Colors.grey),
                        _buildInfoRow(
                          'Link Type:',
                          'نوع الرابط /',
                          _getValue('linkType', 'link'),
                          isRightAligned: true,
                        ),
                        const Divider(color: Colors.grey),
                        _buildInfoRow(
                          'Languages:',
                          'اللغات /',
                          _getValue('languages', 'Language'),
                          isRightAligned: true,
                        ),
                        const Divider(color: Colors.grey),
                        _buildDescriptionRow(
                          'Leaflet Information:',
                          'معلومات النشرة /',
                          _getValue('leafletInformation', 'testt'),
                        ),
                        const Divider(color: Colors.grey),
                        _buildInfoRow(
                          'Target URL:',
                          'الرابط المستهدف /',
                          _getValue('targetUrl', 'www.google.com'),
                          isRightAligned: true,
                          isLink: true,
                        ),
                      ],
                    ),
                  ),

                  // Thick divider
                  Container(
                    height: 4,
                    color: Colors.black,
                  ),

                  // PDF Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: const Text(
                      'PDF Leaflet / نشرة PDF',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // PDF Status Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.3),
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        children: [
                          // PDF Icon
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'PDF',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'PDF Leaflet Available',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Text(
                            'نشرة إلكترونية متاحة بصيغة PDF',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          // View PDF Button
                          GestureDetector(
                            onTap: () => _openPDFUrl(),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.download,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'VIEW PDF / عرض PDF',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Footer Info
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Leaflet ID: ${_getValue('leafletId', '10032')}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'GTIN: ${_getValue('gtin', '6285561000957')}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Generated on: ${_getValue('generatedOn', '6/26/2025, 1:02:56 PM')}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
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

  Widget _buildInfoRow(String englishLabel, String arabicLabel, String value,
      {bool isRightAligned = false, bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
            child: GestureDetector(
              onTap: isLink ? () => _openUrl(value) : null,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isLink ? Colors.blue : Colors.black,
                  decoration: isLink ? TextDecoration.underline : null,
                ),
                textAlign: isRightAligned ? TextAlign.right : TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionRow(
      String englishLabel, String arabicLabel, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
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
    // Example: return leaflet[key]?.toString() ?? defaultValue;
    return defaultValue;
  }

  Future<void> _openUrl(String url) async {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openPDFUrl() async {
    final pdfUrl = _getValue('pdfUrl', 'https://www.google.com');
    await _openUrl(pdfUrl);
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
            'leaflet_info_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
        final file = File('${directory.path}/$fileName');

        await file.writeAsBytes(finalBytes);

        // Share the file
        await Share.shareXFiles([XFile(file.path)],
            text: 'Leaflet Information');
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
                    padding: const pw.EdgeInsets.all(16),
                    child: pw.Text(
                      'Electronic Leaflet\nالنشرة الإلكترونية',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),

                  pw.SizedBox(height: 20),

                  // Leaflet Details
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(16),
                    child: pw.Column(
                      children: [
                        _buildPDFInfoRow(
                          'Product ID: / معرف المنتج',
                          _getValue('productId', '10032'),
                        ),
                        pw.Divider(),
                        _buildPDFInfoRow(
                          'GTIN: / الرمز الشريطي',
                          _getValue('gtin', '6285561000957'),
                        ),
                        pw.Divider(),
                        _buildPDFInfoRow(
                          'Link Type: / نوع الرابط',
                          _getValue('linkType', 'link'),
                        ),
                        pw.Divider(),
                        _buildPDFInfoRow(
                          'Languages: / اللغات',
                          _getValue('languages', 'Language'),
                        ),
                        pw.Divider(),
                        _buildPDFInfoRow(
                          'Leaflet Information: / معلومات النشرة',
                          _getValue('leafletInformation', 'testt'),
                        ),
                        pw.Divider(),
                        _buildPDFInfoRow(
                          'Target URL: / الرابط المستهدف',
                          _getValue('targetUrl', 'www.google.com'),
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 20),

                  // PDF Section
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(16),
                    child: pw.Text(
                      'PDF Leaflet / نشرة PDF',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),

                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(16),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey100,
                      border: pw.Border.all(color: PdfColors.grey),
                      borderRadius:
                          const pw.BorderRadius.all(pw.Radius.circular(8)),
                    ),
                    child: pw.Text(
                      'PDF Leaflet Available\nنشرة إلكترونية متاحة بصيغة PDF',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),

                  pw.SizedBox(height: 20),

                  // Footer
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(16),
                    child: pw.Column(
                      children: [
                        pw.Text(
                          'Leaflet ID: ${_getValue('leafletId', '10032')}',
                          style: pw.TextStyle(fontSize: 12),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.Text(
                          'GTIN: ${_getValue('gtin', '6285561000957')}',
                          style: pw.TextStyle(fontSize: 12),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.Text(
                          'Generated on: ${_getValue('generatedOn', '6/26/2025, 1:02:56 PM')}',
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
          'leaflet_info_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory.path}/$fileName');

      await file.writeAsBytes(await pdf.save());

      // Share the PDF
      await Share.shareXFiles([XFile(file.path)],
          text: 'Leaflet Information PDF');
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
}

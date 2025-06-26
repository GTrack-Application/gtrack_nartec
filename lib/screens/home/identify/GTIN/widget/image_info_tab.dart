// ignore_for_file: deprecated_member_use, avoid_print

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/image_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as img;

class ImageInfoTab extends StatelessWidget {
  final List<ImageModel> imageInfo;

  const ImageInfoTab({super.key, required this.imageInfo});

  @override
  Widget build(BuildContext context) {
    if (imageInfo.isEmpty) {
      return const Center(
        child: Text(
          'No image information available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: imageInfo.map((image) => ImageCard(imageData: image)).toList(),
    );
  }
}

class ImageCard extends StatelessWidget {
  final ImageModel imageData;
  final GlobalKey _cardKey = GlobalKey();

  ImageCard({super.key, required this.imageData});

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
                    child: Column(
                      children: [
                        const Text(
                          'Images Information',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          'معلومات الصور',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Thick divider
                  Container(
                    height: 4,
                    color: Colors.black,
                  ),

                  // Image Display Section
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
                          // Product Image
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: _buildProductImage(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Image Details Section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          'Barcode:',
                          'الرمز الشريطي /',
                          _getValue(
                              'barcode', imageData.barcode ?? '6285561000957'),
                          isRightAligned: true,
                        ),
                        const Divider(color: Colors.grey),
                        _buildInfoRow(
                          'Created Date:',
                          'تاريخ الإنشاء /',
                          _getValue('createdDate',
                              imageData.createdAt ?? '5/11/2025'),
                          isRightAligned: true,
                        ),
                        const Divider(color: Colors.grey),
                        _buildInfoRow(
                          'Updated Date:',
                          'تاريخ التحديث /',
                          _getValue('updatedDate',
                              imageData.updatedAt ?? '5/11/2025'),
                          isRightAligned: true,
                        ),
                        const Divider(color: Colors.grey),
                        _buildInfoRow(
                          'Domain:',
                          'النطاق /',
                          _getValue('domain', 'dl.gs1ksa.org'),
                          isRightAligned: true,
                          isLink: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Footer Info
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Document ID: ${_getValue('documentId', 'cmajfobck005zasc3ka5nj8ps')}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Generated on: ${_getValue('generatedOn', '6/26/2025, 12:16:00 PM')}',
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

  Widget _buildProductImage() {
    if (imageData.photos != null && imageData.photos!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl:
            "${AppUrls.upcHub}/${imageData.photos.toString().replaceAll("public", "")}",
        fit: BoxFit.contain,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => _buildPlaceholderImage(),
      );
    }

    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 8),
            Text(
              'Product Image',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
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
    // Example: return imageData[key]?.toString() ?? defaultValue;
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
            'image_info_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
        final file = File('${directory.path}/$fileName');

        await file.writeAsBytes(finalBytes);

        // Share the file
        await Share.shareXFiles([XFile(file.path)], text: 'Image Information');
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
                    child: pw.Column(
                      children: [
                        pw.Text(
                          'Images Information',
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.Text(
                          'معلومات الصور',
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 14,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 20),

                  // Image Details
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(16),
                    child: pw.Column(
                      children: [
                        _buildPDFInfoRow(
                          'Barcode: / الرمز الشريطي',
                          _getValue('barcode', '6285561000957'),
                        ),
                        pw.Divider(),
                        _buildPDFInfoRow(
                          'Created Date: / تاريخ الإنشاء',
                          _getValue('createdDate', '5/11/2025'),
                        ),
                        pw.Divider(),
                        _buildPDFInfoRow(
                          'Updated Date: / تاريخ التحديث',
                          _getValue('updatedDate', '5/11/2025'),
                        ),
                        pw.Divider(),
                        _buildPDFInfoRow(
                          'Domain: / النطاق',
                          _getValue('domain', 'dl.gs1ksa.org'),
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 20),

                  // Footer
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(16),
                    child: pw.Column(
                      children: [
                        pw.Text(
                          'Document ID: ${_getValue('documentId', 'cmajfobck005zasc3ka5nj8ps')}',
                          style: pw.TextStyle(fontSize: 12),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.Text(
                          'Generated on: ${_getValue('generatedOn', '6/26/2025, 12:16:00 PM')}',
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
          'image_info_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory.path}/$fileName');

      await file.writeAsBytes(await pdf.save());

      // Share the PDF
      await Share.shareXFiles([XFile(file.path)],
          text: 'Image Information PDF');
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

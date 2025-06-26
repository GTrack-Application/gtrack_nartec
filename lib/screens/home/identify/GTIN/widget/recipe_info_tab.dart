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

class RecipeInfoTab extends StatelessWidget {
  final List<dynamic> recipeInfo; // Replace with your actual recipe model type

  const RecipeInfoTab({super.key, required this.recipeInfo});

  @override
  Widget build(BuildContext context) {
    if (recipeInfo.isEmpty) {
      return const Center(
        child: Text(
          'No recipe information available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: recipeInfo.map((recipe) => RecipeCard(recipe: recipe)).toList(),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final dynamic recipe; // Replace with your actual recipe model type
  final GlobalKey _cardKey = GlobalKey();

  RecipeCard({super.key, required this.recipe});

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
                      'Recipe Information\nمعلومات الوصفة',
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

                  // Recipe Details Section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          'GTIN:',
                          'الرمز الشريطي /',
                          _getValue('gtin', '6285561000957'),
                          isRightAligned: true,
                        ),
                        const Divider(color: Colors.grey),
                        _buildInfoRow(
                          'Title:',
                          'العنوان /',
                          _getValue('title', 'Recipe Info'),
                          isRightAligned: false,
                        ),
                        const Divider(color: Colors.grey),
                        _buildDescriptionRow(
                          'Description:',
                          'الوصف /',
                          _getValue('description', 'Description added'),
                        ),
                        const Divider(color: Colors.grey),
                        _buildDescriptionRow(
                          'Ingredients:',
                          'المكونات /',
                          _getValue('ingredients', 'ingredients'),
                        ),
                        const Divider(color: Colors.grey),
                        _buildInfoRow(
                          'Link Type:',
                          'نوع الرابط /',
                          _getValue('linkType', 'LinkType'),
                          isRightAligned: true,
                        ),
                      ],
                    ),
                  ),

                  // Thick divider
                  Container(
                    height: 4,
                    color: Colors.black,
                  ),

                  // Status Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.restaurant_menu,
                            size: 32,
                            color: Colors.green[600],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Recipe Information Available',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Text(
                            'معلومات الوصفة متاحة',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
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
                          'Recipe ID: ${_getValue('recipeId', '1089')}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Generated on: ${_getValue('generatedOn', '6/26/2025, 11:21:58 AM')}',
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
      {bool isRightAligned = false}) {
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
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              textAlign: isRightAligned ? TextAlign.right : TextAlign.left,
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
    // Example: return recipe[key]?.toString() ?? defaultValue;
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
            'recipe_info_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
        final file = File('${directory.path}/$fileName');

        await file.writeAsBytes(finalBytes);

        // Share the file
        await Share.shareXFiles([XFile(file.path)], text: 'Recipe Information');
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
                      'Recipe Information\nمعلومات الوصفة',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),

                  pw.SizedBox(height: 20),

                  // Recipe Details
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(16),
                    child: pw.Column(
                      children: [
                        _buildPDFInfoRow(
                          'GTIN: / الرمز الشريطي',
                          _getValue('gtin', '6285561000957'),
                        ),
                        pw.Divider(),
                        _buildPDFInfoRow(
                          'Title: / العنوان',
                          _getValue('title', 'Recipe Info'),
                        ),
                        pw.Divider(),
                        _buildPDFInfoRow(
                          'Description: / الوصف',
                          _getValue('description', 'Description added'),
                        ),
                        pw.Divider(),
                        _buildPDFInfoRow(
                          'Ingredients: / المكونات',
                          _getValue('ingredients', 'ingredients'),
                        ),
                        pw.Divider(),
                        _buildPDFInfoRow(
                          'Link Type: / نوع الرابط',
                          _getValue('linkType', 'LinkType'),
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 20),

                  // Status Section
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(16),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.green100,
                      border: pw.Border.all(color: PdfColors.green),
                      borderRadius:
                          const pw.BorderRadius.all(pw.Radius.circular(8)),
                    ),
                    child: pw.Text(
                      'Recipe Information Available\nمعلومات الوصفة متاحة',
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
                          'Recipe ID: ${_getValue('recipeId', '1089')}',
                          style: pw.TextStyle(fontSize: 12),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.Text(
                          'Generated on: ${_getValue('generatedOn', '6/26/2025, 11:21:58 AM')}',
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
          'recipe_info_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory.path}/$fileName');

      await file.writeAsBytes(await pdf.save());

      // Share the PDF
      await Share.shareXFiles([XFile(file.path)],
          text: 'Recipe Information PDF');
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

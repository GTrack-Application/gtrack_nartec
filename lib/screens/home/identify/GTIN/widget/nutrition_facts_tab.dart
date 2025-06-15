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

class NutritionFactsTab extends StatelessWidget {
  final List<dynamic>
      nutritionFacts; // Replace with your actual nutrition fact model type

  const NutritionFactsTab({super.key, required this.nutritionFacts});

  @override
  Widget build(BuildContext context) {
    if (nutritionFacts.isEmpty) {
      return const Center(
        child: Text(
          'No nutrition facts information available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: nutritionFacts
          .map((nutritionFact) =>
              NutritionFactsCard(nutritionFact: nutritionFact))
          .toList(),
    );
  }
}

class NutritionFactsCard extends StatelessWidget {
  final dynamic
      nutritionFact; // Replace with your actual nutrition fact model type
  final GlobalKey _cardKey = GlobalKey();

  NutritionFactsCard({super.key, required this.nutritionFact});

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
                border: Border.all(color: Colors.black, width: 3),
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
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                    ),
                    child: const Text(
                      'Nutrition Facts / الحقائق التغذوية',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  // Serving Information
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildServingRow(
                          _getValue('servingsPerPackage', '100'),
                          'Servings per package',
                          isFirst: true,
                        ),
                        _buildServingRow(
                          _getValue('servingSize', '150'),
                          'Serving Size',
                        ),
                      ],
                    ),
                  ),

                  // Thick divider
                  Container(
                    height: 10,
                    color: Colors.black,
                  ),

                  // Amount per serving and Calories
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'المقدار في حصة غذائية',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Text(
                          'Amount per Serving',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'السعرات الحرارية',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Text(
                              'Calories',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          _getValue('calories', '100'),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Medium divider
                  Container(
                    height: 5,
                    color: Colors.black,
                  ),

                  // Daily Value header
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '% القيمة اليومية *',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Text(
                          '* Daily Value %',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Nutrition details
                  _buildNutritionRow(
                    _getValue('totalFatsPercent', '15%'),
                    '${_getValue('totalFats', '10')} جرام',
                    'Total Fats / الدهون الكلية',
                    isBold: true,
                  ),
                  _buildNutritionRow(
                    _getValue('saturatedFatsPercent', '260%'),
                    '${_getValue('saturatedFats', '52')} جرام',
                    'Saturated Fats / دهون مشبعة',
                    indent: true,
                  ),
                  _buildNutritionRow(
                    '',
                    '${_getValue('monounsaturatedFats', '25')} جرام',
                    'Monounsaturated / الأحادية غير مشبعة',
                    indent: true,
                  ),
                  _buildNutritionRow(
                    '',
                    '${_getValue('polyunsaturatedFats', '25')} جرام',
                    'Polyunsaturated / متعددة غير مشبعة',
                    indent: true,
                  ),
                  _buildNutritionRow(
                    '',
                    '${_getValue('transFat', '200')} جرام',
                    'Trans Fat / دهون محولة',
                    indent: true,
                  ),

                  _buildNutritionRow(
                    _getValue('cholesterolPercent', '667%'),
                    '${_getValue('cholesterol', '2000')} مجم',
                    'Cholesterol / كوليسترول',
                    isBold: true,
                  ),
                  _buildNutritionRow(
                    _getValue('sodiumPercent', '11%'),
                    '${_getValue('sodium', '255')} مجم',
                    'Sodium / صوديوم',
                    isBold: true,
                  ),

                  _buildNutritionRow(
                    _getValue('totalCarbohydratesPercent', '8%'),
                    '${_getValue('totalCarbohydrates', '25')} جرام',
                    'Total Carbohydrates / الكربوهيدرات الكلية',
                    isBold: true,
                  ),
                  _buildNutritionRow(
                    _getValue('dietaryFibersPercent', '140%'),
                    '${_getValue('dietaryFibers', '35')} جرام',
                    'Dietary Fibers / ألياف غذائية',
                    indent: true,
                  ),
                  _buildNutritionRow(
                    '',
                    '${_getValue('totalSugars', '2500')} جرام',
                    'Total Sugars / سكريات كلية',
                    indent: true,
                  ),
                  _buildNutritionRow(
                    _getValue('addedSugarPercent', '5000%'),
                    '${_getValue('addedSugar', '2500')} جرام',
                    'Contains added sugar / محتوي على سكر مضاف',
                    indent: true,
                    hasExtraIndent: true,
                  ),

                  _buildNutritionRow(
                    _getValue('proteinPercent', '246%'),
                    '${_getValue('protein', '123')} جرام',
                    'Protein / بروتين',
                    isBold: true,
                  ),

                  // Bottom note
                  Container(
                    height: 5,
                    color: Colors.black,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'مؤشر الحد الأقصى المفيد للعناصر الغذائية في أوضاع مقترحة الاحتياج اليومي للشخص',
                          style: TextStyle(fontSize: 10),
                        ),
                        const Text(
                          'بإجمالي قدرة على أساس نظام غذائي مؤمي بحدود 2000 سعرة حرارية لا يقل عنها وإني',
                          style: TextStyle(fontSize: 10),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '* Indicates percent daily value of nutrients per serving based on a 2000 calorie diet.',
                          style: TextStyle(fontSize: 10),
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
                _buildActionButton(
                    'TIF', Colors.blue[900]!, () => _downloadAs('tif')),
                _buildActionButton(
                    'SVG', Colors.blue[900]!, () => _downloadAs('svg')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServingRow(String value, String label, {bool isFirst = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: isFirst ? 16 : 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: isFirst ? 16 : 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionRow(String percentage, String amount, String label,
      {bool isBold = false, bool indent = false, bool hasExtraIndent = false}) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black, width: 1),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: hasExtraIndent ? 40 : (indent ? 20 : 12),
          right: 12,
          top: 4,
          bottom: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              percentage,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Expanded(
              child: Text(
                amount,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                label,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
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
    // Example: return nutritionFact[key]?.toString() ?? defaultValue;
    return defaultValue;
  }

  Future<void> _downloadAs(String format) async {
    try {
      if (format == 'pdf') {
        await _generatePDF();
      } else if (format == 'svg') {
        await _generateSVG();
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
              case 'tif':
              case 'tiff':
                finalBytes = Uint8List.fromList(img.encodeTiff(decodedImage));
                fileExtension = 'tif';
                break;
              default:
                finalBytes = pngBytes;
                fileExtension = 'png';
            }
          }
        }

        final directory = await getTemporaryDirectory();
        final fileName =
            'nutrition_facts_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
        final file = File('${directory.path}/$fileName');

        await file.writeAsBytes(finalBytes);

        // Share the file
        await Share.shareXFiles([XFile(file.path)],
            text: 'Nutrition Facts Information');
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
                border: pw.Border.all(color: PdfColors.black, width: 3),
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
                      'Nutrition Facts / الحقائق التغذوية',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.left,
                    ),
                  ),

                  // Serving Information
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(12),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildPDFServingRow(
                          _getValue('servingsPerPackage', '100'),
                          'Servings per package',
                          isFirst: true,
                        ),
                        _buildPDFServingRow(
                          _getValue('servingSize', '150'),
                          'Serving Size',
                        ),
                      ],
                    ),
                  ),

                  // Thick divider
                  pw.Container(
                    height: 10,
                    color: PdfColors.black,
                  ),

                  // Amount per serving and Calories
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(12),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'المقدار في حصة غذائية',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.normal,
                          ),
                        ),
                        pw.Text(
                          'Amount per Serving',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.normal,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'السعرات الحرارية',
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.normal,
                              ),
                            ),
                            pw.Text(
                              'Calories',
                              style: pw.TextStyle(
                                fontSize: 36,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.Text(
                          _getValue('calories', '100'),
                          style: pw.TextStyle(
                            fontSize: 36,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Medium divider
                  pw.Container(
                    height: 5,
                    color: PdfColors.black,
                  ),

                  // Daily Value header
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          '% القيمة اليومية *',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.normal,
                          ),
                        ),
                        pw.Text(
                          '* Daily Value %',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Nutrition details
                  _buildPDFNutritionRow(
                    _getValue('totalFatsPercent', '15%'),
                    '${_getValue('totalFats', '10')} جرام',
                    'Total Fats / الدهون الكلية',
                    isBold: true,
                  ),
                  _buildPDFNutritionRow(
                    _getValue('proteinPercent', '246%'),
                    '${_getValue('protein', '123')} جرام',
                    'Protein / بروتين',
                    isBold: true,
                  ),

                  // Bottom note
                  pw.Container(
                    height: 5,
                    color: PdfColors.black,
                  ),

                  pw.Padding(
                    padding: const pw.EdgeInsets.all(12),
                    child: pw.Text(
                      '* Indicates percent daily value of nutrients per serving based on a 2000 calorie diet.',
                      style: pw.TextStyle(fontSize: 10),
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
          'nutrition_facts_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory.path}/$fileName');

      await file.writeAsBytes(await pdf.save());

      // Share the PDF
      await Share.shareXFiles([XFile(file.path)],
          text: 'Nutrition Facts Information PDF');
    } catch (e) {
      print('Error generating PDF: $e');
    }
  }

  pw.Widget _buildPDFServingRow(String value, String label,
      {bool isFirst = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: isFirst ? 16 : 14,
              fontWeight: pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: isFirst ? 16 : 14,
              fontWeight: pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPDFNutritionRow(
      String percentage, String amount, String label,
      {bool isBold = false, bool indent = false, bool hasExtraIndent = false}) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.black, width: 1),
        ),
      ),
      child: pw.Padding(
        padding: pw.EdgeInsets.only(
          left: hasExtraIndent ? 40 : (indent ? 20 : 12),
          right: 12,
          top: 4,
          bottom: 4,
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              percentage,
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                amount,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight:
                      isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
                ),
              ),
            ),
            pw.Expanded(
              flex: 2,
              child: pw.Text(
                label,
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight:
                      isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateSVG() async {
    try {
      // Create SVG content as string
      final svgContent = _createSVGContent();

      final directory = await getTemporaryDirectory();
      final fileName =
          'nutrition_facts_${DateTime.now().millisecondsSinceEpoch}.svg';
      final file = File('${directory.path}/$fileName');

      await file.writeAsString(svgContent);

      // Share the SVG file
      await Share.shareXFiles([XFile(file.path)],
          text: 'Nutrition Facts Information SVG');
    } catch (e) {
      print('Error generating SVG: $e');
    }
  }

  String _createSVGContent() {
    return '''<?xml version="1.0" encoding="UTF-8"?>
<svg width="400" height="800" xmlns="http://www.w3.org/2000/svg">
  <!-- Background -->
  <rect width="400" height="800" fill="white" stroke="black" stroke-width="3"/>
  
  <!-- Header -->
  <rect x="0" y="0" width="400" height="50" fill="black"/>
  <text x="200" y="30" text-anchor="middle" fill="white" font-size="18" font-weight="bold">
    Nutrition Facts / الحقائق التغذوية
  </text>
  
  <!-- Serving Information -->
  <text x="20" y="80" font-size="14" font-weight="bold">
    ${_getValue('servingsPerPackage', '100')} Servings per package
  </text>
  <text x="20" y="100" font-size="12">
    Serving Size ${_getValue('servingSize', '150')}
  </text>
  
  <!-- Thick divider -->
  <rect x="0" y="120" width="400" height="8" fill="black"/>
  
  <!-- Amount per serving -->
  <text x="20" y="150" font-size="12">المقدار في حصة غذائية</text>
  <text x="20" y="165" font-size="12">Amount per Serving</text>
  
  <!-- Calories -->
  <text x="20" y="190" font-size="14">السعرات الحرارية</text>
  <text x="200" y="190" font-size="32" font-weight="bold">Calories</text>
  <text x="20" y="220" font-size="32" font-weight="bold">${_getValue('calories', '100')}</text>
  
  <!-- Medium divider -->
  <rect x="0" y="240" width="400" height="4" fill="black"/>
  
  <!-- Daily Value header -->
  <text x="20" y="265" font-size="12">% القيمة اليومية *</text>
  <text x="300" y="265" font-size="12">* Daily Value %</text>
  
  <!-- Nutrition details -->
  <line x1="0" y1="280" x2="400" y2="280" stroke="black" stroke-width="1"/>
  <text x="20" y="300" font-size="12" font-weight="bold">
    Total Fats / الدهون الكلية ${_getValue('totalFats', '10')} جرام
  </text>
  <text x="350" y="300" font-size="12" font-weight="bold">
    ${_getValue('totalFatsPercent', '15%')}
  </text>
  
  <line x1="0" y1="310" x2="400" y2="310" stroke="black" stroke-width="1"/>
  <text x="40" y="330" font-size="12">
    Saturated Fats / دهون مشبعة ${_getValue('saturatedFats', '52')} جرام
  </text>
  <text x="350" y="330" font-size="12">
    ${_getValue('saturatedFatsPercent', '260%')}
  </text>
  
  <!-- More nutrition rows would go here... -->
  
  <!-- Footer note -->
  <rect x="0" y="700" width="400" height="4" fill="black"/>
  <text x="20" y="720" font-size="8">
    * Indicates percent daily value of nutrients per serving based on a 2000 calorie diet.
  </text>
  <text x="20" y="735" font-size="8">
    مؤشر الحد الأقصى المفيد للعناصر الغذائية في أوضاع مقترحة الاحتياج اليومي للشخص
  </text>
</svg>''';
  }
}

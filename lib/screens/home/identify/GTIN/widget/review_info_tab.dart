// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/review_model.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart'; // Add this import

class ReviewCard extends StatelessWidget {
  final ReviewModel review; // Replace with your actual review model type
  final GlobalKey _cardKey = GlobalKey();

  ReviewCard({super.key, required this.review});

  // Helper method to format datetime
  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return 'N/A';

    try {
      DateTime dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('MMM dd, yyyy at h:mm a').format(dateTime);
    } catch (e) {
      return dateTimeStr; // Return original if parsing fails
    }
  }

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
                  // Review Content Section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Created date and GTIN
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                'Created: ${_formatDateTime(review.createdAt)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                review.gTIN ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Product name and rating
                        Text(
                          review.brandName ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Star rating and score
                        Row(
                          children: [
                            Row(
                              children: List.generate(5, (starIndex) {
                                return Icon(
                                  starIndex < review.rating!
                                      ? Icons.star
                                      : Icons.star_border,
                                  size: 20,
                                  color: Colors.orange,
                                );
                              }),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${review.rating} out of 5',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Review comment with quote styling
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.grey[400]!,
                                width: 4,
                              ),
                            ),
                          ),
                          child: Text(
                            '"${review.comments ?? ''}"',
                            style: const TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Review details section
                        _buildDetailRow(
                          'Reviewer ID:',
                          review.id ?? '',
                          Icons.person,
                        ),
                        _buildDetailRow(
                          'IP:',
                          review.locationIP ?? '',
                          Icons.location_on,
                        ),

                        const SizedBox(height: 16),

                        // Updated info
                        Text(
                          'Updated: ${_formatDateTime(review.updatedAt)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Additional details
                        Text(
                          'GCP GLN ID: ${review.gcpGLNID ?? ''}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          'GTIN: ${review.gTIN ?? ''}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Divider(color: Colors.grey),

                        const SizedBox(height: 8),

                        // Review ID
                        Text(
                          'Review ID: ${review.id ?? ''}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // // Action Buttons (outside RepaintBoundary, so they won't be captured)
          // Padding(
          //   padding: const EdgeInsets.all(12),
          //   child: Wrap(
          //     spacing: 8,
          //     runSpacing: 8,
          //     alignment: WrapAlignment.center,
          //     children: [
          //       _buildActionButton(
          //           'PNG', Colors.blue[900]!, () => _downloadAs('png')),
          //       _buildActionButton(
          //           'JPG', Colors.blue[900]!, () => _downloadAs('jpg')),
          //       _buildActionButton(
          //           'PDF', Colors.blue[900]!, () => _downloadAs('pdf')),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Text(
            '$label ',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
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

  int _getIntValue(String key, int defaultValue) {
    // Replace this with your actual data extraction logic
    // Example: return review[key] ?? defaultValue;
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
            'review_info_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
        final file = File('${directory.path}/$fileName');

        await file.writeAsBytes(finalBytes);

        await Share.shareXFiles([XFile(file.path)], text: 'Review Information');
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
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(16),
                    child: pw.Text(
                      'Reviews',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(16),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Created: ${_formatDateTime(review.createdAt)}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          review.brandName ?? '',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text('Rating: ${review.rating ?? 4} out of 5'),
                        pw.SizedBox(height: 8),
                        pw.Text('"${review.comments ?? ''}"',
                            style: pw.TextStyle(
                                fontSize: 16, fontStyle: pw.FontStyle.italic)),
                        pw.SizedBox(height: 8),
                        pw.Text('Reviewer ID: ${review.id ?? ''}'),
                        pw.Text('IP: ${review.locationIP ?? ''}'),
                        pw.SizedBox(height: 8),
                        pw.Text(
                            'Updated: ${_formatDateTime(review.updatedAt)}'),
                        pw.Text('GTIN: ${review.gTIN ?? ''}'),
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
          'review_info_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory.path}/$fileName');

      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles([XFile(file.path)],
          text: 'Review Information PDF');
    } catch (e) {
      print('Error generating PDF: $e');
    }
  }
}

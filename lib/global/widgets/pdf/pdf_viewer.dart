import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfViewer extends StatefulWidget {
  const PdfViewer({super.key, required this.path});

  final String path;

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  PDFDocument? document;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  Future<void> loadDocument() async {
    try {
      final doc = await PDFDocument.fromURL(widget.path);
      if (mounted) {
        setState(() {
          document = doc;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading PDF: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'PDF Document',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.open_in_new,
                    size: 20,
                  ),
                  onPressed: () async {
                    final url = Uri.parse(widget.path);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : document == null
                      ? const Center(
                          child: Text('Error loading PDF'),
                        )
                      : PDFViewer(
                          document: document!,
                          showPicker: false,
                          showNavigation: true,
                          showIndicator: true,
                          enableSwipeNavigation: true,
                          scrollDirection: Axis.vertical,
                        ),
            ),
          ),
        ],
      ),
    );
  }
}

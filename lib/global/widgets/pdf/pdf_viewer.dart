import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfViewer extends StatefulWidget {
  const PdfViewer({super.key, required this.path});

  final String path;

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  bool isLoading = true;
  String? errorMessage;
  final PdfViewerController _pdfViewerController = PdfViewerController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
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
          // PDF Header
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
                // Zoom out button
                IconButton(
                  icon: const Icon(
                    Icons.zoom_out,
                    size: 20,
                  ),
                  onPressed: () {
                    _pdfViewerController.zoomLevel =
                        (_pdfViewerController.zoomLevel - 0.25)
                            .clamp(0.75, 3.0);
                  },
                ),
                // Zoom in button
                IconButton(
                  icon: const Icon(
                    Icons.zoom_in,
                    size: 20,
                  ),
                  onPressed: () {
                    _pdfViewerController.zoomLevel =
                        (_pdfViewerController.zoomLevel + 0.25)
                            .clamp(0.75, 3.0);
                  },
                ),
                // Open in browser button
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
          // PDF Content
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              child: Stack(
                children: [
                  SfPdfViewer.network(
                    widget.path,
                    controller: _pdfViewerController,
                    onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                      setState(() {
                        isLoading = false;
                      });
                    },
                    onDocumentLoadFailed:
                        (PdfDocumentLoadFailedDetails details) {
                      setState(() {
                        isLoading = false;
                        errorMessage = details.error;
                      });
                    },
                    enableDoubleTapZooming: true,
                    canShowScrollHead: false,
                    canShowScrollStatus: false,
                    pageSpacing: 8,
                    canShowPaginationDialog: false,
                  ),
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (!isLoading && errorMessage != null)
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading PDF',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              errorMessage!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

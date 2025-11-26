import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../services/pdf_service.dart';

class SignaturePlacementScreen extends StatefulWidget {
  final File pdfFile;
  final Uint8List signatureBytes;
  final int initialPage;

  const SignaturePlacementScreen({
    Key? key,
    required this.pdfFile,
    required this.signatureBytes,
    this.initialPage = 1,
  }) : super(key: key);

  @override
  _SignaturePlacementScreenState createState() =>
      _SignaturePlacementScreenState();
}

class _SignaturePlacementScreenState extends State<SignaturePlacementScreen> {
  final PdfService _pdfService = PdfService();
  final PdfViewerController _pdfViewerController = PdfViewerController();
  bool _isSaving = false;

  void _handleTap(PdfGestureDetails details) async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final File newFile = await _pdfService.addSignatureToPdf(
        widget.pdfFile,
        widget.signatureBytes,
        details.pageNumber - 1, // Syncfusion PDF uses 0-indexed pages
        details.pagePosition,
      );

      if (mounted) {
        Navigator.of(context).pop(); // Dismiss loading
        Navigator.of(context).pop(newFile); // Return signed file
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Dismiss loading
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error adding signature: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Place Signature',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: Stack(
        children: [
          SfPdfViewer.file(
            widget.pdfFile,
            controller: _pdfViewerController,
            onTap: _handleTap,
            onDocumentLoaded: (PdfDocumentLoadedDetails details) {
              _pdfViewerController.jumpToPage(widget.initialPage);
            },
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Tap anywhere on the PDF to place your signature',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

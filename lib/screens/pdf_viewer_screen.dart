import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../services/file_picker_service.dart';
import '../services/pdf_service.dart';
import '../widgets/signature_pad_widget.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({Key? key}) : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final FilePickerService _filePickerService = FilePickerService();
  final PdfService _pdfService = PdfService();
  final PdfViewerController _pdfViewerController = PdfViewerController();

  File? _currentFile;
  Uint8List? _pendingSignature;
  bool _isPlacingSignature = false;

  void _pickFile() async {
    final File? file = await _filePickerService.pickPdfFile();
    if (file != null) {
      setState(() {
        _currentFile = file;
        _isPlacingSignature = false;
        _pendingSignature = null;
      });
    }
  }

  void _openSignaturePad() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SignaturePadWidget(
        onSigned: (signatureBytes) {
          setState(() {
            _pendingSignature = signatureBytes;
            _isPlacingSignature = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tap anywhere on the PDF to place the signature.'),
              duration: Duration(seconds: 5),
            ),
          );
        },
      ),
    );
  }

  void _handleTap(PdfGestureDetails details) async {
    if (_isPlacingSignature && _pendingSignature != null && _currentFile != null) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final File newFile = await _pdfService.addSignatureToPdf(
          _currentFile!,
          _pendingSignature!,
          details.pageNumber - 1, // Syncfusion PDF uses 0-indexed pages
          details.pagePosition,
        );

        setState(() {
          _currentFile = newFile;
          _isPlacingSignature = false;
          _pendingSignature = null;
        });

        if (mounted) {
          Navigator.of(context).pop(); // Dismiss loading
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signature added successfully!')),
          );
        }
      } catch (e) {
        if (mounted) {
          Navigator.of(context).pop(); // Dismiss loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error adding signature: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Signer'),
        actions: [
          if (_currentFile != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _openSignaturePad,
              tooltip: 'Add Signature',
            ),
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: _pickFile,
            tooltip: 'Pick PDF',
          ),
        ],
      ),
      body: _currentFile == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No PDF selected'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickFile,
                    child: const Text('Pick PDF File'),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                SfPdfViewer.file(
                  _currentFile!,
                  controller: _pdfViewerController,
                  onTap: _handleTap,
                ),
                if (_isPlacingSignature)
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.yellowAccent,
                      child: const Text(
                        'Tap on the PDF to place your signature',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

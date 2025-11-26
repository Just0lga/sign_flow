import 'dart:io';
import 'dart:typed_data';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../services/file_picker_service.dart';
import '../services/pdf_service.dart';
import '../widgets/signature_pad_widget.dart';
import 'signature_placement_screen.dart';

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
  int? _jumpToPageOnLoad;

  void _pickFile() async {
    final File? file = await _filePickerService.pickPdfFile();
    if (file != null) {
      setState(() {
        _currentFile = file;
      });
    }
  }

  void _openSignaturePad() async {
    // Capture current page before opening dialog
    final int currentPage = _pdfViewerController.pageNumber;

    final signatureBytes = await showModalBottomSheet<Uint8List>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const SignaturePadWidget(),
    );

    if (signatureBytes != null && _currentFile != null && mounted) {
      final File? signedFile = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignaturePlacementScreen(
            pdfFile: _currentFile!,
            signatureBytes: signatureBytes,
            initialPage: currentPage,
          ),
        ),
      );

      if (signedFile != null) {
        setState(() {
          _currentFile = signedFile;
          _jumpToPageOnLoad = currentPage; // Restore page number
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signature added successfully!')),
          );
        }
      }
    }
  }

  void _shareFile() async {
    if (_currentFile != null) {
      await Share.shareXFiles([
        XFile(_currentFile!.path),
      ], text: 'Here is my signed document.');
    }
  }

  Future<void> _downloadFile() async {
    if (_currentFile == null) return;

    try {
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }

        if (status.isGranted) {
          final directory = Directory('/storage/emulated/0/Download');
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }

          final fileName =
              'signed_document_${DateTime.now().millisecondsSinceEpoch}.pdf';
          final newPath = '${directory.path}/$fileName';

          await _currentFile!.copy(newPath);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Saved to Downloads: $fileName')),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Storage permission denied')),
            );
          }
        }
      } else {
        // iOS and others
        _shareFile();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Use "Save to Files" to download.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error downloading: $e')));
      }
    }
  }

  void _handleTap(PdfGestureDetails details) {
    // No longer handling signature placement here
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          if (_currentFile != null) ...[
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _shareFile,
              tooltip: 'Share',
            ),
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: _downloadFile,
              tooltip: 'Download',
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _openSignaturePad,
              tooltip: 'Add Signature',
            ),
          ],
        ],
        leading: _currentFile == null
            ? null
            : IconButton(
                onPressed: () {
                  setState(() {
                    _currentFile = null;
                  });
                },
                icon: Icon(Icons.arrow_back_ios_new),
              ),
      ),
      body: _currentFile == null
          ? SafeArea(
              child: Column(
                children: [
                  Image.asset("assets/galaxy.gif"),
                  Text(
                    'Sign Flow',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 48,
                    ),
                  ),
                  Text(
                    'Sign your documents easily',
                    style: GoogleFonts.poppins(
                      color: const Color.fromARGB(255, 130, 130, 130),
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: _pickFile,
                    child: Container(
                      width: width * 0.94,
                      height: width * 0.14,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 13, 20, 100),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(
                              255,
                              13,
                              20,
                              100,
                            ).withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 1,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      alignment: Alignment.center,
                      child: Text(
                        'Pick PDF File',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Text(
                    "By pressing on 'Pick PDF File' you agree",
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: const Color.fromARGB(255, 130, 130, 130),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "to our ",
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: const Color.fromARGB(255, 130, 130, 130),
                        ),
                      ),
                      Text(
                        "Terms of Service",
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                      Text(
                        " and ",
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: const Color.fromARGB(255, 130, 130, 130),
                        ),
                      ),
                      Text(
                        "Privacy Policy",
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : SfPdfViewer.file(
              _currentFile!,
              controller: _pdfViewerController,
              onTap: _handleTap,
              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                if (_jumpToPageOnLoad != null) {
                  _pdfViewerController.jumpToPage(_jumpToPageOnLoad!);
                  _jumpToPageOnLoad = null;
                }
              },
            ),
    );
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sign_flow/pdf_service.dart';
import 'package:sign_flow/signature_pad_widget.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'app_colors.dart'; // <-- RENKLERİ BURADAN ALIYOR

class PdfEditorScreen extends StatefulWidget {
  final File file;

  const PdfEditorScreen({Key? key, required this.file}) : super(key: key);

  @override
  _PdfEditorScreenState createState() => _PdfEditorScreenState();
}

class _PdfEditorScreenState extends State<PdfEditorScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final PdfService _pdfService = PdfService();

  late File _currentFile;
  File? _viewFile;

  bool _isLoading = true;
  List<Size>? _pageSizes;
  int? _jumpToPageOnLoad;

  @override
  void initState() {
    super.initState();
    _currentFile = widget.file;
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    setState(() => _isLoading = true);

    try {
      final viewFile = await _pdfService.generateViewDataWithBoxes(
        _currentFile,
      );
      final sizes = await _pdfService.getAllPageSizes(_currentFile);

      setState(() {
        _viewFile = viewFile;
        _pageSizes = sizes;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error initializing PDF screen: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshView() async {
    setState(() => _isLoading = true);
    try {
      final viewFile = await _pdfService.generateViewDataWithBoxes(
        _currentFile,
      );
      setState(() {
        _viewFile = viewFile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Rect _getBoxRect(Size pageSize) {
    const double boxWidth = 150.0;
    const double boxHeight = 75.0;
    const double padding = 20.0;

    double x = pageSize.width - padding - boxWidth;
    double y = pageSize.height - padding - boxHeight;

    return Rect.fromLTWH(x, y, boxWidth, boxHeight);
  }

  void _onPdfTap(PdfGestureDetails details) async {
    if (_pageSizes == null) return;

    final int pageIndex = details.pageNumber - 1;
    if (pageIndex < 0 || pageIndex >= _pageSizes!.length) return;

    final Size pageSize = _pageSizes![pageIndex];
    final Offset tapPos = details.pagePosition;

    final Rect boxRect = _getBoxRect(pageSize);

    if (boxRect.inflate(10).contains(tapPos)) {
      _openSignaturePad(pageIndex: pageIndex);
    }
  }

  void _openSignaturePad({int? pageIndex}) async {
    final int targetPageIndex =
        pageIndex ?? (_pdfViewerController.pageNumber - 1);
    if (_pageSizes == null || targetPageIndex >= _pageSizes!.length) return;

    final Size pageSize = _pageSizes![targetPageIndex];

    final signatureBytes = await showModalBottomSheet<Uint8List>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundLight,
      builder: (context) => const SignaturePadWidget(),
    );

    if (signatureBytes != null && mounted) {
      setState(() => _isLoading = true);

      try {
        final Rect boxRect = _getBoxRect(pageSize);
        final Offset targetCenter = boxRect.center;

        final Size signatureSize = Size(150, 75);

        final File signedFile = await _pdfService.addSignatureToPdf(
          _currentFile,
          signatureBytes,
          targetPageIndex,
          targetCenter,
          signatureSize,
        );

        setState(() {
          _currentFile = signedFile;
          _jumpToPageOnLoad = targetPageIndex + 1;
        });

        await _refreshView();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: const Text('İmza başarıyla eklendi!'),
              backgroundColor: AppColors.accentGreen,
            ),
          );
        }
      } catch (e) {
        debugPrint('Error signing: $e');
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Hata: $e'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
  }

  void _shareFile() async {
    await Share.shareXFiles([
      XFile(_currentFile.path),
    ], text: 'İşte imzalı belgem.');
  }

  Future<void> _downloadFile() async {
    try {
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) status = await Permission.storage.request();

        if (status.isGranted) {
          final directory = Directory('/storage/emulated/0/Download');
          if (!await directory.exists())
            await directory.create(recursive: true);

          final fileName =
              'signed_document_${DateTime.now().millisecondsSinceEpoch}.pdf';
          final newPath = '${directory.path}/$fileName';
          await _currentFile.copy(newPath);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text('İndirilenlere kaydedildi: $fileName'),
                backgroundColor: AppColors.accentGreen,
              ),
            );
          }
        }
      } else {
        _shareFile();
      }
    } catch (e) {
      debugPrint('Download error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _viewFile == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryGreen),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,

      body: SafeArea(
        child: Stack(
          children: [
            SfPdfViewer.file(
              _viewFile!,
              key: ValueKey(_viewFile!.path),
              controller: _pdfViewerController,
              canShowScrollHead: true,
              canShowScrollStatus: true,
              onTap: _onPdfTap,
              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                if (_jumpToPageOnLoad != null) {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    _pdfViewerController.jumpToPage(_jumpToPageOnLoad!);
                    _jumpToPageOnLoad = null;
                  });
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor:
                          AppColors.primaryGreen, // butonun arka planı
                      shape: const CircleBorder(), // yuvarlak
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white, // ikon beyaz
                    ),
                  ),

                  Expanded(child: SizedBox()),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor:
                          AppColors.primaryGreen, // butonun arka planı
                      shape: const CircleBorder(), // yuvarlak
                    ),
                    onPressed: _shareFile,
                    icon: const Icon(
                      Icons.share,
                      color: Colors.white, // ikon beyaz
                    ),
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor:
                          AppColors.primaryGreen, // butonun arka planı
                      shape: const CircleBorder(), // yuvarlak
                    ),
                    onPressed: _openSignaturePad,
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white, // ikon beyaz
                    ),
                  ),

                  /*IconButton(
                    icon: Icon(Icons.download),
                    onPressed: _downloadFile,
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

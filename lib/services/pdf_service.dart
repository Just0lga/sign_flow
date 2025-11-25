import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfService {
  /// Adds a signature image to the specified page and position in the PDF.
  /// Returns a new [File] containing the signed PDF.
  Future<File> addSignatureToPdf(
    File pdfFile,
    Uint8List signatureData,
    int pageNumber,
    Offset position,
  ) async {
    // Load the existing PDF document.
    final PdfDocument document =
        PdfDocument(inputBytes: await pdfFile.readAsBytes());

    // Get the specific page.
    // Note: pageNumber is 0-indexed in Syncfusion PdfDocument, but usually 1-indexed in UI.
    // We assume the caller passes a 0-indexed page number or we adjust here.
    // Let's assume the caller passes 1-indexed for UI friendliness, so we subtract 1.
    final PdfPage page = document.pages[pageNumber];

    // Create a PDF bitmap from the signature data.
    final PdfBitmap signatureImage = PdfBitmap(signatureData);

    // Draw the signature on the page.
    // We might need to adjust the size. For now, let's use a default size or the image's size.
    // Let's say we want the signature to be reasonable size, e.g., 100x50, or preserve aspect ratio.
    // For simplicity, let's draw it at the tapped position with a fixed width, preserving aspect ratio.
    const double signatureWidth = 100.0;
    final double aspectRatio = signatureImage.width / signatureImage.height;
    final double signatureHeight = signatureWidth / aspectRatio;

    // Adjust position to center the signature on the tap point
    final double x = position.dx - (signatureWidth / 2);
    final double y = position.dy - (signatureHeight / 2);

    page.graphics.drawImage(
      signatureImage,
      Rect.fromLTWH(x, y, signatureWidth, signatureHeight),
    );

    // Save the document.
    final List<int> bytes = await document.save();
    document.dispose();

    // Write to a temporary file.
    final Directory dir = await getTemporaryDirectory();
    final String path = '${dir.path}/signed_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final File file = File(path);
    await file.writeAsBytes(bytes, flush: true);

    return file;
  }
}

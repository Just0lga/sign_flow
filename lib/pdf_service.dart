import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfService {
  Future<File> addSignatureToPdf(
    File pdfFile,
    Uint8List signatureData,
    int pageNumber,
    Offset position,
    Size signatureSize,
  ) async {
    // 1. Load the existing PDF document
    final RandomAccessFile raf = pdfFile.openSync(mode: FileMode.read);
    final List<int> bytes = raf.readSync(raf.lengthSync());
    raf.closeSync();

    final PdfDocument document = PdfDocument(inputBytes: bytes);

    // 2. Create a signature field
    final PdfPage page = document.pages[pageNumber];

    // Position
    final double signatureWidth = signatureSize.width;
    final double signatureHeight = signatureSize.height;
    final double x = position.dx - (signatureWidth / 2);
    final double y = position.dy - (signatureHeight / 2);

    // Unique name
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String fieldName = "Imza_$timestamp";

    final PdfSignatureField signatureField = PdfSignatureField(
      page,
      fieldName,
      bounds: Rect.fromLTWH(x, y, signatureWidth, signatureHeight),
      signature: PdfSignature(
        // Certificate
        certificate: PdfCertificate(
          (await rootBundle.load(
            "assets/certificate.pfx",
          )).buffer.asUint8List(),
          "1234zxcv",
        ),
        contactInfo: "info@proaktif01.com",
        locationInfo: "Türkiye",
        reason: "Bu döküman Sign Flow tarafından imzalandı",
        digestAlgorithm: DigestAlgorithm.sha256,
        cryptographicStandard: CryptographicStandard.cms,
      ),
    );

    // 3. Set the visual appearance (the user's signature image)
    final PdfBitmap signatureImage = PdfBitmap(signatureData);
    signatureField.appearance.normal.graphics?.drawImage(
      signatureImage,
      Rect.fromLTWH(0, 0, signatureWidth, signatureHeight),
    );

    // add the field to doc
    document.form.fields.add(signatureField);

    // 4. Save the document incrementally
    // Synfucuion automatically performs incremental update when fields are signed
    final List<int> signedBytes = await document.save();
    document.dispose();

    final Directory dir = await getTemporaryDirectory();
    final String path = "${dir.path}/signed_$timestamp.pdf";
    final File file = File(path);
    await file.writeAsBytes(signedBytes, flush: true);

    return file;
  }

  Future<List<Size>> getAllPageSizes(File pdfFile) async {
    final PdfDocument document = PdfDocument(
      inputBytes: await pdfFile.readAsBytes(),
    );
    int count = document.pages.count;
    List<Size> sizes = [];

    for (int i = 0; i < count; i++) {
      sizes.add(document.pages[i].size);
    }
    document.dispose();
    return sizes;
  }

  Future<File> generateViewDataWithBoxes(File pdfFile) async {
    final PdfDocument document = PdfDocument(
      inputBytes: await pdfFile.readAsBytes(),
    );

    // Box properties
    const double boxWidth = 150;
    const double boxHeight = 75;
    const double padding = 20;

    // Create a pen for drawing
    final PdfPen pen = PdfPen(PdfColor(3, 87, 66), width: 2);
    //final PdfBrush brush = PdfSolidBrush(PdfColor(3, 87, 66));

    int count = document.pages.count;

    for (int i = 0; i < count; i++) {
      final PdfPage page = document.pages[i];
      final Size pageSize = page.size;

      double x = pageSize.width - padding - boxWidth;
      double y = pageSize.height - padding - boxHeight;

      // Draw the box
      page.graphics.drawRectangle(
        pen: pen,
        //brush: brush,
        bounds: Rect.fromLTWH(x, y, boxWidth, boxHeight),
      );
    }
    // Save to temp file
    final List<int> bytes = await document.save();
    document.dispose();

    final Directory dir = await getTemporaryDirectory();
    final String path =
        '${dir.path}/view_layer_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final File file = File(path);
    await file.writeAsBytes(bytes, flush: true);

    return file;
  }
}

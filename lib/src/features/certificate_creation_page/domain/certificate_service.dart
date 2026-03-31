import 'dart:io';

import 'package:flutter/foundation.dart'; // Required for compute
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class CertificateService {
  Future<void> fillAndShareCertificate({
    required String employeeName,
    required String jobRole,
    required String startDate,
    required String endDate,
  }) async {
    try {
      // 1. Load the template bytes on the main thread
      final ByteData data = await rootBundle.load(
        'assets/certificate/experience_certificate.pdf',
      );
      final Uint8List templateBytes = data.buffer.asUint8List();

      // 2. Use an Isolate (compute) to generate the PDF bytes
      // This prevents the "Skipped frames" warning by moving CPU work off the main thread
      final List<int> pdfBytes = await compute(_generatePdfIsolate, {
        'templateBytes': templateBytes,
        'employeeName': employeeName,
        'jobRole': jobRole,
        'startDate': startDate,
        'endDate': endDate,
      });

      // 3. Save to temporary directory
      final Directory directory = await getTemporaryDirectory();
      final String filePath =
          '${directory.path}/${employeeName.replaceAll(' ', '_')}_Certificate.pdf';
      final File file = File(filePath);

      await file.writeAsBytes(pdfBytes, flush: true);

      // 4. Correct Share API
      // Share.shareXFiles is the recommended way for share_plus 12.x
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: 'Here is the experience certificate for $employeeName.',
        ),
      );
      // await Share.shareXFiles(
      //   [XFile(file.path)],
      //   subject: 'Experience Certificate for $employeeName',
      //   text: 'Here is the experience certificate for $employeeName.',
      // );
    } catch (e) {
      debugPrint("Certificate Error: $e");
      throw Exception("Error generating or sharing PDF: $e");
    }
  }
}

/// Top-level function for PDF generation in Isolate
/// Note: This must be a top-level or static function for 'compute' to work.
Future<List<int>> _generatePdfIsolate(Map<String, dynamic> params) async {
  final Uint8List templateBytes = params['templateBytes'];
  final String employeeName = params['employeeName'];
  final String jobRole = params['jobRole'];
  final String startDate = params['startDate'];
  final String endDate = params['endDate'];

  // Create document from template
  final PdfDocument document = PdfDocument(inputBytes: templateBytes);
  final PdfPage page = document.pages[0];
  final size = page.graphics.size;
  var Size(height: h, width: w) = size;

  // Configure fonts
  final PdfFont font = PdfStandardFont(
    PdfFontFamily.helvetica,
    45,
    style: PdfFontStyle.bold,
  );
  final PdfFont dateFont = PdfStandardFont(PdfFontFamily.helvetica, 35);

  // Draw text
  page.graphics.drawString(
    employeeName,
    font,
    bounds: Rect.fromLTWH(w * 0.162, h * 0.445, 1000, 140),
  );

  page.graphics.drawString(
    jobRole,
    font,
    bounds: Rect.fromLTWH(w * 0.733, h * 0.445, 1000, 140),
  );

  page.graphics.drawString(
    startDate,
    dateFont,
    bounds: Rect.fromLTWH(w * 0.237, h * 0.478, 400, 80),
  );

  page.graphics.drawString(
    endDate,
    dateFont,
    bounds: Rect.fromLTWH(w * 0.379875, h * 0.478, 400, 80),
  );

  // Save and dispose
  final List<int> bytes = await document.save();
  document.dispose();

  return bytes;
}

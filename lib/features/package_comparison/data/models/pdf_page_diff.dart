import 'dart:typed_data';

import 'package:doc_diff/features/package_comparison/data/models/pdf_page_diff_status.dart';

class PdfPageDiff {
  final int pageNumber;
  final Uint8List originalPage;
  final Uint8List updatedPage;
  final Uint8List? diffPage;
  final int diffPixels;
  final PdfPageDiffStatus status;

  PdfPageDiff({
    required this.pageNumber,
    required this.originalPage,
    required this.updatedPage,
    required this.diffPage,
    required this.diffPixels,
    required this.status,
  });

  bool get hasChanges => status == PdfPageDiffStatus.changed;
}

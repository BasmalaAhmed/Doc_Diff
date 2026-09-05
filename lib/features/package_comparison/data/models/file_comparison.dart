import 'package:doc_diff/features/package_comparison/data/models/file_comparison_status.dart';
import 'package:doc_diff/features/package_comparison/data/models/package_file.dart';
import 'package:doc_diff/features/package_comparison/data/models/pdf_diff_result.dart';

class FileComparison {
  final String relativePath;
  final FileComparisonStatus status;
  final PackageFile? originalFile;
  final PackageFile? updatedFile;
  final PdfDiffResult? pdfDiff;

  const FileComparison({
    required this.relativePath,
    required this.status,
    this.originalFile,
    this.updatedFile,
    this.pdfDiff,
  });
}

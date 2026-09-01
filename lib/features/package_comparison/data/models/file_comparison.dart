import 'package:doc_diff/features/package_comparison/data/models/file_comparison_status.dart';
import 'package:doc_diff/features/package_comparison/data/models/package_file.dart';

class FileComparison {
  final String relativePath;
  final FileComparisonStatus status;
  final PackageFile? originalFile;
  final PackageFile? updatedFile;

  const FileComparison({
    required this.relativePath,
    required this.status,
    this.originalFile,
    this.updatedFile,
  });
}

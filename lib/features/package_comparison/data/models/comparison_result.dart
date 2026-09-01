import 'package:doc_diff/features/package_comparison/data/models/file_comparison.dart';
import 'package:doc_diff/features/package_comparison/data/models/file_comparison_status.dart';

class ComparisonResult {
  final List<FileComparison> files;

  const ComparisonResult({required this.files});

  int get unchangedCount => files
      .where((file) => file.status == FileComparisonStatus.unchanged)
      .length;

  int get modifiedCount => files
      .where((file) => file.status == FileComparisonStatus.modified)
      .length;

  int get addedCount =>
      files.where((file) => file.status == FileComparisonStatus.added).length;

  int get removedCount =>
      files.where((file) => file.status == FileComparisonStatus.removed).length;
}

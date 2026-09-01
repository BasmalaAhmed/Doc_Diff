import 'package:doc_diff/core/services/hash_service.dart';
import 'package:doc_diff/features/package_comparison/data/models/comparison_result.dart';
import 'package:doc_diff/features/package_comparison/data/models/file_comparison.dart';
import 'package:doc_diff/features/package_comparison/data/models/file_comparison_status.dart';
import 'package:doc_diff/features/package_comparison/data/models/package_file.dart';

class ComparisonService {
  final HashService _hashService;

  ComparisonService(this._hashService);

  Future<ComparisonResult> compare({
    required List<PackageFile> originalFiles,
    required List<PackageFile> updatedFiles,
  }) async {
    final originalMap = {
      for (final file in originalFiles) file.relativePath: file,
    };

    final updatedMap = {
      for (final file in updatedFiles) file.relativePath: file,
    };

    final allPaths = {...originalMap.keys, ...updatedMap.keys};

    final comparisons = <FileComparison>[];

    for (final relativePath in allPaths) {
      final originalFile = originalMap[relativePath];
      final updatedFile = updatedMap[relativePath];

      if (originalFile != null && updatedFile != null) {
        final originalHash = await _hashService.calculateHash(
          originalFile.path,
        );

        final updatedHash = await _hashService.calculateHash(updatedFile.path);

        final status = originalHash == updatedHash
            ? FileComparisonStatus.unchanged
            : FileComparisonStatus.modified;

        comparisons.add(
          FileComparison(
            relativePath: relativePath,
            status: status,
            originalFile: originalFile,
            updatedFile: updatedFile,
          ),
        );
      } else if (originalFile != null) {
        comparisons.add(
          FileComparison(
            relativePath: relativePath,
            status: FileComparisonStatus.removed,
            originalFile: originalFile,
          ),
        );
      } else {
        comparisons.add(
          FileComparison(
            relativePath: relativePath,
            status: FileComparisonStatus.added,
            updatedFile: updatedFile,
          ),
        );
      }
    }
    return ComparisonResult(files: comparisons);
  }
}

import 'package:doc_diff/constants.dart';
import 'package:doc_diff/features/package_comparison/data/models/file_comparison.dart';
import 'package:doc_diff/features/package_comparison/data/models/file_comparison_status.dart';
import 'package:doc_diff/features/package_comparison/presentation/view/pdf_diff_view.dart';
import 'package:flutter/material.dart';

class ComparisonFileTile extends StatelessWidget {
  const ComparisonFileTile({super.key, required this.comparison});

  final FileComparison comparison;

  String get statusLabel {
    return switch (comparison.status) {
      FileComparisonStatus.unchanged => 'Unchanged',
      FileComparisonStatus.modified => 'Modified',
      FileComparisonStatus.added => 'Added',
      FileComparisonStatus.removed => 'Removed',
    };
  }

  IconData get statusIcon {
    return switch (comparison.status) {
      FileComparisonStatus.unchanged => Icons.check_circle_outline,
      FileComparisonStatus.modified => Icons.edit_outlined,
      FileComparisonStatus.added => Icons.add_circle_outline,
      FileComparisonStatus.removed => Icons.remove_circle_outline,
    };
  }

  Color get statusColor {
    return switch (comparison.status) {
      FileComparisonStatus.unchanged => kUnchangedColor,
      FileComparisonStatus.modified => kModifiedColor,
      FileComparisonStatus.added => kAddedColor,
      FileComparisonStatus.removed => kRemovedColor,
    };
  }

  Color get statusBorderColor {
    return switch (comparison.status) {
      FileComparisonStatus.unchanged => kUnchangedAccent,
      FileComparisonStatus.modified => kModifiedAccent,
      FileComparisonStatus.added => kAddedAccent,
      FileComparisonStatus.removed => kRemovedAccent,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: statusColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: statusBorderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap:
          canComparePdf
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PdfDiffView(
                        originalPdfPath: comparison.originalFile!.path,
                        updatedPdfPath: comparison.updatedFile!.path,
                      ),
                    ),
                  );
                }
              : null,
        
        leading: Icon(statusIcon, size: 28),
        title: Text(
          comparison.relativePath,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(statusLabel),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  bool get canComparePdf {
    final originalPath = comparison.originalFile?.path;
    final updatedPath = comparison.updatedFile?.path;

    if (originalPath == null || updatedPath == null) {
      return false;
    }

    return originalPath.toLowerCase().endsWith('.pdf') &&
        updatedPath.toLowerCase().endsWith('.pdf');
  }
}

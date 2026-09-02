import 'package:doc_diff/features/package_comparison/data/models/file_comparison.dart';
import 'package:doc_diff/features/package_comparison/data/models/file_comparison_status.dart';
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

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
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
}

import 'package:doc_diff/features/package_comparison/data/models/file_comparison.dart';
import 'package:doc_diff/features/package_comparison/data/models/file_comparison_status.dart';
import 'package:flutter/material.dart';

class ComparisonFileTile extends StatelessWidget {
  const ComparisonFileTile({super.key, required this.comparison});

  final FileComparison comparison;

  @override
  Widget build(BuildContext context) {
    final (icon, label) = switch (comparison.status) {
      FileComparisonStatus.unchanged => (
        Icons.check_circle_outline,
        'Unchanged',
      ),
      FileComparisonStatus.modified => (Icons.edit_outlined, 'Modified'),
      FileComparisonStatus.added => (Icons.add_circle_outline, 'Added'),
      FileComparisonStatus.removed => (Icons.remove_circle_outline, 'Removed'),
    };

    return ListTile(
      leading: Icon(icon),
      title: Text(comparison.relativePath),
      subtitle: Text(label),
    );
  }
}

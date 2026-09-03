import 'package:doc_diff/constants.dart';
import 'package:doc_diff/features/package_comparison/data/models/file_comparison_status.dart';
import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.label,
    required this.count,
    required this.status,
  });

  final String label;
  final int count;
  final FileComparisonStatus status;

  IconData get icon {
    return switch (status) {
      FileComparisonStatus.unchanged => Icons.check_circle_outline,
      FileComparisonStatus.modified => Icons.edit_outlined,
      FileComparisonStatus.added => Icons.add_circle_outline,
      FileComparisonStatus.removed => Icons.remove_circle_outline,
    };
  }

  Color get statusColor {
    return switch (status) {
      FileComparisonStatus.unchanged => kUnchangedColor,
      FileComparisonStatus.modified => kModifiedColor,
      FileComparisonStatus.added => kAddedColor,
      FileComparisonStatus.removed => kRemovedColor,
    };
  }

  Color get statusBorderColor {
    return switch (status) {
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
        borderRadius: BorderRadius.circular(12)
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(label),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

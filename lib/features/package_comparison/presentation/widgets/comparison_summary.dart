import 'package:doc_diff/features/package_comparison/data/models/comparison_result.dart';
import 'package:doc_diff/features/package_comparison/data/models/file_comparison_status.dart';
import 'package:doc_diff/features/package_comparison/presentation/widgets/summary_card.dart';
import 'package:flutter/material.dart';

class ComparisonSummary extends StatelessWidget {
  const ComparisonSummary({super.key, required this.result});

  final ComparisonResult result;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        label: 'Unchanged',
        count: result.unchangedCount,
        status: FileComparisonStatus.unchanged,
      ),
      (
        label: 'Modified',
        count: result.modifiedCount,
        status: FileComparisonStatus.modified,
      ),
      (
        label: 'Added',
        count: result.addedCount,
        status: FileComparisonStatus.added,
      ),
      (
        label: 'Removed',
        count: result.removedCount,
        status: FileComparisonStatus.removed,
      ),
    ];
    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Expanded(
            child: SummaryCard(
              label: items[i].label,
              count: items[i].count,
              status: items[i].status,
            ),
          ),
          if (i < items.length - 1) const SizedBox(width: 16),
        ],
      ],
    );
  }
}


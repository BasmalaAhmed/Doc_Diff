import 'package:doc_diff/features/package_comparison/data/models/comparison_filter.dart';
import 'package:doc_diff/features/package_comparison/data/models/comparison_result.dart';
import 'package:flutter/material.dart';

class ComparisonFilterSelector extends StatelessWidget {
  const ComparisonFilterSelector({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.result,
  });

  final ComparisonFilter selectedFilter;
  final ValueChanged<ComparisonFilter> onFilterChanged;
  final ComparisonResult result;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ComparisonFilter>(
      expandedInsets: EdgeInsets.zero,
      segments: [
        ButtonSegment(
          value: ComparisonFilter.all,
          label: Text('All (${result.files.length})'),
        ),
        ButtonSegment(
          value: ComparisonFilter.modified,
          label: Text('Modified (${result.modifiedCount})'),
        ),
        ButtonSegment(
          value: ComparisonFilter.added,
          label: Text('Added (${result.addedCount})'),
        ),
        ButtonSegment(
          value: ComparisonFilter.removed,
          label: Text('Removed (${result.removedCount})'),
        ),
        ButtonSegment(
          value: ComparisonFilter.unchanged,
          label: Text('Unchanged (${result.unchangedCount})'),
        ),
      ],
      selected: {selectedFilter},
      onSelectionChanged: (selection) {
        onFilterChanged(selection.first);
      },
    );
  }
}

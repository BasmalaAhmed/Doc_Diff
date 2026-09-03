import 'package:doc_diff/features/package_comparison/data/models/comparison_filter.dart';
import 'package:flutter/material.dart';


class ComparisonFilterSelector extends StatelessWidget {
  const ComparisonFilterSelector({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final ComparisonFilter selectedFilter;
  final ValueChanged<ComparisonFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ComparisonFilter>(
      expandedInsets: EdgeInsets.zero,
      segments: const [
        ButtonSegment(value: ComparisonFilter.all, label: Text('All')),
        ButtonSegment(
          value: ComparisonFilter.modified,
          label: Text('Modified'),
        ),
        ButtonSegment(value: ComparisonFilter.added, label: Text('Added')),
        ButtonSegment(value: ComparisonFilter.removed, label: Text('Removed')),
        ButtonSegment(
          value: ComparisonFilter.unchanged,
          label: Text('Unchanged'),
        ),
      ],
      selected: {selectedFilter},
      onSelectionChanged: (selection) {
        onFilterChanged(selection.first);
      },
    );
  }
}

import 'package:doc_diff/features/package_comparison/data/models/comparison_filter.dart';
import 'package:doc_diff/features/package_comparison/data/models/comparison_result.dart';
import 'package:doc_diff/features/package_comparison/data/models/file_comparison.dart';
import 'package:doc_diff/features/package_comparison/data/models/file_comparison_status.dart';
import 'package:doc_diff/features/package_comparison/presentation/widgets/comparison_file_tile.dart';
import 'package:doc_diff/features/package_comparison/presentation/widgets/comparison_filter_selector.dart';
import 'package:doc_diff/features/package_comparison/presentation/widgets/comparison_summary.dart';
import 'package:flutter/material.dart';

class ComparisonResults extends StatefulWidget {
  const ComparisonResults({
    super.key,
    required this.result,
    required this.searchQuery,
  });

  final ComparisonResult result;
  final String searchQuery;

  @override
  State<ComparisonResults> createState() => _ComparisonResultsState();
}

class _ComparisonResultsState extends State<ComparisonResults> {
  ComparisonFilter _selectedFilter = ComparisonFilter.all;

  List<FileComparison> get _filteredFiles {
    final query = widget.searchQuery.toLowerCase().trim();

    final searchFilteredFiles = widget.result.files.where((file) {
      return file.relativePath.toLowerCase().contains(query);
    }).toList();

    switch (_selectedFilter) {
      case ComparisonFilter.all:
        return searchFilteredFiles;
      case ComparisonFilter.modified:
        return searchFilteredFiles
            .where((file) => file.status == FileComparisonStatus.modified)
            .toList();
      case ComparisonFilter.added:
        return searchFilteredFiles
            .where((file) => file.status == FileComparisonStatus.added)
            .toList();
      case ComparisonFilter.removed:
        return searchFilteredFiles
            .where((file) => file.status == FileComparisonStatus.removed)
            .toList();
      case ComparisonFilter.unchanged:
        return searchFilteredFiles
            .where((file) => file.status == FileComparisonStatus.unchanged)
            .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comparison Results',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ComparisonSummary(result: widget.result),
        const SizedBox(height: 16),
        ComparisonFilterSelector(
          result: widget.result,
          selectedFilter: _selectedFilter,
          onFilterChanged: (filter) {
            setState(() {
              _selectedFilter = filter;
            });
          },
        ),
        const SizedBox(height: 24),
        Expanded(
          child: _filteredFiles.isEmpty
              ? Center(
                  child: Text(
                    widget.searchQuery.trim().isNotEmpty
                        ? 'No files match your search.'
                        : 'No ${_selectedFilter.name} files found.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              : ListView.builder(
                  itemCount: _filteredFiles.length,
                  itemBuilder: (context, index) {
                    return ComparisonFileTile(
                      comparison: _filteredFiles[index],
                    );
                  },
                ),
        ),
      ],
    );
  }
}

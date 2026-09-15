import 'package:doc_diff/core/service_locator.dart';
import 'package:doc_diff/features/package_comparison/data/models/pdf_diff_result.dart';
import 'package:doc_diff/features/package_comparison/data/models/pdf_page_diff.dart';
import 'package:doc_diff/features/package_comparison/data/models/pdf_page_diff_status.dart';
import 'package:doc_diff/features/package_comparison/data/models/pdf_page_filter.dart';
import 'package:doc_diff/features/package_comparison/presentation/manager/pdf_diff_cubit/pdf_diff_cubit.dart';
import 'package:doc_diff/features/package_comparison/presentation/manager/pdf_diff_cubit/pdf_diff_state.dart';
import 'package:doc_diff/features/package_comparison/presentation/widgets/pdf_diff_summary.dart';
import 'package:doc_diff/features/package_comparison/presentation/widgets/pdf_page_comparison.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PdfDiffView extends StatefulWidget {
  const PdfDiffView({
    super.key,
    required this.originalPdfPath,
    required this.updatedPdfPath,
  });

  final String originalPdfPath;
  final String updatedPdfPath;

  @override
  State<PdfDiffView> createState() => _PdfDiffViewState();
}

class _PdfDiffViewState extends State<PdfDiffView> {
  PdfPageFilter _selectedFilter = PdfPageFilter.all;

  List<PdfPageDiff> _getFilteredPages(PdfDiffResult result) {
    return switch (_selectedFilter) {
      PdfPageFilter.all => result.pages,
      PdfPageFilter.changed =>
        result.pages
            .where((page) => page.status == PdfPageDiffStatus.changed)
            .toList(),
      PdfPageFilter.added =>
        result.pages
            .where((page) => page.status == PdfPageDiffStatus.added)
            .toList(),
      PdfPageFilter.removed =>
        result.pages
            .where((page) => page.status == PdfPageDiffStatus.removed)
            .toList(),
      PdfPageFilter.unchanged =>
        result.pages
            .where((page) => page.status == PdfPageDiffStatus.unchanged)
            .toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PdfDiffCubit(sl())
        ..comparePdfs(
          originalPdfPath: widget.originalPdfPath,
          updatedPdfPath: widget.updatedPdfPath,
        ),
      child: Scaffold(
        appBar: AppBar(title: const Text('PDF Comparison')),
        body: BlocBuilder<PdfDiffCubit, PdfDiffState>(
          builder: (context, state) {
            return switch (state) {
              PdfDiffInitial() => const SizedBox.shrink(),

              PdfDiffLoading() => const Center(
                child: CircularProgressIndicator(),
              ),

              PdfDiffSuccess(:final result) => () {
                final filteredPages = _getFilteredPages(result);
                return Column(
                  children: [
                    PdfDiffSummary(result: result),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SegmentedButton<PdfPageFilter>(
                        expandedInsets: EdgeInsets.zero,
                        segments: const [
                          ButtonSegment(
                            value: PdfPageFilter.all,
                            label: Text('All'),
                          ),
                          ButtonSegment(
                            value: PdfPageFilter.changed,
                            label: Text('Changed'),
                          ),
                          ButtonSegment(
                            value: PdfPageFilter.added,
                            label: Text('Added'),
                          ),
                          ButtonSegment(
                            value: PdfPageFilter.removed,
                            label: Text('Removed'),
                          ),
                          ButtonSegment(
                            value: PdfPageFilter.unchanged,
                            label: Text('Unchanged'),
                          ),
                        ],
                        selected: {_selectedFilter},
                        onSelectionChanged: (selection) {
                          setState(() {
                            _selectedFilter = selection.first;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (filteredPages.isEmpty)
                      Expanded(
                        child: Center(
                          child: Text(
                            'No ${_selectedFilter.name} files found.',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredPages.length,
                          itemBuilder: (context, index) {
                            final page = filteredPages[index];

                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Page ${page.pageNumber}',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                        ),
                                        const Spacer(),
                                        Text(page.statusLabel),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    PdfPageComparison(
                                      originalPage: page.originalPage,
                                      updatedPage: page.updatedPage,
                                      diffPage: page.diffPage,
                                      status: page.status,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                );
              }(),

              PdfDiffFailure(:final message) => Center(child: Text(message)),
            };
          },
        ),
      ),
    );
  }
}

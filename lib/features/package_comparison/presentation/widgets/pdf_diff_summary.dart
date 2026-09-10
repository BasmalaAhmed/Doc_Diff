import 'package:doc_diff/features/package_comparison/data/models/pdf_diff_result.dart';
import 'package:doc_diff/features/package_comparison/data/models/pdf_page_diff_status.dart';
import 'package:doc_diff/features/package_comparison/presentation/widgets/summary_item.dart';
import 'package:flutter/material.dart';

class PdfDiffSummary extends StatelessWidget {
  const PdfDiffSummary({super.key, required this.result});

  final PdfDiffResult result;

  @override
  Widget build(BuildContext context) {
    final changedCount = result.pages
        .where((page) => page.status == PdfPageDiffStatus.changed)
        .length;
    final addedCount = result.pages
        .where((page) => page.status == PdfPageDiffStatus.added)
        .length;
    final removedCount = result.pages
        .where((page) => page.status == PdfPageDiffStatus.removed)
        .length;
    final unchangedCount = result.pages
        .where((page) => page.status == PdfPageDiffStatus.unchanged)
        .length;
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      elevation: 3,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Comparison Summary', style: Theme.of(context).textTheme.titleMedium,),
            const SizedBox(height: 16,),
            Wrap(
              spacing: 24,
              runSpacing: 12,
              children: [
                SummaryItem(label: 'Total Pages', count: result.pages.length,),
                SummaryItem(label: 'Changed', count: changedCount),
                SummaryItem(label: 'Added', count: addedCount),
                SummaryItem(label: 'Removed', count: removedCount),
                SummaryItem(label: 'Unchanged', count: unchangedCount),
              ],
            )
          ],
        ),
      ),
    );
  }
}

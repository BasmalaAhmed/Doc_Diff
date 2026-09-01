import 'package:doc_diff/features/package_comparison/data/models/comparison_result.dart';
import 'package:doc_diff/features/package_comparison/presentation/widgets/comparison_file_tile.dart';
import 'package:flutter/material.dart';

class ComparisonResults extends StatelessWidget {
  const ComparisonResults({super.key, required this.result});

  final ComparisonResult result;

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
        Text(
          '${result.unchangedCount} unchanged • '
          '${result.modifiedCount} modified • '
          '${result.addedCount} added • '
          '${result.removedCount} removed ',
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: result.files.length,
            itemBuilder: (context, index) {
              return ComparisonFileTile(
                comparison: result.files[index]);
            },
          ),
        ),
      ],
    );
  }
}

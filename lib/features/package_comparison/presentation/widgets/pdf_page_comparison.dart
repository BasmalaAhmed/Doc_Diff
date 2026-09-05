import 'dart:typed_data';

import 'package:doc_diff/features/package_comparison/data/models/pdf_page_diff_status.dart';
import 'package:doc_diff/features/package_comparison/presentation/widgets/comparison_image.dart';
import 'package:doc_diff/features/package_comparison/presentation/widgets/single_page_comparison.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PdfPageComparison extends StatelessWidget {
  const PdfPageComparison({
    super.key,
    required this.status,
    required this.originalPage,
    required this.updatedPage,
    this.diffPage,
  });

  final PdfPageDiffStatus status;
  final Uint8List? originalPage;
  final Uint8List? updatedPage;
  final Uint8List? diffPage;

  @override
  Widget build(BuildContext context) {
    if(status == PdfPageDiffStatus.added){
      return SinglePageComparison(title: 'Updated', image: updatedPage,);
    }

    if (status == PdfPageDiffStatus.removed){
      return SinglePageComparison(title: 'Original', image: originalPage,);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ComparisonImage(title: 'Original', image: originalPage),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ComparisonImage(title: 'Updated', image: updatedPage),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ComparisonImage(title: 'Difference', image: diffPage),
        ),
      ],
    );
  }
}


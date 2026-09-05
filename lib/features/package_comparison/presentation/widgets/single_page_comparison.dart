import 'dart:typed_data';

import 'package:doc_diff/features/package_comparison/presentation/widgets/comparison_image.dart';
import 'package:flutter/widgets.dart';

class SinglePageComparison extends StatelessWidget {
  const SinglePageComparison({super.key, required this.title, required this.image});

  final String title;
  final Uint8List? image;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        child: ComparisonImage(title: title, image: image),
      ),
    );
  }
}
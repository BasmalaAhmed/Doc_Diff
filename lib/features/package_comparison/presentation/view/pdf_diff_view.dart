import 'package:flutter/material.dart';

class PdfDiffView extends StatelessWidget {
  const PdfDiffView({
    super.key,
    required this.originalPdfPath,
    required this.updatedPdfPath,
  });

  final String originalPdfPath;
  final String updatedPdfPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Comparison'),
      ),
      body: const Center(
        child: Text('PDF Comparison'),
      ),
    );
  }
}

import 'package:doc_diff_app/features/comparison/presentation/widgets/start_comparison_button.dart';
import 'package:flutter/material.dart';

class StartComparisonSection extends StatelessWidget {
  const StartComparisonSection({
    super.key,
    required this.canCompare,
    required this.onStart,
  });
  final bool canCompare;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        StartComparisonButton(
          canCompare: canCompare,
          onStart: onStart,
        ),
        const SizedBox(height: 12),
        Text(
          canCompare
              ? 'Ready to compare'
              : 'Select both files to start comparing',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'IBM Plex Sans',
                fontSize: 14,
                color: Color(0XFF60646F)
              ),
        ),
      ],
    );
  }
}

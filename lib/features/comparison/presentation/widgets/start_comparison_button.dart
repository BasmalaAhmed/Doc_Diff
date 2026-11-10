import 'package:flutter/material.dart';

class StartComparisonButton extends StatelessWidget {
  const StartComparisonButton({
    super.key,
    required this.canCompare,
    required this.onStart,
  });

  final bool canCompare;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 640;
          final buttonWidth = isMobile ? constraints.maxWidth : 300.0;
          return SizedBox(
            width: buttonWidth,
            height: 50,
            child: FilledButton(
              onPressed: canCompare ? onStart : null,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0XFF0062A1),
                disabledBackgroundColor: const Color(0XFF7AACCD),
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Start comparison'),
            ),
          );
        },
      ),
    );
  }
}

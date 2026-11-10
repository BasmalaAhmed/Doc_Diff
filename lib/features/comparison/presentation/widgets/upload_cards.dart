import 'package:doc_diff_app/features/comparison/presentation/widgets/custom_upload_card.dart';
import 'package:flutter/material.dart';

class UploadCards extends StatelessWidget {
  const UploadCards({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;

        final cards = const [
          CustomUploadCard(badge: 'A', title: 'Original file'),
          CustomUploadCard(badge: 'B', title: 'Updated file'),
        ];

        if (isMobile) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Column(
                children: [cards[0], const SizedBox(height: 16), cards[1]],
              ),
            ),
          );
        }

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: cards[0]),
                SizedBox(width: 30),
                Expanded(child: cards[1]),
              ],
            ),
          ),
        );
      },
    );
  }
}

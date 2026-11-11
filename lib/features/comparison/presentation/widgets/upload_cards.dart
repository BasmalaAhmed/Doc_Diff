import 'package:doc_diff_app/features/comparison/presentation/widgets/custom_upload_card.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadCards extends StatelessWidget {
  const UploadCards({
    super.key,
    required this.originalFile,
    required this.updatedFile,
    required this.onPickOriginal,
    required this.onPickUpdated,
    required this.onRemoveOriginal,
    required this.onRemoveUpdated,
  });

  final PlatformFile? originalFile, updatedFile;
  final VoidCallback onPickOriginal, onPickUpdated;
  final VoidCallback onRemoveOriginal, onRemoveUpdated;

  String _formatFileSize(PlatformFile? file) {
    final bytes = file?.lengthSync();
    if (bytes == null) return '';
    final mb = bytes / (1024 * 1024);
    return '${mb.toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;

        final cards = [
          CustomUploadCard(
            badge: 'A',
            title: 'Original file',
            fileName: originalFile?.name,
            fileSize: _formatFileSize(originalFile),
            onChoose: onPickOriginal,
            onRemove: onRemoveOriginal,
          ),
          CustomUploadCard(
            badge: 'B',
            title: 'Updated file',
            fileName: updatedFile?.name,
            fileSize: _formatFileSize(updatedFile),
            onChoose: onPickUpdated,
            onRemove: onRemoveUpdated,
          ),
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

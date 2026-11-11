import 'package:doc_diff_app/features/comparison/presentation/widgets/start_comparison_section.dart';
import 'package:doc_diff_app/features/comparison/presentation/widgets/upload_cards.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  PlatformFile? originalFile;
  PlatformFile? updatedFile;

  Future<void> pickPdf({required bool isOriginal}) async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
    );

    if (!mounted || file == null) return;

    final sizeInBytes = file.lengthSync() ?? await file.length();
    if (sizeInBytes == null) return;

    if (sizeInBytes > 50 * 1024 * 1024) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The file size must not exceed 50 MB.')),
      );
      return;
    }

    setState(() {
      if (isOriginal) {
        originalFile = file;
      } else {
        updatedFile = file;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Compare two PDFs visually',
                style: TextStyle(
                  fontSize: isMobile ? 24 : 36,
                  color: Color(0XFF101C28),
                  fontWeight: FontWeight.w700,
                  fontFamily: 'IBM Plex Sans',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Choose the original and updated versions to see the differences on every page.',
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: Color(0XFF5B646F),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'IBM Plex Sans',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 38),
              UploadCards(
                originalFile: originalFile,
                updatedFile: updatedFile,
                onPickOriginal: () => pickPdf(isOriginal: true),
                onPickUpdated: () => pickPdf(isOriginal: false),
                onRemoveOriginal: () => setState(() => originalFile = null),
                onRemoveUpdated: () => setState(() => updatedFile = null),
              ),
              SizedBox(height: 40),
              StartComparisonSection(
                canCompare: originalFile != null && updatedFile != null,
                onStart: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}

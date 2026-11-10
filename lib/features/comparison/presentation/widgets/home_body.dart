import 'package:doc_diff_app/features/comparison/presentation/widgets/upload_cards.dart';
import 'package:flutter/material.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

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
              UploadCards(),
            ],
          ),
        );
      }
    );
  }
}

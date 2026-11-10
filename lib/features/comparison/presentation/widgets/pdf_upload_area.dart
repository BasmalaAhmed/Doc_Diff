import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PdfUploadArea extends StatefulWidget {
  const PdfUploadArea({super.key});

  @override
  State<PdfUploadArea> createState() => _PdfUploadAreaState();
}

class _PdfUploadAreaState extends State<PdfUploadArea> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    const blue = Color(0XFF0062A1);
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          color: isHovered ? blue : const Color(0XFFDDE2E6),
          strokeWidth: isHovered ? 2 : 1.5,
          dashPattern: [3, 3],
          radius: const Radius.circular(9),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          height: 222,
          color: isHovered ? const Color(0xFFEDF6FD) : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: Color(0XFFDBEEFF),
                ),
                child: FaIcon(FontAwesomeIcons.upload, color: blue, size: 20),
              ),
              SizedBox(height: 12),
              Text(
                'Choose PDF file',
                style: TextStyle(
                  color: blue,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'IBM Plex Sans',
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'PDF only · Up to 50 MB',
                style: TextStyle(
                  color: Color(0XFF5B646F),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'IBM Plex Sans',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

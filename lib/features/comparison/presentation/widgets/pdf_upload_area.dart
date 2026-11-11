import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PdfUploadArea extends StatefulWidget {
  const PdfUploadArea({
    super.key,
    required this.onChoose,
    this.fileName,
    required this.onRemove,
    this.fileSize,
  });
  final VoidCallback onChoose;
  final VoidCallback onRemove;
  final String? fileName;
  final String? fileSize;

  @override
  State<PdfUploadArea> createState() => _PdfUploadAreaState();
}

class _PdfUploadAreaState extends State<PdfUploadArea> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    const blue = Color(0XFF0062A1);

    if (widget.fileName != null) {
      return Container(
        height: 96,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0XFFF6F8F9),
          border: Border.all(color: const Color(0XFFDDE2E6)),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0XFFFFE5E1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.picture_as_pdf_outlined,
                color: Color(0XFFC92F33),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.fileName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'IBM Plex Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.fileSize ?? '',
                    style: const TextStyle(
                      color: Color(0XFF5B646F),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: widget.onChoose,
              icon: const Icon(Icons.refresh),
              tooltip: 'Replace file',
            ),
            IconButton(
              onPressed: widget.onRemove,
              icon: const Icon(Icons.close),
              tooltip: 'Remove file',
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: widget.onChoose,
      child: MouseRegion(
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
      ),
    );
  }
}

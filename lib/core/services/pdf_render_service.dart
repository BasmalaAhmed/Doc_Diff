import 'dart:typed_data';

import 'package:pdfx/pdfx.dart';

class PdfRenderService {
  Future<List<Uint8List>> renderPages(String pdfPath,{double scale = 2.0}) async {
    final document = await PdfDocument.openFile(pdfPath);

    try {
      final pages = <Uint8List>[];

      for (
        var pageNumber = 1;
        pageNumber <= document.pagesCount;
        pageNumber++
      ) {
        final page = await document.getPage(pageNumber);

        try {
          final image = await page.render(
            width: page.width * scale,
            height: page.height * scale,
            format: PdfPageImageFormat.png,
          );

          if (image != null) {
            pages.add(image.bytes);
          }
        } finally {
          await page.close();
        }
      }
      return pages;
    } finally {
      await document.close();
    }
  }
}

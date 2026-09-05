import 'dart:typed_data';

import 'package:doc_diff/core/services/pdf_render_service.dart';
import 'package:doc_diff/features/package_comparison/data/models/pdf_diff_result.dart';
import 'package:doc_diff/features/package_comparison/data/models/pdf_page_diff.dart';
import 'package:doc_diff/features/package_comparison/data/models/pdf_page_diff_status.dart';
import 'package:image/image.dart' as img;
import 'package:pixelmatch/pixelmatch.dart';

class PdfDiffService {
  final PdfRenderService _pdfRenderService;

  PdfDiffService(this._pdfRenderService);

  Future<PdfDiffResult> compare({
    required String originalPdfPath,
    required String updatedPdfPath,
  }) async {
    final originalPages = await _pdfRenderService.renderPages(originalPdfPath);

    final updatedPages = await _pdfRenderService.renderPages(updatedPdfPath);

    final pageCount = originalPages.length > updatedPages.length
        ? originalPages.length
        : updatedPages.length;

    final pages = <PdfPageDiff>[];

    for (var i = 0; i < pageCount; i++) {
      final hasOriginalPage = i < originalPages.length;
      final hasUpdatedPage = i < updatedPages.length;

      if (hasOriginalPage && hasUpdatedPage) {
        final diff = _comparePage(
          originalPage: originalPages[i],
          updatedPage: updatedPages[i],
        );

        pages.add(
          PdfPageDiff(
            pageNumber: i + 1,
            originalPage: originalPages[i],
            updatedPage: updatedPages[i],
            diffPage: diff.diffImage,
            diffPixels: diff.diffPixels,
            status: diff.status,
          ),
        );
      } else if (hasOriginalPage) {
        pages.add(
        PdfPageDiff(
          pageNumber: i + 1,
          originalPage: originalPages[i],
          updatedPage: null,
          diffPage: null,
          diffPixels: 0,
          status: PdfPageDiffStatus.removed,
        ),
      );
      } else {
        pages.add(
        PdfPageDiff(
          pageNumber: i + 1,
          originalPage: null,
          updatedPage: updatedPages[i],
          diffPage: null,
          diffPixels: 0,
          status: PdfPageDiffStatus.added,
        ),
      );
      }
    }

    return PdfDiffResult(pages: pages);
  }

  _PageComparison _comparePage({
    required Uint8List originalPage,
    required Uint8List updatedPage,
  }) {
    final originalImage = img
        .decodeImage(originalPage)
        ?.convert(numChannels: 4);
    final updatedImage = img.decodeImage(updatedPage)?.convert(numChannels: 4);

    if (originalImage == null || updatedImage == null) {
      return _PageComparison(
        diffImage: null,
        diffPixels: 0,
        status: PdfPageDiffStatus.cannotCompare,
      );
    }

    final diffImage = img.Image(
      width: originalImage.width,
      height: originalImage.height,
      numChannels: 4,
    );

    final diffPixels = pixelmatch(
      originalImage.getBytes(),
      updatedImage.getBytes(),
      diffImage.getBytes(),
      originalImage.width,
      originalImage.height,
      {'threshold': 0.1},
    );

    return _PageComparison(
      diffImage: Uint8List.fromList(img.encodePng(diffImage)),
      diffPixels: diffPixels,
      status: diffPixels > 0
          ? PdfPageDiffStatus.changed
          : PdfPageDiffStatus.unchanged,
    );
  }
}

class _PageComparison {
  final Uint8List? diffImage;
  final int diffPixels;
  final PdfPageDiffStatus status;

  _PageComparison({
    required this.diffImage,
    required this.diffPixels,
    required this.status,
  });
}

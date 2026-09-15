import 'dart:typed_data';

import 'package:doc_diff/core/config/diff_config.dart';
import 'package:doc_diff/core/services/image_decoder_service.dart';
import 'package:doc_diff/core/services/pdf_render_service.dart';
import 'package:doc_diff/features/package_comparison/data/models/pdf_diff_result.dart';
import 'package:doc_diff/features/package_comparison/data/models/pdf_page_diff.dart';
import 'package:doc_diff/features/package_comparison/data/models/pdf_page_diff_status.dart';
import 'package:doc_diff/features/package_comparison/data/services/pdf_page_matcher.dart';
import 'package:image/image.dart' as img;
import 'package:pixelmatch/pixelmatch.dart';

class PdfDiffService {
  final PdfRenderService _pdfRenderService;
  final PdfPageMatcher _pdfPageMatcher;
  final ImageDecoderService _imageDecoderService;

  PdfDiffService(this._pdfRenderService, this._pdfPageMatcher, this._imageDecoderService);

  Future<PdfDiffResult> compare({
    required String originalPdfPath,
    required String updatedPdfPath,
  }) async {
    final originalPages = await _pdfRenderService.renderPages(originalPdfPath);

    final updatedPages = await _pdfRenderService.renderPages(updatedPdfPath);

    final matches = _pdfPageMatcher.matchPages(
      originalPages: originalPages,
      updatedPages: updatedPages,
    );

    final updatedToOriginal = _pdfPageMatcher.getUpdatedToOriginalIndexes(
      matches,
    );

    final pages = <PdfPageDiff>[];
    var originalIndex = 0;

    for (
      var updatedIndex = 0;
      updatedIndex < updatedPages.length;
      updatedIndex++
    ) {
      final matchedOriginalIndex = updatedToOriginal[updatedIndex];

      while (originalIndex < (matchedOriginalIndex ?? originalPages.length) &&
          matches[originalIndex] == null) {
        pages.add(
          PdfPageDiff(
            pageNumber: originalIndex + 1,
            originalPage: originalPages[originalIndex],
            updatedPage: null,
            diffPage: null,
            diffPixels: 0,
            status: PdfPageDiffStatus.removed,
          ),
        );

        originalIndex++;
      }

      if (matchedOriginalIndex == null) {
        pages.add(
          PdfPageDiff(
            pageNumber: updatedIndex + 1,
            originalPage: null,
            updatedPage: updatedPages[updatedIndex],
            diffPage: null,
            diffPixels: 0,
            status: PdfPageDiffStatus.added,
          ),
        );

        continue;
      }

      final diff = _comparePage(
        originalPage: originalPages[matchedOriginalIndex],
        updatedPage: updatedPages[updatedIndex],
      );

      pages.add(
        PdfPageDiff(
          pageNumber: updatedIndex + 1,
          originalPage: originalPages[matchedOriginalIndex],
          updatedPage: updatedPages[updatedIndex],
          diffPage: diff.diffImage,
          diffPixels: diff.diffPixels,
          status: diff.status,
        ),
      );

      originalIndex = matchedOriginalIndex + 1;
    }

    while (originalIndex < originalPages.length) {
      if (matches[originalIndex] == null) {
        pages.add(
          PdfPageDiff(
            pageNumber: originalIndex + 1,
            originalPage: originalPages[originalIndex],
            updatedPage: null,
            diffPage: null,
            diffPixels: 0,
            status: PdfPageDiffStatus.removed,
          ),
        );
      }
      originalIndex++;
    }

    return PdfDiffResult(pages: pages);
  }

  _PageComparison _comparePage({
    required Uint8List originalPage,
    required Uint8List updatedPage,
  }) {
    final originalImage = _imageDecoderService.decode(originalPage);
    final updatedImage = _imageDecoderService.decode(updatedPage);

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
      {'threshold': DiffConfig.pixelmatchThreshold},
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

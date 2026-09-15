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

    final matches = _matchPages(
      originalPages: originalPages,
      updatedPages: updatedPages,
    );

    final updatedToOriginal = _getUpdatedToOriginalIndexes(matches);

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

  double _calculateSimilarity({
    required Uint8List originalPage,
    required Uint8List updatedPage,
  }) {

    const contentThreshold = 245;
    const diffThreshold = 20;

    final originalImage = img
        .decodeImage(originalPage)
        ?.convert(numChannels: 4);

    final updatedImage = img.decodeImage(updatedPage)?.convert(numChannels: 4);

    if (originalImage == null || updatedImage == null) {
      return 0.0;
    }

    if (originalImage.width != updatedImage.width ||
        originalImage.height != updatedImage.height) {
      return 0.0;
    }

    var contentPixels = 0;
    var diffContentPixels = 0;

    for (var y = 0; y < originalImage.height; y++){
      for (var x = 0; x < originalImage.width; x++) {
        final originalPixel = originalImage.getPixel(x, y);
        final updatedPixel = updatedImage.getPixel(x, y);

        final originalBrightness = (originalPixel.r + originalPixel.g + originalPixel.b) / 3;

        final updatedBrightness = (updatedPixel.r + updatedPixel.g + updatedPixel.b) / 3;

        final originalHasContent = originalBrightness < contentThreshold;

        final updatedHasContent = updatedBrightness < contentThreshold;

        if(originalHasContent || updatedHasContent) {
          contentPixels++;
          
          final pixelDiff = (originalBrightness - updatedBrightness).abs();

          if (pixelDiff > diffThreshold) {
            diffContentPixels++;
          }
        }
      }
    }

    if(contentPixels == 0){
      return 1.0;
    }

    return 1 - (diffContentPixels / contentPixels);
  }

  List<int?> _matchPages({
    required List<Uint8List> originalPages,
    required List<Uint8List> updatedPages,
  }) {
    final similarities = List.generate(
      originalPages.length,
      (_) => List<double>.filled(updatedPages.length, 0.0),
    );

    for (
      var originalIndex = 0;
      originalIndex < originalPages.length;
      originalIndex++
    ) {
      for (
        var updatedIndex = 0;
        updatedIndex < updatedPages.length;
        updatedIndex++
      ) {
        similarities[originalIndex][updatedIndex] = _calculateSimilarity(
          originalPage: originalPages[originalIndex],
          updatedPage: updatedPages[updatedIndex],
        );
      }
    }

    final matches = List<int?>.filled(originalPages.length, null);

    final scores = List.generate(
      originalPages.length + 1,
      (_) => List<double>.filled(updatedPages.length + 1, 0.0),
    );

    const similarityThreshold = 0.8;
    const skipPenalty = 0.2;

    for (
      var originalIndex = 1;
      originalIndex <= originalPages.length;
      originalIndex++
    ) {
      for (
        var updatedIndex = 1;
        updatedIndex <= updatedPages.length;
        updatedIndex++
      ) {
        final similarity = similarities[originalIndex - 1][updatedIndex - 1];

        final matchScore = similarity >= similarityThreshold
            ? scores[originalIndex - 1][updatedIndex - 1] + similarity
            : double.negativeInfinity;

        final skipOriginalScore =
            scores[originalIndex - 1][updatedIndex] - skipPenalty;
        final skipUpdatedScore =
            scores[originalIndex][updatedIndex - 1] - skipPenalty;

        scores[originalIndex][updatedIndex] = [
          matchScore,
          skipOriginalScore,
          skipUpdatedScore,
        ].reduce((a, b) => a > b ? a : b);
      }
    }

    var originalIndex = originalPages.length;
    var updatedIndex = updatedPages.length;

    while (originalIndex > 0 && updatedIndex > 0) {
      final similarity = similarities[originalIndex - 1][updatedIndex - 1];

      final matchScore = similarity >= similarityThreshold
          ? scores[originalIndex - 1][updatedIndex - 1] + similarity
          : double.negativeInfinity;

      if (scores[originalIndex][updatedIndex] == matchScore) {
        matches[originalIndex - 1] = updatedIndex - 1;

        originalIndex--;
        updatedIndex--;
      } else if (scores[originalIndex][updatedIndex] ==
          scores[originalIndex - 1][updatedIndex] - skipPenalty) {
        originalIndex--;
      } else {
        updatedIndex--;
      }
    }

    return matches;
  }


  Map<int, int> _getUpdatedToOriginalIndexes(List<int?> matches) {
    final mapping = <int, int>{};

    for (
      var originalIndex = 0;
      originalIndex < matches.length;
      originalIndex++
    ) {
      final updatedIndex = matches[originalIndex];
      if (updatedIndex != null) {
        mapping[updatedIndex] = originalIndex;
      }
    }

    return mapping;
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

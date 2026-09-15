import 'dart:typed_data';

import 'package:doc_diff/core/config/diff_config.dart';
import 'package:doc_diff/core/services/image_decoder_service.dart';

class PdfPageMatcher {
  final ImageDecoderService _imageDecoderService;

  PdfPageMatcher(this._imageDecoderService);

  double calculateSimilarity({
    required Uint8List originalPage,
    required Uint8List updatedPage,
  }) {

    final originalImage = _imageDecoderService.decode(originalPage);

    final updatedImage = _imageDecoderService.decode(updatedPage);

    if (originalImage == null || updatedImage == null) {
      return 0.0;
    }

    if (originalImage.width != updatedImage.width ||
        originalImage.height != updatedImage.height) {
      return 0.0;
    }

    var contentPixels = 0;
    var diffContentPixels = 0;

    for (var y = 0; y < originalImage.height; y++) {
      for (var x = 0; x < originalImage.width; x++) {
        final originalPixel = originalImage.getPixel(x, y);
        final updatedPixel = updatedImage.getPixel(x, y);

        final originalBrightness =
            (originalPixel.r + originalPixel.g + originalPixel.b) / 3;

        final updatedBrightness =
            (updatedPixel.r + updatedPixel.g + updatedPixel.b) / 3;

        final originalHasContent = originalBrightness < DiffConfig.contentThreshold;

        final updatedHasContent = updatedBrightness < DiffConfig.contentThreshold;

        if (originalHasContent || updatedHasContent) {
          contentPixels++;

          final pixelDiff = (originalBrightness - updatedBrightness).abs();

          if (pixelDiff > DiffConfig.diffThreshold) {
            diffContentPixels++;
          }
        }
      }
    }

    if (contentPixels == 0) {
      return 1.0;
    }

    return 1 - (diffContentPixels / contentPixels);
  }

  List<int?> matchPages({
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
        similarities[originalIndex][updatedIndex] = calculateSimilarity(
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

        final matchScore = similarity >= DiffConfig.similarityThreshold
            ? scores[originalIndex - 1][updatedIndex - 1] + similarity
            : double.negativeInfinity;

        final skipOriginalScore =
            scores[originalIndex - 1][updatedIndex] - DiffConfig.skipPenalty;
        final skipUpdatedScore =
            scores[originalIndex][updatedIndex - 1] - DiffConfig.skipPenalty;

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

      final matchScore = similarity >= DiffConfig.similarityThreshold
          ? scores[originalIndex - 1][updatedIndex - 1] + similarity
          : double.negativeInfinity;

      if (scores[originalIndex][updatedIndex] == matchScore) {
        matches[originalIndex - 1] = updatedIndex - 1;

        originalIndex--;
        updatedIndex--;
      } else if (scores[originalIndex][updatedIndex] ==
          scores[originalIndex - 1][updatedIndex] - DiffConfig.skipPenalty) {
        originalIndex--;
      } else {
        updatedIndex--;
      }
    }

    return matches;
  }

  Map<int, int> getUpdatedToOriginalIndexes(List<int?> matches) {
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

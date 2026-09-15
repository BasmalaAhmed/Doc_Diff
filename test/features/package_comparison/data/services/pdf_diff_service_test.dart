import 'dart:typed_data';

import 'package:doc_diff/core/services/image_decoder_service.dart';
import 'package:doc_diff/core/services/pdf_render_service.dart';
import 'package:doc_diff/features/package_comparison/data/models/pdf_page_diff_status.dart';
import 'package:doc_diff/features/package_comparison/data/services/pdf_diff_service.dart';
import 'package:doc_diff/features/package_comparison/data/services/pdf_page_matcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:mocktail/mocktail.dart';

class MockPdfRenderService extends Mock implements PdfRenderService {}

Uint8List _buildPage({List<List<int>> flipToWhite = const []}) {
  final image = img.Image(width: 10, height: 10);
  img.fill(image, color: img.ColorRgb8(255, 255, 255));

  for (var y = 0; y < 5; y++) {
    for (var x = 0; x < 10; x++) {
      image.setPixelRgb(x, y, 0, 0, 0);
    }
  }

  for (final point in flipToWhite) {
    image.setPixelRgb(point[0], point[1], 255, 255, 255);
  }

  return Uint8List.fromList(img.encodePng(image));
}

void main() {
  const originalPath = 'original.pdf';
  const updatedPath = 'updated.pdf';

  late MockPdfRenderService mockRenderService;
  late PdfDiffService pdfDiffService;

  setUp(() {
    final imageDecoderService = ImageDecoderService();
    mockRenderService = MockPdfRenderService();
    pdfDiffService = PdfDiffService(
      mockRenderService,
      PdfPageMatcher(imageDecoderService),
      imageDecoderService,
    );
  });

  test('marks page as unchanged when both pages are identical', () async {
    final page = _buildPage();

    when(
      () => mockRenderService.renderPages(originalPath),
    ).thenAnswer((_) async => [page]);
    when(
      () => mockRenderService.renderPages(updatedPath),
    ).thenAnswer((_) async => [page]);

    final result = await pdfDiffService.compare(
      originalPdfPath: originalPath,
      updatedPdfPath: updatedPath,
    );

    expect(result.pages, hasLength(1));
    expect(result.pages.first.status, PdfPageDiffStatus.unchanged);
    expect(result.pages.first.diffPixels, 0);
  });

  test(
    'marks page as changed when there is a small localized difference',
    () async {
      final originalPage = _buildPage();
      final updatedPage = _buildPage(
        flipToWhite: [
          [0, 0],
          [1, 0],
        ],
      );

      when(
        () => mockRenderService.renderPages(originalPath),
      ).thenAnswer((_) async => [originalPage]);
      when(
        () => mockRenderService.renderPages(updatedPath),
      ).thenAnswer((_) async => [updatedPage]);

      final result = await pdfDiffService.compare(
        originalPdfPath: originalPath,
        updatedPdfPath: updatedPath,
      );

      expect(result.pages, hasLength(1));
      expect(result.pages.first.status, PdfPageDiffStatus.changed);
      expect(result.pages.first.diffPixels, greaterThan(0));
    },
  );

  test('marks page as added when it only exists in the updated pdf', () async {
    final page = _buildPage();

    when(
      () => mockRenderService.renderPages(originalPath),
    ).thenAnswer((_) async => []);
    when(
      () => mockRenderService.renderPages(updatedPath),
    ).thenAnswer((_) async => [page]);

    final result = await pdfDiffService.compare(
      originalPdfPath: originalPath,
      updatedPdfPath: updatedPath,
    );

    expect(result.pages, hasLength(1));
    expect(result.pages.first.status, PdfPageDiffStatus.added);
  });

  test(
    'marks page as removed when it only exists in the original pdf',
    () async {
      final page = _buildPage();

      when(
        () => mockRenderService.renderPages(originalPath),
      ).thenAnswer((_) async => [page]);
      when(
        () => mockRenderService.renderPages(updatedPath),
      ).thenAnswer((_) async => []);

      final result = await pdfDiffService.compare(
        originalPdfPath: originalPath,
        updatedPdfPath: updatedPath,
      );

      expect(result.pages, hasLength(1));
      expect(result.pages.first.status, PdfPageDiffStatus.removed);
    },
  );
}

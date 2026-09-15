import 'dart:typed_data';

import 'package:doc_diff/features/package_comparison/data/services/pdf_page_matcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

Uint8List createPage({required int contentX}) {
  final image = img.Image(width: 20, height: 20);

  img.fill(image, color: img.ColorRgb8(255, 255, 255));

  img.fillRect(
    image,
    x1: contentX,
    y1: 5,
    x2: contentX + 3,
    y2: 15,
    color: img.ColorRgb8(0, 0, 0),
  );

  return Uint8List.fromList(img.encodePng(image));
}

void main() {
  test('Matches unchanged pages even when a page is removed', () {
    final matcher = PdfPageMatcher();

    final originalPages = [
      createPage(contentX: 1),
      createPage(contentX: 7),
      createPage(contentX: 13),
    ];

    final updatedPages = [createPage(contentX: 1), createPage(contentX: 13)];

    final matches = matcher.matchPages(
      originalPages: originalPages,
      updatedPages: updatedPages,
    );

    expect(matches, [0, null, 1]);
  });
}

import 'dart:io';

import 'package:doc_diff/features/package_comparison/data/services/package_scanner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory tempDirectory;
  late PackageScanner packageScanner;

  setUp(() {
    tempDirectory = Directory.systemTemp.createTempSync(
      'doc_diff_scanner_test_',
    );
    packageScanner = PackageScanner();
  });

  tearDown((){
    if(tempDirectory.existsSync()){
      tempDirectory.deleteSync(recursive: true);
    }
  });

  test('returns empty list when directory does not exist', () async {
    final result = await packageScanner.scan(p.join(tempDirectory.path, 'does_not_exist'),);

    expect(result, isEmpty);
  });

  test('finds pdf files in the root of the directory', () async {
    final pdfFile = File(p.join(tempDirectory.path, 'drawing.pdf'));
    await pdfFile.writeAsString('pdf content');

    final result = await packageScanner.scan(tempDirectory.path);

    expect(result, hasLength(1));
    expect(result.first.name, 'drawing.pdf');
    expect(result.first.relativePath, 'drawing.pdf');
    expect(result.first.path, pdfFile.path);
  });

  test('ignores non-pdf files', () async {
    await File(p.join(tempDirectory.path, 'notes.txt')).writeAsString('not a pdf');
    await File(p.join(tempDirectory.path, 'drawing.pdf')).writeAsString('pdf content');

    final result = await packageScanner.scan(tempDirectory.path);

    expect(result, hasLength(1));
    expect(result.first.name, 'drawing.pdf');
  });

  test('finds pdf files recursively in nested folders', () async {
    final nestedDirectory = Directory(p.join(tempDirectory.path, 'sub', 'nested'));
    await nestedDirectory.create(recursive: true);

    final nestedFile = File(p.join(nestedDirectory.path, 'nested_drawing.pdf'));
    await nestedFile.writeAsString('pdf content');

    final result = await packageScanner.scan(tempDirectory.path);

    expect(result, hasLength(1));
    expect(result.first.relativePath,  p.join('sub', 'nested', 'nested_drawing.pdf'),);
  });

  test('is case-insensitive when matching the .pdf extension', () async {
    await File(p.join(tempDirectory.path, 'DRAWING.PDF')).writeAsString('pdf content');

    final result = await packageScanner.scan(tempDirectory.path);

    expect(result, hasLength(1));
  });

  test('sets the correct file size', () async {
    final pdfFile = File(p.join(tempDirectory.path, 'drawing.pdf'));
    await pdfFile.writeAsString('some content here');

    final result = await packageScanner.scan(tempDirectory.path);

    expect(result.first.size, await pdfFile.length());
  });
}

import 'dart:io';

import 'package:doc_diff/core/services/hash_service.dart';
import 'package:doc_diff/features/package_comparison/data/models/file_comparison_status.dart';
import 'package:doc_diff/features/package_comparison/data/models/package_file.dart';
import 'package:doc_diff/features/package_comparison/data/services/comparison_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDirectory;
  late ComparisonService comparisonService;

  setUp(() {
    tempDirectory = Directory.systemTemp.createTempSync('doc_diff_test_');
    comparisonService = ComparisonService(HashService());
  });

  tearDown(() {
    if (tempDirectory.existsSync()) {
      tempDirectory.deleteSync(recursive: true);
    }
  });

  test('returns unchanged when files have the same content', () async {
    final originalFile = File('${tempDirectory.path}/original.pdf');
    final updatedFile = File('${tempDirectory.path}/updated.pdf');

    await originalFile.writeAsString('same content');
    await updatedFile.writeAsString('same content');

    final originalPackageFile = PackageFile(
      name: 'drawing.pdf',
      path: originalFile.path,
      relativePath: 'drawing.pdf',
      size: await originalFile.length(),
    );

    final updatedPackageFile = PackageFile(
      name: 'drawing.pdf',
      path: updatedFile.path,
      relativePath: 'drawing.pdf',
      size: await updatedFile.length(),
    );

    final result = await comparisonService.compare(
      originalFiles: [originalPackageFile],
      updatedFiles: [updatedPackageFile],
    );

    expect(result.files, hasLength(1));
    expect(result.files.first.status, FileComparisonStatus.unchanged);
    expect(result.unchangedCount, 1);
    expect(result.modifiedCount, 0);
    expect(result.addedCount, 0);
    expect(result.removedCount, 0);
  });

  test('returns modified when files have different content', () async {
    final originalFile = File('${tempDirectory.path}/original.pdf');
    final updatedFile = File('${tempDirectory.path}/updated.pdf');

    await originalFile.writeAsString('old content');
    await updatedFile.writeAsString('new content');

    final originalPackageFile = PackageFile(
      name: 'drawing.pdf',
      path: originalFile.path,
      relativePath: 'drawing.pdf',
      size: await originalFile.length(),
    );

    final updatedPackageFile = PackageFile(
      name: 'drawing.pdf',
      path: updatedFile.path,
      relativePath: 'drawing.pdf',
      size: await updatedFile.length(),
    );

    final result = await comparisonService.compare(
      originalFiles: [originalPackageFile],
      updatedFiles: [updatedPackageFile],
    );

    expect(result.files, hasLength(1));
    expect(result.files.first.status, FileComparisonStatus.modified);
    expect(result.unchangedCount, 0);
    expect(result.modifiedCount, 1);
    expect(result.addedCount, 0);
    expect(result.removedCount, 0);
  });

  test('returns added when file exists only in updated package', () async {
    final originalFile = File('${tempDirectory.path}/original.pdf');
    final updatedFile = File('${tempDirectory.path}/updated.pdf');
    final newFile = File('${tempDirectory.path}/new.pdf');

    await originalFile.writeAsString('same content');
    await updatedFile.writeAsString('same content');
    await newFile.writeAsString('new file');

    final originalPackageFile = PackageFile(
      name: 'drawing.pdf',
      path: originalFile.path,
      relativePath: 'drawing.pdf',
      size: await originalFile.length(),
    );

    final updatedPackageFile = PackageFile(
      name: 'drawing.pdf',
      path: updatedFile.path,
      relativePath: 'drawing.pdf',
      size: await updatedFile.length(),
    );

    final newPackageFile = PackageFile(
      name: 'new_drawing.pdf',
      path: newFile.path,
      relativePath: 'new_drawing.pdf',
      size: await newFile.length(),
    );

    final result = await comparisonService.compare(
      originalFiles: [originalPackageFile],
      updatedFiles: [updatedPackageFile, newPackageFile],
    );

    expect(result.files, hasLength(2));
    expect(result.unchangedCount, 1);
    expect(result.addedCount, 1);
    expect(result.removedCount, 0);
    expect(result.modifiedCount, 0);
  });

  test('returns removed when file exists only in original package', () async {
    final originalFile = File('${tempDirectory.path}/original.pdf');
    final removedFile = File('${tempDirectory.path}/removed.pdf');
    final updatedFile = File('${tempDirectory.path}/updated.pdf');

    await originalFile.writeAsString('same content');
    await removedFile.writeAsString('removed file');
    await updatedFile.writeAsString('same content');

    final originalPackageFile = PackageFile(
      name: 'drawing.pdf',
      path: originalFile.path,
      relativePath: 'drawing.pdf',
      size: await originalFile.length(),
    );

    final removedPackageFile = PackageFile(
      name: 'old_drawing.pdf',
      path: removedFile.path,
      relativePath: 'old_drawing.pdf',
      size: await removedFile.length(),
    );

    final updatedPackageFile = PackageFile(
      name: 'drawing.pdf',
      path: updatedFile.path,
      relativePath: 'drawing.pdf',
      size: await updatedFile.length(),
    );

    final result = await comparisonService.compare(
      originalFiles: [originalPackageFile, removedPackageFile],
      updatedFiles: [updatedPackageFile],
    );

    expect(result.files, hasLength(2));
    expect(result.unchangedCount, 1);
    expect(result.addedCount, 0);
    expect(result.removedCount, 1);
    expect(result.modifiedCount, 0);
  });
}

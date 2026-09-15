import 'dart:io';

import 'package:doc_diff/core/services/hash_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory tempDirectory;
  late HashService hashService;

  setUp(() {
    tempDirectory = Directory.systemTemp.createTempSync('doc_diff_hash_test_');
    hashService = HashService();
  });

  tearDown(() {
    if (tempDirectory.existsSync()) {
      tempDirectory.deleteSync(recursive: true);
    }
  });

  test('returns the same hash for identical file content', () async {
    final fileA = File(p.join(tempDirectory.path, 'a.pdf'));
    final fileB = File(p.join(tempDirectory.path, 'b.pdf'));

    await fileA.writeAsString('same content');
    await fileB.writeAsString('same content');

    final hashA = await hashService.calculateHash(fileA.path);
    final hashB = await hashService.calculateHash(fileB.path);

    expect(hashA, hashB);
  });

  test('returns different hashes for different file content', () async {
    final fileA = File(p.join(tempDirectory.path, 'a.pdf'));
    final fileB = File(p.join(tempDirectory.path, 'b.pdf'));

    await fileA.writeAsString('content one');
    await fileB.writeAsString('content two');

    final hashA = await hashService.calculateHash(fileA.path);
    final hashB = await hashService.calculateHash(fileB.path);

    expect(hashA, isNot(equals(hashB)));
  });

  test('returns a valid sha256 hex string (64 characters)', () async {
    final file = File(p.join(tempDirectory.path, 'a.pdf'));
    await file.writeAsString('some content');

    final hash = await hashService.calculateHash(file.path);

    expect(hash, hasLength(64));
    expect(RegExp(r'^[0-9a-f]+$').hasMatch(hash), isTrue);
  });

  test('returns the same hash on repeated calls for an unchanged file', () async {
    final file = File(p.join(tempDirectory.path, 'a.pdf'));
    await file.writeAsString('stable content');

    final firstHash = await hashService.calculateHash(file.path);
    final secondHash = await hashService.calculateHash(file.path);

    expect(firstHash, secondHash);
  });
}
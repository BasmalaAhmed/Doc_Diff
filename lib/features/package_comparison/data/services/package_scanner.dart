import 'dart:io';

import 'package:doc_diff/features/package_comparison/data/models/package_file.dart';

class PackageScanner {
  Future<List<PackageFile>> scan(String directoryPath) async {
    final directory = Directory(directoryPath);

    if (!await directory.exists()) {
      return [];
    }

    final files = await directory
        .list(recursive: true)
        .where((entity) => entity is File)
        .cast<File>()
        .where((file) => file.path.toLowerCase().endsWith('.pdf'))
        .toList();

    return Future.wait(
      files.map((file) async {
        final stat = await file.stat();
        return PackageFile(
          name: file.uri.pathSegments.last,
          path: file.path,
          size: stat.size,
        );
      }),
    );
  }
}

import 'dart:io';

import 'package:crypto/crypto.dart';

class HashService {
  Future<String> calculateHash(String filePath) async {
    final file = File(filePath);
    final stream = file.openRead();

    final digest = await sha256.bind(stream).first;

    return digest.toString();
  }
}

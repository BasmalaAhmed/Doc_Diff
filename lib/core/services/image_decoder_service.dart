import 'dart:typed_data';

import 'package:image/image.dart' as img;

class ImageDecoderService {
  img.Image? decode(Uint8List bytes) {
    return img.decodeImage(bytes)?.convert(numChannels: 4);
  }
}
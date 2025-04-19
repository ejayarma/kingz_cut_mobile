import 'dart:convert';
import 'dart:typed_data';

import 'package:mime/mime.dart';

class CoderUtil {
  static String fileTobase64DataUrl(List<int> fileBytes, String filepPath) {
    final fileBase64 = base64Encode(fileBytes);
    final fileMimeType = lookupMimeType(filepPath);

    final fileBase64DataUrl = 'data:$fileMimeType;base64,$fileBase64';

    return fileBase64DataUrl;
  }

  static Uint8List fileFrombase64DataUrl(String fileBase64DataUrl) {
    final data = fileBase64DataUrl.split(',').last;
    return base64Decode(data);
  }
}
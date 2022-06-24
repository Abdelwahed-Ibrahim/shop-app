import 'package:flutter/foundation.dart';

String? token;

void printFullText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) {
    if (kDebugMode) {
      print(match.group(0));
    }
  });
}

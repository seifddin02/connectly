import 'package:flutter/material.dart' show immutable;

typedef CloseLoadingScrean = bool Function();
typedef UpdateLoadingScrean = bool Function(String text);

@immutable
class LoadingScreenController {
  final CloseLoadingScrean close;
  final UpdateLoadingScrean update;

  const LoadingScreenController({required this.close, required this.update});
}

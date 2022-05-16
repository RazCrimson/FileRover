import 'package:io/io.dart';

Future<void> copyPathWrapper(Map<String, String> params) {
  final String to = params["to"]!;
  final String from = params["from"]!;
  return copyPath(from, to);
}

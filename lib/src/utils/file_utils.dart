// lib/src/utils/file_utils.dart
import 'dart:io';
import 'package:path/path.dart' as path;

class FileUtils {
  // Create directory if it doesn't exist
  static Future<void> createDirectory(
      String dirPath) async {
    final dir = Directory(dirPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }

  // Create file with content
  static Future<void> createFile(
    String filePath,
    String content,
  ) async {
    // Create parent directories first
    final parent = path.dirname(filePath);
    await createDirectory(parent);

    final file = File(filePath);
    if (!await file.exists()) {
      await file.writeAsString(content);
    }
  }

  // Create empty .gitkeep file to preserve empty dirs
  static Future<void> createGitKeep(
      String dirPath) async {
    await createDirectory(dirPath);
    await createFile(
      path.join(dirPath, '.gitkeep'),
      '',
    );
  }

  // Join paths cross-platform
  static String joinPath(List<String> parts) {
    return parts.reduce(
        (value, element) => path.join(value, element));
  }
}
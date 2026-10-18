import 'dart:io';

import 'package:path/path.dart' as path;

/// File system helpers used by the generator.
///
/// All methods are static and safe to call repeatedly.
class FileUtils {
  FileUtils._();

  /// Creates the directory at [dirPath], including any missing parents.
  ///
  /// Does nothing if the directory already exists.
  static Future<void> createDirectory(String dirPath) async {
    final dir = Directory(dirPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }

  /// Writes [content] to a new file at [filePath], creating parent
  /// directories as needed.
  ///
  /// An existing file is never overwritten, so running the generator again
  /// cannot destroy your work.
  static Future<void> createFile(
    String filePath,
    String content,
  ) async {
    await createDirectory(path.dirname(filePath));

    final file = File(filePath);
    if (!await file.exists()) {
      await file.writeAsString(content);
    }
  }

  /// Creates an empty `.gitkeep` file inside [dirPath] so that Git keeps
  /// an otherwise empty directory.
  static Future<void> createGitKeep(String dirPath) async {
    await createDirectory(dirPath);
    await createFile(path.join(dirPath, '.gitkeep'), '');
  }

  /// Joins [parts] into one path using the separator of the current
  /// platform.
  ///
  /// [parts] must not be empty.
  static String joinPath(List<String> parts) {
    return parts.reduce(
      (value, element) => path.join(value, element),
    );
  }
}

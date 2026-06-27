// lib/src/models/project_config.dart

class ProjectConfig {
  final String projectName;
  final List<String> features;
  final String outputPath;

  ProjectConfig({
    required this.projectName,
    required this.features,
    this.outputPath = 'lib',
  });

  // Convert feature name to class name
  // "my_feature" → "MyFeature"
  static String toClassName(String name) {
    return name
        .split('_')
        .map((word) =>
            word[0].toUpperCase() + word.substring(1))
        .join('');
  }

  // Convert feature name to file name
  // "MyFeature" → "my_feature"
  static String toFileName(String name) {
    return name
        .replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) => '_${match.group(0)!.toLowerCase()}',
        )
        .replaceFirst('_', '');
  }
}
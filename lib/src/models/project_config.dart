/// Describes what [ProjectGenerator] should generate and where to put it.
///
/// ```dart
/// const config = ProjectConfig(
///   projectName: 'my_app',
///   features: ['auth', 'user_profile'],
/// );
/// ```
class ProjectConfig {
  /// Creates a configuration for the given [projectName] and [features].
  ///
  /// Generated files are written under [outputPath], which defaults to `lib`.
  const ProjectConfig({
    required this.projectName,
    required this.features,
    this.outputPath = 'lib',
  });

  /// The name of the Flutter project being generated.
  final String projectName;

  /// The feature names to generate, such as `auth` or `user_profile`.
  ///
  /// Each feature gets its own folder under `<outputPath>/features/`.
  final List<String> features;

  /// The directory that generated files are written to.
  ///
  /// Defaults to `lib`, relative to the current working directory.
  final String outputPath;

  /// Converts a snake_case feature [name] to a PascalCase class name.
  ///
  /// ```dart
  /// ProjectConfig.toClassName('my_feature'); // 'MyFeature'
  /// ```
  ///
  /// Empty segments, such as those produced by a double underscore, are
  /// ignored.
  static String toClassName(String name) {
    return name
        .split('_')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join();
  }

  /// Converts a PascalCase or camelCase [name] to a snake_case file name.
  ///
  /// ```dart
  /// ProjectConfig.toFileName('MyFeature'); // 'my_feature'
  /// ```
  ///
  /// Names that are already snake_case are returned unchanged.
  static String toFileName(String name) {
    return name
        .replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) => '_${match.group(0)!.toLowerCase()}',
        )
        .replaceFirst(RegExp(r'^_'), '');
  }
}

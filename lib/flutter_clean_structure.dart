/// Scaffolds a complete, feature-first Clean Architecture structure for
/// Flutter projects.
///
/// This library is the programmatic API behind the `create` command line
/// tool. Use it to generate the shared `core/` folder and any number of
/// `features/` folders from your own Dart scripts:
///
/// ```dart
/// import 'package:flutter_clean_structure/flutter_clean_structure.dart';
/// import 'package:mason_logger/mason_logger.dart';
///
/// Future<void> main() async {
///   final config = ProjectConfig(
///     projectName: 'my_app',
///     features: ['auth', 'home'],
///   );
///
///   await ProjectGenerator(config: config, logger: Logger()).generate();
/// }
/// ```
///
/// Generation is safe to repeat: existing files are never overwritten.
library;

export 'src/generator/project_generator.dart';
export 'src/models/project_config.dart';
export 'src/utils/file_utils.dart';

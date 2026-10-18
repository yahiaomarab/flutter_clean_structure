// Generates a Clean Architecture structure from Dart code.
//
// Run it from the root of your Flutter project:
//
//   dart run example/main.dart
//
// For day-to-day use the command line tool is simpler:
//
//   dart run flutter_clean_structure:create --full
import 'package:flutter_clean_structure/flutter_clean_structure.dart';
import 'package:mason_logger/mason_logger.dart';

Future<void> main() async {
  const config = ProjectConfig(
    projectName: 'my_app',
    features: ['auth', 'home', 'user_profile'],
    // Files are written under this folder; existing files are never
    // overwritten.
    outputPath: 'lib',
  );

  final generator = ProjectGenerator(
    config: config,
    logger: Logger(),
  );

  // Creates lib/core/, lib/features/<feature>/ for each feature, and
  // lib/main.dart.
  await generator.generate();

  // Later, add one more feature without touching core/:
  await generator.generateFeatureOnly('orders');
}

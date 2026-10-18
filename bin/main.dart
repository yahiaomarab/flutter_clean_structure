// bin/main.dart
import 'dart:io';
import 'package:args/args.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:flutter_clean_structure/src/generator/project_generator.dart';
import 'package:flutter_clean_structure/src/models/project_config.dart';

void main(List<String> arguments) async {
  final logger = Logger();

  // Print beautiful header
  logger.info('');
  logger.info(
    '🚀 Flutter Clean Structure Generator',
  );
  logger.info(
    '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
  );
  logger.info('');

  // Parse arguments
  final parser = ArgParser()
    ..addOption(
      'name',
      abbr: 'n',
      help: 'Feature name to generate',
    )
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Show usage information',
    )
    ..addFlag(
      'full',
      abbr: 'f',
      negatable: false,
      help: 'Generate full project structure',
    );

  final ArgResults results;
  try {
    results = parser.parse(arguments);
  } catch (e) {
    logger.err('Invalid arguments: $e');
    exit(1);
  }

  // Show help
  if (results['help'] as bool) {
    _showHelp(logger, parser);
    exit(0);
  }

  // Determine what to generate
  final bool generateFull = results['full'] as bool;
  final String? featureName = results['name'] as String?;

  // Ask interactively if no args provided
  if (!generateFull && featureName == null) {
    logger.info('What would you like to generate?');
    logger.info('  1. Full project structure');
    logger.info('  2. New feature only');
    logger.info('');

    final choice = logger.prompt(
      '→ Enter choice (1 or 2):',
    );

    if (choice == '1') {
      await _generateFullProject(logger);
    } else if (choice == '2') {
      final name = logger.prompt(
        '→ Enter feature name (e.g. auth, products):',
      );
      await _generateFeature(logger, name.trim());
    } else {
      logger.err('Invalid choice');
      exit(1);
    }
    return;
  }

  if (generateFull) {
    await _generateFullProject(logger);
  } else if (featureName != null) {
    await _generateFeature(logger, featureName);
  }
}

Future<void> _generateFullProject(Logger logger) async {
  final projectName = logger.prompt(
    '→ Enter project name:',
  );

  final features = logger.prompt(
    '→ Enter feature names (comma separated)\n'
    '  e.g. auth,home,products,profile:',
  );

  final featureList = features
      .split(',')
      .map((f) => f.trim())
      .where((f) => f.isNotEmpty)
      .toList();

  final config = ProjectConfig(
    projectName: projectName.trim(),
    features: featureList,
  );

  logger.info('');
  final progress = logger.progress(
    'Generating project structure...',
  );

  try {
    final generator = ProjectGenerator(
      config: config,
      logger: logger,
    );
    await generator.generate();
    progress.complete('Project structure generated!');

    _printSuccessMessage(logger, config);
  } catch (e) {
    progress.fail('Failed: $e');
    exit(1);
  }
}

Future<void> _generateFeature(
  Logger logger,
  String featureName,
) async {
  final progress = logger.progress(
    'Generating feature: $featureName...',
  );

  try {
    final generator = ProjectGenerator(
      config: ProjectConfig(
        projectName: 'app',
        features: [featureName],
      ),
      logger: logger,
      featureOnly: true,
    );
    await generator.generateFeatureOnly(featureName);
    progress.complete('Feature generated!');

    logger.success(
      '✅ Feature "$featureName" created successfully!',
    );
  } catch (e) {
    progress.fail('Failed: $e');
    exit(1);
  }
}

void _showHelp(Logger logger, ArgParser parser) {
  logger.info('Usage:');
  logger.info(
    '  dart run flutter_clean_structure:create [options]',
  );
  logger.info('');
  logger.info('Options:');
  logger.info(parser.usage);
  logger.info('');
  logger.info('Examples:');
  logger.info(
    '  dart run flutter_clean_structure:create',
  );
  logger.info(
    '  dart run flutter_clean_structure:create --full',
  );
  logger.info(
    '  dart run flutter_clean_structure:create '
    '--name auth',
  );
}

void _printSuccessMessage(
  Logger logger,
  ProjectConfig config,
) {
  logger.info('');
  logger.success('✅ Project structure created!');
  logger.info('');
  logger.info('📁 Generated structure:');
  logger.info('');
  logger.info('lib/');
  logger.info('  ├── core/');
  logger.info('  │     ├── di/');
  logger.info('  │     ├── helper/');
  logger.info('  │     ├── networking/');
  logger.info('  │     ├── routing/');
  logger.info('  │     ├── theming/');
  logger.info('  │     └── widgets/');
  logger.info('  │');
  logger.info('  ├── features/');
  for (final feature in config.features) {
    logger.info('  │     ├── $feature/');
    logger.info('  │     │     ├── data/');
    logger.info('  │     │     ├── logic/');
    logger.info('  │     │     └── ui/');
  }
  logger.info('  │');
  logger.info('  └── main.dart');
  logger.info('');
  logger.info('🎯 Next steps:');
  logger.info('  1. Set your base URL in core/networking/api_constants.dart');
  logger.info('  2. Register dependencies in core/di/dependency_injection.dart');
  logger.info('  3. Run: dart run build_runner build --delete-conflicting-outputs');
  logger.info('');
}
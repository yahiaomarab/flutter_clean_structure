// lib/src/generator/project_generator.dart

import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as path;
import '../models/project_config.dart';
import '../utils/file_utils.dart';
import '../templates/core_templates.dart';
import '../templates/feature_templates.dart';

/// Writes the Clean Architecture folder structure described by a
/// [ProjectConfig] to disk.
///
/// A full run generates the shared `core/` folder, one folder per feature
/// under `features/`, and a `main.dart` entry point. Existing files are
/// never overwritten.
///
/// ```dart
/// final generator = ProjectGenerator(
///   config: ProjectConfig(projectName: 'my_app', features: ['auth']),
///   logger: Logger(),
/// );
/// await generator.generate();
/// ```
class ProjectGenerator {
  /// Creates a generator for the given [config].
  ///
  /// Progress and diagnostics are written to [logger]. Set [featureOnly] to
  /// `true` when only [generateFeatureOnly] will be called.
  ProjectGenerator({
    required this.config,
    required this.logger,
    this.featureOnly = false,
  });

  /// What to generate and where to write it.
  final ProjectConfig config;

  /// Receives progress and diagnostic messages while generating.
  final Logger logger;

  /// Whether this generator is used to add a single feature to an existing
  /// project, without touching the `core/` folder.
  final bool featureOnly;

  /// Generates the full project: the `core/` folder, every feature in
  /// [ProjectConfig.features], and `main.dart`.
  Future<void> generate() async {
    await _generateCore();
    for (final feature in config.features) {
      await _generateFeature(feature);
    }
    await _generateMain();
  }

  /// Generates only the folder for [featureName] under `features/`.
  ///
  /// The shared `core/` folder and `main.dart` are left untouched.
  Future<void> generateFeatureOnly(String featureName) async {
    await _generateFeature(featureName);
  }

  // ── CORE GENERATION ─────────────────────────

  Future<void> _generateCore() async {
    logger.detail('Generating core...');
    final corePath = path.join(config.outputPath, 'core');

    await _generateDI(corePath);
    await _generateHelper(corePath);
    await _generateNetworking(corePath);
    await _generateRouting(corePath);
    await _generateTheming(corePath);
    await _generateWidgets(corePath);

    logger.detail('✅ Core generated');
  }

  Future<void> _generateDI(String corePath) async {
    final p = path.join(corePath, 'di');
    await FileUtils.createFile(
      path.join(p, 'dependency_injection.dart'),
      CoreTemplates.injectionContainer(config.features),
    );
  }

  Future<void> _generateHelper(String corePath) async {
    final p = path.join(corePath, 'helper');
    await FileUtils.createFile(
      path.join(p, 'app_regex.dart'),
      CoreTemplates.appRegex(),
    );
    await FileUtils.createFile(
      path.join(p, 'constants.dart'),
      CoreTemplates.constants(),
    );
    await FileUtils.createFile(
      path.join(p, 'extensions.dart'),
      CoreTemplates.extensions(),
    );
    await FileUtils.createFile(
      path.join(p, 'shared_pref_helper.dart'),
      CoreTemplates.sharedPrefHelper(),
    );
    await FileUtils.createFile(
      path.join(p, 'spacing.dart'),
      CoreTemplates.spacing(),
    );
  }

  Future<void> _generateNetworking(String corePath) async {
    final p = path.join(corePath, 'networking');
    await FileUtils.createFile(
      path.join(p, 'api_constants.dart'),
      CoreTemplates.apiConstants(),
    );
    await FileUtils.createFile(
      path.join(p, 'api_error_handler.dart'),
      CoreTemplates.apiErrorHandler(),
    );
    await FileUtils.createFile(
      path.join(p, 'api_error_model.dart'),
      CoreTemplates.apiErrorModel(),
    );
    await FileUtils.createFile(
      path.join(p, 'api_result.dart'),
      CoreTemplates.apiResult(),
    );
    await FileUtils.createFile(
      path.join(p, 'api_service.dart'),
      CoreTemplates.apiService(config.features),
    );
    await FileUtils.createFile(
      path.join(p, 'dio_factory.dart'),
      CoreTemplates.dioFactory(),
    );
  }

  Future<void> _generateRouting(String corePath) async {
    final p = path.join(corePath, 'routing');
    await FileUtils.createFile(
      path.join(p, 'app_router.dart'),
      CoreTemplates.appRouter(config.features),
    );
    await FileUtils.createFile(
      path.join(p, 'routes.dart'),
      CoreTemplates.routes(config.features),
    );
  }

  Future<void> _generateTheming(String corePath) async {
    final p = path.join(corePath, 'theming');
    await FileUtils.createFile(
      path.join(p, 'colors.dart'),
      CoreTemplates.colors(),
    );
    await FileUtils.createFile(
      path.join(p, 'font_weight_helper.dart'),
      CoreTemplates.fontWeightHelper(),
    );
    await FileUtils.createFile(
      path.join(p, 'styles.dart'),
      CoreTemplates.styles(),
    );
  }

  Future<void> _generateWidgets(String corePath) async {
    final p = path.join(corePath, 'widgets');
    await FileUtils.createFile(
      path.join(p, 'custom_app_bar.dart'),
      CoreTemplates.customAppBar(),
    );
    await FileUtils.createFile(
      path.join(p, 'loading_widget.dart'),
      CoreTemplates.loadingWidget(),
    );
    await FileUtils.createFile(
      path.join(p, 'error_widget.dart'),
      CoreTemplates.errorWidget(),
    );
  }

  // ── FEATURE GENERATION ──────────────────────

  Future<void> _generateFeature(String featureName) async {
    logger.detail('Generating feature: $featureName...');

    final featurePath = path.join(
      config.outputPath,
      'features',
      featureName,
    );

    await _generateData(featurePath, featureName);
    await _generateLogic(featurePath, featureName);
    await _generateUI(featurePath, featureName);

    logger.detail('✅ Feature "$featureName" generated');
  }

  Future<void> _generateData(
    String featurePath,
    String featureName,
  ) async {
    // apis/
    await FileUtils.createFile(
      path.join(featurePath, 'data', 'apis',
          '${featureName}_api_constants.dart'),
      FeatureTemplates.apiConstants(featureName),
    );
    await FileUtils.createFile(
      path.join(featurePath, 'data', 'apis',
          '${featureName}_api_service.dart'),
      FeatureTemplates.apiService(featureName),
    );

    // models/
    await FileUtils.createFile(
      path.join(featurePath, 'data', 'models',
          '${featureName}_request_body.dart'),
      FeatureTemplates.requestBody(featureName),
    );
    await FileUtils.createFile(
      path.join(featurePath, 'data', 'models',
          '${featureName}_response.dart'),
      FeatureTemplates.response(featureName),
    );

    // repos/
    await FileUtils.createFile(
      path.join(featurePath, 'data', 'repos',
          '${featureName}_repo.dart'),
      FeatureTemplates.repo(featureName),
    );
  }

  Future<void> _generateLogic(
    String featurePath,
    String featureName,
  ) async {
    final cubitPath = path.join(featurePath, 'logic', 'cubit');

    await FileUtils.createFile(
      path.join(cubitPath, '${featureName}_cubit.dart'),
      FeatureTemplates.cubit(featureName),
    );
    await FileUtils.createFile(
      path.join(cubitPath, '${featureName}_state.dart'),
      FeatureTemplates.cubitState(featureName),
    );
  }

  Future<void> _generateUI(
    String featurePath,
    String featureName,
  ) async {
    final fileName = ProjectConfig.toFileName(featureName);
    await FileUtils.createFile(
      path.join(featurePath, 'ui', '${fileName}_screen.dart'),
      FeatureTemplates.screen(featureName),
    );
  }

  Future<void> _generateMain() async {
    await FileUtils.createFile(
      path.join(config.outputPath, 'main.dart'),
      CoreTemplates.mainDart(),
    );
  }
}
import 'dart:io';

import 'package:flutter_clean_structure/flutter_clean_structure.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('flutter_clean_structure_');
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('ProjectConfig', () {
    test('outputPath defaults to lib', () {
      const config = ProjectConfig(projectName: 'app', features: ['auth']);

      expect(config.outputPath, 'lib');
    });

    test('toClassName converts snake_case to PascalCase', () {
      expect(ProjectConfig.toClassName('auth'), 'Auth');
      expect(ProjectConfig.toClassName('my_feature'), 'MyFeature');
      expect(ProjectConfig.toClassName('user_profile_page'), 'UserProfilePage');
    });

    test('toClassName ignores empty segments', () {
      expect(ProjectConfig.toClassName('my__feature'), 'MyFeature');
    });

    test('toFileName converts PascalCase to snake_case', () {
      expect(ProjectConfig.toFileName('MyFeature'), 'my_feature');
      expect(ProjectConfig.toFileName('UserProfilePage'), 'user_profile_page');
    });

    test('toFileName keeps snake_case names unchanged', () {
      expect(ProjectConfig.toFileName('auth'), 'auth');
      expect(ProjectConfig.toFileName('user_profile'), 'user_profile');
    });
  });

  group('FileUtils', () {
    test('createFile creates missing parent directories', () async {
      final filePath = p.join(tempDir.path, 'a', 'b', 'file.txt');

      await FileUtils.createFile(filePath, 'hello');

      expect(File(filePath).readAsStringSync(), 'hello');
    });

    test('createFile never overwrites an existing file', () async {
      final filePath = p.join(tempDir.path, 'file.txt');

      await FileUtils.createFile(filePath, 'first');
      await FileUtils.createFile(filePath, 'second');

      expect(File(filePath).readAsStringSync(), 'first');
    });

    test('createGitKeep creates an empty .gitkeep file', () async {
      final dirPath = p.join(tempDir.path, 'empty');

      await FileUtils.createGitKeep(dirPath);

      final gitKeep = File(p.join(dirPath, '.gitkeep'));
      expect(gitKeep.existsSync(), isTrue);
      expect(gitKeep.readAsStringSync(), isEmpty);
    });

    test('joinPath joins parts with the platform separator', () {
      expect(
        FileUtils.joinPath(['a', 'b', 'c']),
        p.join('a', 'b', 'c'),
      );
    });
  });

  group('ProjectGenerator', () {
    ProjectGenerator buildGenerator(List<String> features) {
      return ProjectGenerator(
        config: ProjectConfig(
          projectName: 'demo',
          features: features,
          outputPath: tempDir.path,
        ),
        logger: Logger(),
      );
    }

    bool exists(List<String> segments) {
      return File(p.joinAll([tempDir.path, ...segments])).existsSync();
    }

    test('generate creates core, features and main.dart', () async {
      await buildGenerator(['auth', 'user_profile']).generate();

      expect(exists(['core', 'di', 'dependency_injection.dart']), isTrue);
      expect(exists(['core', 'networking', 'dio_factory.dart']), isTrue);
      expect(exists(['core', 'routing', 'app_router.dart']), isTrue);
      expect(exists(['core', 'theming', 'colors.dart']), isTrue);
      expect(exists(['core', 'widgets', 'error_widget.dart']), isTrue);
      expect(exists(['main.dart']), isTrue);

      for (final feature in ['auth', 'user_profile']) {
        expect(
          exists(['features', feature, 'data', 'apis', '${feature}_api_service.dart']),
          isTrue,
        );
        expect(
          exists(['features', feature, 'data', 'repos', '${feature}_repo.dart']),
          isTrue,
        );
        expect(
          exists(['features', feature, 'logic', 'cubit', '${feature}_cubit.dart']),
          isTrue,
        );
        expect(
          exists(['features', feature, 'ui', '${feature}_screen.dart']),
          isTrue,
        );
      }
    });

    test('generateFeatureOnly leaves core untouched', () async {
      await buildGenerator(['orders']).generateFeatureOnly('orders');

      expect(
        exists(['features', 'orders', 'ui', 'orders_screen.dart']),
        isTrue,
      );
      expect(Directory(p.join(tempDir.path, 'core')).existsSync(), isFalse);
      expect(exists(['main.dart']), isFalse);
    });

    test('generate never overwrites existing files', () async {
      final mainFile = File(p.join(tempDir.path, 'main.dart'))
        ..writeAsStringSync('// my own main');

      await buildGenerator(['auth']).generate();

      expect(mainFile.readAsStringSync(), '// my own main');
    });

    test('generated router imports the screen file that exists', () async {
      await buildGenerator(['user_profile']).generate();

      final router = File(
        p.join(tempDir.path, 'core', 'routing', 'app_router.dart'),
      ).readAsStringSync();

      expect(
        router,
        contains('features/user_profile/ui/user_profile_screen.dart'),
      );
      expect(exists(['features', 'user_profile', 'ui', 'user_profile_screen.dart']), isTrue);
    });
  });
}

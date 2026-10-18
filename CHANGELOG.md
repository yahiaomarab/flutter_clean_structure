# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.1] - 2026-10-18

### Added
- Dartdoc comments on the entire public API, plus a library-level overview
- `example/main.dart` showing how to use the generator from Dart code
- Unit tests for `ProjectConfig`, `FileUtils` and `ProjectGenerator`
- `topics` and `issue_tracker` in `pubspec.yaml` for better discoverability

### Fixed
- Generated `app_router.dart` imported `presentation/pages/<name>_page.dart`,
  which is never generated; it now imports `ui/<name>_screen.dart`
- `ProjectConfig.toFileName` removed the underscore from snake_case names,
  so `user_profile` became `userprofile`
- `ProjectConfig.toClassName` crashed on empty name segments such as `a__b`
- The success message printed a folder layout (`domain/`, `presentation/`,
  `constants/`) that did not match the generated files, and pointed to a
  non-existent `injection_container.dart`

### Changed
- Resolved all `dart analyze` findings (unnecessary string interpolation
  braces and library name)
- `ProjectConfig` now has a `const` constructor

---

## [1.0.0] - 2026-06-27

### Added
- Initial release of `flutter_clean_structure`
- CLI command `create` to scaffold Flutter project structure in one command
- Full project generation mode (`--full` / `-f`) with interactive prompts
- Single feature generation mode (`--name` / `-n`) for adding features to existing projects
- Interactive mode when no arguments are provided
- Core folder generation:
  - `di/` — dependency injection setup using `get_it`
  - `helper/` — app regex, constants, extensions, shared preferences helper, spacing utilities
  - `networking/` — Dio factory, Retrofit API service, error handler, error model, API result with Freezed
  - `routing/` — `AppRouter` with `switch/case` route generation and `Routes` constants
  - `theming/` — color manager, font weight helper, text styles
  - `widgets/` — custom app bar, loading widget, error widget
- Feature folder generation per feature:
  - `data/apis/` — feature API constants and Retrofit API service
  - `data/models/` — request body and response models with `json_annotation`
  - `data/repos/` — repository with `ApiResult` pattern
  - `logic/cubit/` — Cubit and Freezed state
  - `ui/` — screen with `BlocBuilder`
- `main.dart` generation with `ScreenUtilInit`, `GetIt`, and `AppRouter` wired up
- Beautiful terminal output using `mason_logger` with progress indicators
- Cross-platform path handling via the `path` package
- Safe file creation — never overwrites existing files
- `ProjectConfig` model with `toClassName()` and `toFileName()` conversion utilities

---

## [Unreleased]

### Planned
- Support for generating multiple features in a single `--name` call (comma-separated)
- `--update` flag to regenerate only specific layers of an existing feature
- Option to choose state management (Cubit vs Bloc vs Riverpod)
- Option to choose navigation (Navigator 1.0 vs GoRouter)
- `pubspec.yaml` dependency injection after generation
- More unit tests that check the content of generated templates
- Support for custom template overrides via config file
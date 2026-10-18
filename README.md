# flutter_clean_structure

A Dart CLI tool that scaffolds a complete, production-ready Flutter project structure in one command — so you spend zero time creating folders and files manually, and 100% of your time writing features.

---

## What It Generates

Running the tool produces a fully wired project structure based on the architecture pattern used in real production Flutter apps:

```
lib/
├── core/
│   ├── di/
│   │   └── dependency_injection.dart       ← GetIt setup
│   ├── helper/
│   │   ├── app_regex.dart                  ← Validation helpers
│   │   ├── constants.dart                  ← Shared constants & SharedPrefKeys
│   │   ├── extensions.dart                 ← BuildContext, String, List extensions
│   │   ├── shared_pref_helper.dart         ← SharedPreferences + FlutterSecureStorage
│   │   └── spacing.dart                    ← verticalSpace() / horizontalSpace()
│   ├── networking/
│   │   ├── api_constants.dart              ← Base URL & endpoint constants
│   │   ├── api_error_handler.dart          ← DioException → ApiErrorModel
│   │   ├── api_error_model.dart            ← JSON-serializable error model
│   │   ├── api_result.dart                 ← Freezed Success/Failure sealed class
│   │   ├── api_service.dart                ← Base Retrofit ApiService
│   │   └── dio_factory.dart                ← Dio singleton with token management
│   ├── routing/
│   │   ├── app_router.dart                 ← Switch/case route generator
│   │   └── routes.dart                     ← Route name constants
│   ├── theming/
│   │   ├── colors.dart                     ← ColorsManager
│   │   ├── font_weight_helper.dart         ← FontWeightHelper
│   │   └── styles.dart                     ← AppTextStyles
│   └── widgets/
│       ├── custom_app_bar.dart             ← Reusable AppBar
│       ├── loading_widget.dart             ← Centered loading indicator
│       └── error_widget.dart              ← Error state with retry
│
├── features/
│   └── your_feature/
│       ├── data/
│       │   ├── apis/
│       │   │   ├── your_feature_api_constants.dart   ← Endpoint paths
│       │   │   └── your_feature_api_service.dart     ← Retrofit service
│       │   ├── models/
│       │   │   ├── your_feature_request_body.dart    ← Request model
│       │   │   └── your_feature_response.dart        ← Response model
│       │   └── repos/
│       │       └── your_feature_repo.dart            ← Data repository
│       ├── logic/
│       │   └── cubit/
│       │       ├── your_feature_cubit.dart           ← Business logic
│       │       └── your_feature_state.dart           ← Freezed state
│       └── ui/
│           └── your_feature_screen.dart              ← UI screen
│
└── main.dart                                         ← App entry point
```

---

## Installation

Add the package to your Flutter project's `dev_dependencies`:

```yaml
dev_dependencies:
  flutter_clean_structure: ^1.0.0
```

Then run:

```bash
dart pub get
```

---

## Usage

### Interactive Mode

Run with no arguments to get a guided prompt:

```bash
dart run flutter_clean_structure:create
```

```
🚀 Flutter Clean Structure Generator
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

What would you like to generate?
  1. Full project structure
  2. New feature only

→ Enter choice (1 or 2): 1
→ Enter project name: my_app
→ Enter feature names (comma separated)
  e.g. auth,home,products,profile: auth,home,profile
```

---

### Generate Full Project

```bash
dart run flutter_clean_structure:create --full
```

or using the short flag:

```bash
dart run flutter_clean_structure:create -f
```

You will be prompted for a project name and a comma-separated list of feature names.

---

### Generate a Single Feature

Add a new feature to an existing project:

```bash
dart run flutter_clean_structure:create --name auth
```

or using the short flag:

```bash
dart run flutter_clean_structure:create -n auth
```

This generates only the feature folder under `lib/features/auth/` without touching any core files.

---

### Help

```bash
dart run flutter_clean_structure:create --help
```

---

## Dependencies Used in Generated Code

The generated project uses these packages. Add them to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_bloc: ^8.1.6
  get_it: ^8.0.2
  dio: ^5.7.0
  retrofit: ^4.4.1
  json_annotation: ^4.9.0
  freezed_annotation: ^2.4.4
  shared_preferences: ^2.3.3
  flutter_secure_storage: ^9.2.2
  flutter_screenutil: ^5.9.3
  pretty_dio_logger: ^1.4.0

dev_dependencies:
  build_runner: ^2.4.13
  retrofit_generator: ^9.1.4
  json_serializable: ^6.8.0
  freezed: ^2.5.7
```

After adding dependencies, run code generation:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Architecture

This tool generates code following a **feature-first** architecture with a shared core:

```
Feature
  └── data       ← API calls, models, repositories
  └── logic      ← Cubit + Freezed state
  └── ui         ← Screens and widgets

Core
  └── networking ← Dio, Retrofit, error handling
  └── routing    ← Navigator 1.0 with AppRouter
  └── di         ← GetIt dependency injection
  └── theming    ← Colors, fonts, text styles
  └── helper     ← Shared utilities
  └── widgets    ← Shared reusable widgets
```

**State management:** `flutter_bloc` (Cubit)  
**Networking:** `dio` + `retrofit`  
**Dependency injection:** `get_it`  
**Code generation:** `freezed` + `json_serializable` + `retrofit_generator`  
**Navigation:** Navigator 1.0 with named routes

---

## After Generation — Next Steps

1. **Set your base URL** in `lib/core/networking/api_constants.dart`
2. **Register your dependencies** in `lib/core/di/dependency_injection.dart`
3. **Add your endpoints** in each feature's `data/apis/feature_api_constants.dart`
4. **Define your Retrofit methods** in `data/apis/feature_api_service.dart`
5. **Run code generation:**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
6. **Add your routes** to `lib/core/routing/routes.dart` and `app_router.dart`
7. **Start building** your screens in `ui/`

---

## Example

Generating a project with `auth`, `home`, and `profile` features:

```bash
dart run flutter_clean_structure:create --full
→ Enter project name: my_app
→ Enter feature names: auth,home,profile
```

Result: **45 files** created instantly across a fully organized project structure.

Adding a new feature later:

```bash
dart run flutter_clean_structure:create --name orders
```

Result: **8 files** created under `lib/features/orders/` in the correct structure.

---

## Contributing

Contributions are welcome! Please open an issue first to discuss what you'd like to change.

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/my-feature`
3. Commit your changes: `git commit -m 'Add my feature'`
4. Push to the branch: `git push origin feature/my-feature`
5. Open a Pull Request

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
// lib/src/templates/core_templates.dart
// All template strings for core files

import 'package:flutter_clean_structure/src/models/project_config.dart';

class CoreTemplates {
  CoreTemplates._();

  // ── DI ──────────────────────────────────────

  static String injectionContainer(List<String> features) {
    final featureInits = features.map((f) => '''
  // ${ProjectConfig.toClassName(f)} feature
  // TODO: Register ${ProjectConfig.toClassName(f)} dependencies
  // getIt.registerLazySingleton<${ProjectConfig.toClassName(f)}ApiService>(
  //   () => ${ProjectConfig.toClassName(f)}ApiService(dio),
  // );
  // getIt.registerLazySingleton<${ProjectConfig.toClassName(f)}Repo>(
  //   () => ${ProjectConfig.toClassName(f)}Repo(getIt<${ProjectConfig.toClassName(f)}ApiService>()),
  // );
  // getIt.registerFactory<${ProjectConfig.toClassName(f)}Cubit>(
  //   () => ${ProjectConfig.toClassName(f)}Cubit(getIt<${ProjectConfig.toClassName(f)}Repo>()),
  // );
''').join('\n');

    return '''
// lib/core/di/dependency_injection.dart
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../networking/dio_factory.dart';
import '../networking/api_service.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // ── NETWORKING ────────────────────────────
  Dio dio = DioFactory.getDio();
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));

  // ── FEATURES ──────────────────────────────
$featureInits
}
''';
  }

  // ── HELPER ──────────────────────────────────

  static String appRegex() => r'''
// lib/core/helper/app_regex.dart

class AppRegex {
  static bool isEmailValid(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@(gmail\.com|yahoo\.com|hotmail\.com|mac\.com|icloud\.com)$',
    ).hasMatch(email);
  }

  static bool isPasswordValid(String password) {
    return RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$",
    ).hasMatch(password);
  }

  static bool isPhoneNumberValid(String phoneNumber) {
    return RegExp(r'^(010|011|012|015)[0-9]{8}$').hasMatch(phoneNumber);
  }

  static bool hasLowerCase(String password) {
    return RegExp(r'^(?=.*[a-z])').hasMatch(password);
  }

  static bool hasUpperCase(String password) {
    return RegExp(r'^(?=.*[A-Z])').hasMatch(password);
  }

  static bool hasNumber(String password) {
    return RegExp(r'^(?=.*?[0-9])').hasMatch(password);
  }

  static bool hasSpecialCharacter(String password) {
    return RegExp(r'^(?=.*?[#?!@$%^&*-])').hasMatch(password);
  }

  static bool hasMinLength(String password) {
    return RegExp(r'^(?=.{8,})').hasMatch(password);
  }
}
''';

  static String constants() => '''
// lib/core/helper/constants.dart

bool isLoggedInUser = false;

class SharedPrefKeys {
  static const String userToken = 'token';
}
''';

  static String extensions() => '''
// lib/core/helper/extensions.dart
import 'package:flutter/material.dart';

extension Navigation on BuildContext {
  Future<dynamic> pushNamed(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(this)
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(this).pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic> pushNamedAndRemoveUntil(
    String routeName, {
    Object? arguments,
    required RoutePredicate predicate,
  }) {
    return Navigator.of(this).pushNamedAndRemoveUntil(
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  void pop() => Navigator.of(this).pop();
}

extension StringExtension on String? {
  bool isNullOrEmpty() => this == null || this == '';
}

extension ListExtension<T> on List<T>? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;
}
''';

  static String sharedPrefHelper() => '''
// lib/core/helper/shared_pref_helper.dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  SharedPrefHelper._();

  static Future<void> removeData(String key) async {
    debugPrint(
      'SharedPrefHelper : data with key : \$key has been removed',
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> clearAllData() async {
    debugPrint('SharedPrefHelper : all data has been cleared');
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> setData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    debugPrint(
      'SharedPrefHelper : setData with key : \$key and value : \$value',
    );
    switch (value.runtimeType) {
      case String:
        await prefs.setString(key, value);
        break;
      case int:
        await prefs.setInt(key, value);
        break;
      case bool:
        await prefs.setBool(key, value);
        break;
      case double:
        await prefs.setDouble(key, value);
        break;
    }
  }

  static Future<bool> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static Future<double> getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key) ?? 0.0;
  }

  static Future<int> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }

  static Future<String> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  static Future<List<String>> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  static Future<void> setStringList(
    String key,
    List<String> values,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, values);
  }

  static Future<void> setIntList(
    String key,
    List<int> values,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final stringList = values.map((e) => e.toString()).toList();
    await prefs.setStringList(key, stringList);
  }

  static Future<List<int>> getIntList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final stringList = prefs.getStringList(key);
    return stringList?.map((e) => int.tryParse(e) ?? 0).toList() ?? [];
  }

  // ── SECURE STORAGE ──────────────────────────

  static Future<void> setSecuredString(
    String key,
    String value,
  ) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: key, value: value);
  }

  static Future<String> getSecuredString(String key) async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: key) ?? '';
  }

  static Future<void> clearAllSecuredData() async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
  }
}
''';

  static String spacing() => '''
// lib/core/helper/spacing.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

SizedBox verticalSpace(double height) => SizedBox(height: height.h);
SizedBox horizontalSpace(double width) => SizedBox(width: width.w);
''';

  // ── NETWORKING ───────────────────────────────

  static String apiConstants() => '''
// lib/core/networking/api_constants.dart

class ApiConstants {
  static const String apiBaseUrl = 'https://api.example.com/api/';

  // ── AUTH ──────────────────────────────────
  static const String login = 'login';
  static const String signUp = 'register';
  static const String logout = 'logout';
  static const String refreshToken = 'refresh-token';
}

class ApiErrors {
  static const String badRequestError = 'badRequestError';
  static const String noContent = 'noContent';
  static const String forbiddenError = 'forbiddenError';
  static const String unauthorizedError = 'unauthorizedError';
  static const String notFoundError = 'notFoundError';
  static const String conflictError = 'conflictError';
  static const String internalServerError = 'internalServerError';
  static const String unknownError = 'unknownError';
  static const String timeoutError = 'timeoutError';
  static const String defaultError = 'defaultError';
  static const String cacheError = 'cacheError';
  static const String noInternetError = 'noInternetError';
}
''';

  static String apiErrorHandler() => '''
// lib/core/networking/api_error_handler.dart
import 'package:dio/dio.dart';
import 'api_error_model.dart';

class ApiErrorHandler {
  static ApiErrorModel handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          return ApiErrorModel(
            message: 'Connection to server failed',
          );
        case DioExceptionType.cancel:
          return ApiErrorModel(
            message: 'Request was cancelled',
          );
        case DioExceptionType.connectionTimeout:
          return ApiErrorModel(
            message: 'Connection timeout with server',
          );
        case DioExceptionType.receiveTimeout:
          return ApiErrorModel(
            message: 'Receive timeout with server',
          );
        case DioExceptionType.sendTimeout:
          return ApiErrorModel(
            message: 'Send timeout with server',
          );
        case DioExceptionType.badResponse:
          return _handleError(error.response?.data);
        default:
          return ApiErrorModel(
            message: 'Something went wrong',
          );
      }
    }
    return ApiErrorModel(message: 'Unknown error occurred');
  }

  static ApiErrorModel _handleError(dynamic data) {
    if (data == null) {
      return ApiErrorModel(message: 'Unknown error occurred');
    }
    return ApiErrorModel(
      message: data['message'] as String? ?? 'Unknown error occurred',
      code: data['code'] as int?,
      errors: data['data'],
    );
  }
}
''';

  static String apiErrorModel() => '''
// lib/core/networking/api_error_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'api_error_model.g.dart';

@JsonSerializable()
class ApiErrorModel {
  final String? message;
  final int? code;

  @JsonKey(name: 'data')
  final dynamic errors;

  ApiErrorModel({
    this.message,
    this.code,
    this.errors,
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) =>
      _\$ApiErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _\$ApiErrorModelToJson(this);

  String getAllErrorMessages() {
    if (errors == null ||
        (errors is List && (errors as List).isEmpty)) {
      return message ?? 'Unknown error occurred';
    }

    if (errors is Map<String, dynamic>) {
      return (errors as Map<String, dynamic>).entries.map((entry) {
        final value = entry.value;
        if (value is List) {
          return value.map((e) => e.toString()).join(', ');
        }
        return value.toString();
      }).join('\n');
    } else if (errors is List) {
      return (errors as List).map((e) => e.toString()).join('\n');
    }

    return message ?? 'Unknown error occurred';
  }
}
''';

  static String apiResult() => '''
// lib/core/networking/api_result.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'api_error_model.dart';

part 'api_result.freezed.dart';

@Freezed()
abstract class ApiResult<T> with _\$ApiResult<T> {
  const factory ApiResult.success(T data) = Success<T>;
  const factory ApiResult.failure(ApiErrorModel apiErrorModel) = Failure<T>;
}
''';

  static String apiService(List<String> features) => '''
// lib/core/networking/api_service.dart
// This is the base ApiService using Retrofit.
// Each feature should have its own ApiService for its endpoints.
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'api_constants.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  // TODO: Add your shared/auth endpoints here
  // Example:
  // @POST(ApiConstants.login)
  // Future<LoginResponse> login(@Body() LoginRequestBody body);
}
''';

  static String dioFactory() => '''
// lib/core/networking/dio_factory.dart
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../helper/shared_pref_helper.dart';
import '../helper/constants.dart';
import 'api_constants.dart';

class DioFactory {
  DioFactory._();

  static Dio? _dio;

  static Dio getDio() {
    const timeout = Duration(seconds: 90);

    if (_dio == null) {
      _dio = Dio();
      _dio!
        ..options.baseUrl = ApiConstants.apiBaseUrl
        ..options.connectTimeout = timeout
        ..options.receiveTimeout = timeout;
      _addHeaders();
      _addInterceptors();
      return _dio!;
    }
    return _dio!;
  }

  static void _addHeaders() async {
    final token = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userToken,
    );
    _dio?.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer \$token',
    };
  }

  static void setTokenAfterLogin(String token) {
    _dio?.options.headers['Authorization'] = 'Bearer \$token';
  }

  static void clearToken() {
    _dio?.options.headers.remove('Authorization');
  }

  static void _addInterceptors() {
    _dio?.interceptors.add(
      PrettyDioLogger(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    );
  }
}
''';

  // ── ROUTING ─────────────────────────────────

  static String appRouter(List<String> features) {
    final cases = features.map((f) {
      final className = ProjectConfig.toClassName(f);
      return '''
      case Routes.${f}Screen:
        return MaterialPageRoute(
          builder: (_) => const ${className}Screen(),
        );''';
    }).join('\n');

    final imports = features.map((f) {
      final fileName = ProjectConfig.toFileName(f);
      return "import '../../features/$f/ui/${fileName}_screen.dart';";
    }).join('\n');

    return '''
// lib/core/routing/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
$imports
import '../di/dependency_injection.dart';
import 'routes.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
$cases
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                'No route defined for \${settings.name}',
              ),
            ),
          ),
        );
    }
  }
}
''';
  }

  static String routes(List<String> features) {
    final routeConstants = features.map((f) {
      return "  static const String ${f}Screen = '/${f}Screen';";
    }).join('\n');

    return '''
// lib/core/routing/routes.dart

class Routes {
$routeConstants
}
''';
  }

  // ── THEMING ─────────────────────────────────

  static String colors() => '''
// lib/core/theming/colors.dart
import 'package:flutter/material.dart';

class ColorsManager {
  // Primary
  static const Color mainBlue = Color(0xFF8AABFF);

  // Neutral
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray = Color(0xFFDEDEDE);
  static const Color lightGray = Color(0xFFF3F0F0);
  static const Color lighterGray = Color(0xFFEDEDED);

  // Dark shades
  static const Color lightBlack = Color(0xFF262525);
  static const Color lighterBlack = Color(0xFF4A4A4A);

  // Accent
  static const Color yellow = Color(0xFFE0FF58);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
}
''';

  static String fontWeightHelper() => '''
// lib/core/theming/font_weight_helper.dart
import 'package:flutter/material.dart';

class FontWeightHelper {
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
}
''';

  static String styles() => '''
// lib/core/theming/styles.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'colors.dart';
import 'font_weight_helper.dart';

class AppTextStyles {
  // ── WHITE ───────────────────────────────────
  static TextStyle font8WhiteBold = TextStyle(
    fontSize: 8.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.white,
    fontFamily: 'Cairo',
  );

  static TextStyle font6WhiteBold = TextStyle(
    fontSize: 6.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.white,
    fontFamily: 'Cairo',
  );

  static TextStyle font5WhiteBold = TextStyle(
    fontSize: 5.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.white,
    fontFamily: 'Cairo',
  );

  static TextStyle font4WhiteBold = TextStyle(
    fontSize: 4.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.white,
    fontFamily: 'Cairo',
  );

  static TextStyle font4WhiteRegular = TextStyle(
    fontSize: 4.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.white,
    fontFamily: 'Cairo',
  );

  static TextStyle font3WhiteBold = TextStyle(
    fontSize: 3.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.white,
    fontFamily: 'Cairo',
  );

  // ── BLACK ───────────────────────────────────
  static TextStyle font6BlackBold = TextStyle(
    fontSize: 6.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.black,
    fontFamily: 'Cairo',
  );

  static TextStyle font5BlackBold = TextStyle(
    fontSize: 5.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.black,
    fontFamily: 'Cairo',
  );

  static TextStyle font5BlackRegular = TextStyle(
    fontSize: 5.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.black,
    fontFamily: 'Cairo',
  );

  static TextStyle font4BlackBold = TextStyle(
    fontSize: 4.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.black,
    fontFamily: 'Cairo',
  );

  static TextStyle font4BlackSemiBold = TextStyle(
    fontSize: 4.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorsManager.black,
    fontFamily: 'Cairo',
  );

  static TextStyle font4BlackRegular = TextStyle(
    fontSize: 4.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.black,
    fontFamily: 'Cairo',
  );

  static TextStyle font3BlackBold = TextStyle(
    fontSize: 3.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.black,
    fontFamily: 'Cairo',
  );

  static TextStyle font3BlackRegular = TextStyle(
    fontSize: 3.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.black,
    fontFamily: 'Cairo',
  );

  // ── BLUE ────────────────────────────────────
  static TextStyle font6BlueSemiBold = TextStyle(
    fontSize: 6.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorsManager.mainBlue,
    fontFamily: 'Cairo',
  );

  static TextStyle font5BlueBold = TextStyle(
    fontSize: 5.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.mainBlue,
    fontFamily: 'Cairo',
  );

  static TextStyle font5BlueMedium = TextStyle(
    fontSize: 5.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.mainBlue,
    fontFamily: 'Cairo',
  );

  static TextStyle font5BlueRegular = TextStyle(
    fontSize: 5.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.mainBlue,
    fontFamily: 'Cairo',
  );

  static TextStyle font4BlueSemiBold = TextStyle(
    fontSize: 4.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorsManager.mainBlue,
    fontFamily: 'Cairo',
  );

  static TextStyle font3BlueSemiBold = TextStyle(
    fontSize: 3.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorsManager.mainBlue,
    fontFamily: 'Cairo',
  );

  static TextStyle font3BlueBold = TextStyle(
    fontSize: 3.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.mainBlue,
    fontFamily: 'Cairo',
  );

  static TextStyle font3BlueRegular = TextStyle(
    fontSize: 3.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.mainBlue,
    fontFamily: 'Cairo',
  );

  // ── GRAY ────────────────────────────────────
  static TextStyle font4LightGrayRegular = TextStyle(
    fontSize: 4.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.lighterGray,
    fontFamily: 'Cairo',
  );
}
''';

  // ── WIDGETS ─────────────────────────────────

  static String customAppBar() => '''
// lib/core/widgets/custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theming/colors.dart';
import '../theming/styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: const BoxDecoration(
        color: ColorsManager.mainBlue,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              title,
              style: AppTextStyles.font8WhiteBold,
              textAlign: TextAlign.center,
            ),
          ),
          if (showBackButton)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: ColorsManager.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          if (actions != null)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Row(children: actions!),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(20.h);
}
''';

  static String loadingWidget() => '''
// lib/core/widgets/loading_widget.dart
import 'package:flutter/material.dart';
import '../theming/colors.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: ColorsManager.mainBlue,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
''';

  static String errorWidget() => '''
// lib/core/widgets/error_widget.dart
import 'package:flutter/material.dart';
import '../theming/colors.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: ColorsManager.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
''';

  // ── MAIN.DART ────────────────────────────────

  static String mainDart() => '''
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/di/dependency_injection.dart';
import 'core/routing/app_router.dart';
import 'core/theming/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupGetIt();
  runApp(MyApp(appRouter: AppRouter()));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'My App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: ColorsManager.mainBlue,
            fontFamily: 'Cairo',
          ),
          onGenerateRoute: appRouter.generateRoute,
        );
      },
    );
  }
}
''';
}
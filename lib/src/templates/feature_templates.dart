// lib/src/templates/feature_templates.dart

import '../models/project_config.dart';

class FeatureTemplates {
  FeatureTemplates._();

  // ── DATA / APIS ──────────────────────────────

  static String apiConstants(String featureName) {
    final className = ProjectConfig.toClassName(featureName);
    return '''
// lib/features/$featureName/data/apis/${featureName}_api_constants.dart

class ${className}ApiConstants {
  // TODO: Add your $featureName endpoints here
  // Example:
  static const String getAll$className = '${featureName}s';
  static const String getOnce$className = '${featureName}s/{index}';
  static const String add$className = '${featureName}s';
  static const String update$className = '${featureName}sUpdate/{index}';
  static const String delete$className = '${featureName}s/{index}';
}
''';
  }

  static String apiService(String featureName) {
    final className = ProjectConfig.toClassName(featureName);
    return '''
// lib/features/$featureName/data/apis/${featureName}_api_service.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/networking/api_constants.dart';
import '${featureName}_api_constants.dart';
import '../models/${featureName}_request_body.dart';
import '../models/${featureName}_response.dart';

part '${featureName}_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ${className}ApiService {
  factory ${className}ApiService(Dio dio, {String? baseUrl}) =
      _${className}ApiService;

  // TODO: Add your endpoints here
  // Example:
  // @GET(${className}ApiConstants.getAll$className)
  // Future<${className}Response> getAll${className}s();

  // @POST(${className}ApiConstants.add$className)
  // Future<${className}Response> add$className(
  //   @Body() ${className}RequestBody requestBody,
  // );

  // @DELETE(${className}ApiConstants.delete$className)
  // Future<${className}Response> delete$className(
  //   @Path("index") int index,
  // );
}
''';
  }

  // ── DATA / MODELS ────────────────────────────

  static String requestBody(String featureName) {
    final className = ProjectConfig.toClassName(featureName);
    return '''
// lib/features/$featureName/data/models/${featureName}_request_body.dart
import 'package:json_annotation/json_annotation.dart';

part '${featureName}_request_body.g.dart';

@JsonSerializable()
class ${className}RequestBody {
  // TODO: Add your request fields here
  // Example:
  // final String name;
  // final String description;

  const ${className}RequestBody({
    // required this.name,
  });

  Map<String, dynamic> toJson() =>
      _\$${className}RequestBodyToJson(this);
}
''';
  }

  static String response(String featureName) {
    final className = ProjectConfig.toClassName(featureName);
    return '''
// lib/features/$featureName/data/models/${featureName}_response.dart
import 'package:json_annotation/json_annotation.dart';

part '${featureName}_response.g.dart';

@JsonSerializable()
class ${className}Response {
  final bool? success;
  final String? message;

  @JsonKey(name: 'data')
  final ${className}Data? data;

  ${className}Response({
    this.success,
    this.message,
    this.data,
  });

  factory ${className}Response.fromJson(
    Map<String, dynamic> json,
  ) =>
      _\$${className}ResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _\$${className}ResponseToJson(this);
}

@JsonSerializable()
class ${className}Data {
  // TODO: Add your response data fields here
  // Example:
  // final int? id;
  // final String? name;

  ${className}Data();

  factory ${className}Data.fromJson(
    Map<String, dynamic> json,
  ) =>
      _\$${className}DataFromJson(json);

  Map<String, dynamic> toJson() =>
      _\$${className}DataToJson(this);
}
''';
  }

  // ── DATA / REPOS ─────────────────────────────

  static String repo(String featureName) {
    final className = ProjectConfig.toClassName(featureName);
    return '''
// lib/features/$featureName/data/repos/${featureName}_repo.dart
import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';
import '../apis/${featureName}_api_service.dart';
import '../models/${featureName}_request_body.dart';
import '../models/${featureName}_response.dart';

class ${className}Repo {
  final ${className}ApiService _apiService;

  ${className}Repo(this._apiService);

  // TODO: Implement your repo methods
  // Example:
  // Future<ApiResult<${className}Response>> get${className}s() async {
  //   try {
  //     final response = await _apiService.getAll${className}s();
  //     return ApiResult.success(response);
  //   } catch (e) {
  //     return ApiResult.failure(ApiErrorHandler.handle(e));
  //   }
  // }

  // Future<ApiResult<${className}Response>> add$className(
  //   ${className}RequestBody requestBody,
  // ) async {
  //   try {
  //     final response = await _apiService.add$className(requestBody);
  //     return ApiResult.success(response);
  //   } catch (e) {
  //     return ApiResult.failure(ApiErrorHandler.handle(e));
  //   }
  // }
}
''';
  }

  // ── LOGIC / CUBIT ────────────────────────────

  static String cubitState(String featureName) {
    final className = ProjectConfig.toClassName(featureName);
    return '''
// lib/features/$featureName/logic/cubit/${featureName}_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/networking/api_error_model.dart';

part '${featureName}_state.freezed.dart';

@freezed
class ${className}State<T> with _\$${className}State<T> {
  const factory ${className}State.initial() = _Initial;
  const factory ${className}State.loading() = Loading;
  const factory ${className}State.success(T data) = Success<T>;
  const factory ${className}State.error(
    ApiErrorModel apiErrorModel,
  ) = Error;
}
''';
  }

  static String cubit(String featureName) {
    final className = ProjectConfig.toClassName(featureName);
    return '''
// lib/features/$featureName/logic/cubit/${featureName}_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/${featureName}_repo.dart';
import '${featureName}_state.dart';

class ${className}Cubit extends Cubit<${className}State> {
  final ${className}Repo _${featureName}Repo;

  ${className}Cubit(this._${featureName}Repo)
      : super(const ${className}State.initial());

  // TODO: Add your cubit methods here
  // Example:
  // Future<void> get${className}s() async {
  //   emit(const ${className}State.loading());
  //   final response = await _${featureName}Repo.get${className}s();
  //   response.when(
  //     success: (data) => emit(${className}State.success(data)),
  //     failure: (error) => emit(${className}State.error(error)),
  //   );
  // }
}
''';
  }

  // ── UI ───────────────────────────────────────

  static String screen(String featureName) {
    final className = ProjectConfig.toClassName(featureName);
    final fileName = ProjectConfig.toFileName(featureName);
    return '''
// lib/features/$featureName/ui/${fileName}_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/error_widget.dart';
import '../logic/cubit/${featureName}_cubit.dart';
import '../logic/cubit/${featureName}_state.dart';

class ${className}Screen extends StatelessWidget {
  const ${className}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$className'),
      ),
      body: BlocBuilder<${className}Cubit, ${className}State>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const LoadingWidget(),
            success: (data) {
              // TODO: Build your success UI here
              return const Center(
                child: Text('$className loaded!'),
              );
            },
            error: (apiErrorModel) => AppErrorWidget(
              message: apiErrorModel.message ??
                  'Something went wrong',
              onRetry: () {
                // TODO: Call your cubit method to retry
              },
            ),
          );
        },
      ),
    );
  }
}
''';
  }
}
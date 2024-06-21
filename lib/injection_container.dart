import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simontaskmanager/features/core/network/network_info.dart';
import 'package:simontaskmanager/features/taskmanager/data/datasources/local/task_manager_localdatasource.dart';
import 'package:simontaskmanager/features/taskmanager/data/datasources/remote/task_manager_datasource.dart';
import 'package:simontaskmanager/features/taskmanager/data/repositories/auth_repository_impl.dart';
import 'package:simontaskmanager/features/taskmanager/data/repositories/todo_repository_impl.dart';
import 'package:simontaskmanager/features/taskmanager/domain/repositories/authRepository.dart';
import 'package:simontaskmanager/features/taskmanager/domain/repositories/todoRepository.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/auth/get_logged_in_user_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/auth/login_user_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/auth/logout_user_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/auth/refresh_token_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/todos/add_new_todo_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/todos/get_all_todos_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/todos/get_more_todos_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/todos/save_todos_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/presentation/bloc/auth_bloc.dart';
import 'package:simontaskmanager/features/taskmanager/presentation/bloc/task_manager_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simontaskmanager/features/taskmanager/presentation/pages/home_page.dart';
import 'package:simontaskmanager/features/taskmanager/presentation/pages/login_page.dart';
import 'package:simontaskmanager/features/taskmanager/utils/validators/LoginValidator.dart';
import 'package:simontaskmanager/features/taskmanager/utils/validators/todo_validator.dart';

const String LOGIN_ROUTE = "/login";
const String HOME_ROUTE = "/home";

final sl = GetIt.instance;

Future<void> init() async {
  //! Features -
  sl.registerFactory(
    () => TaskManagerBloc(sl(), sl(), sl(), sl(), sl(), sl()),
  );
  sl.registerFactory(
    () => AuthBloc(sl(), sl(), sl(), sl()),
  );

  //! Core

  sl.registerLazySingleton(() => AddNewTodoUsecase(todosRepository: sl()));
  sl.registerLazySingleton(() => GetAllTodosUseCase(todosRepository: sl()));
  sl.registerLazySingleton(() => GetMoreTodosUsecase(todosRepository: sl()));
  sl.registerLazySingleton(() => SaveTodosUsecase(todosRepository: sl()));
  sl.registerLazySingleton(() => GetLoggedInUserUsecase(authRepository: sl()));
  sl.registerLazySingleton(() => LoginUserUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => LogoutUserUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => RefreshTokenUsecase(authRepository: sl()));
  sl.registerLazySingleton(() => LoginValidator());
  sl.registerLazySingleton(() => TodoValidator());

  //repository
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(
      datasource: sl(),
      localDatasource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      datasource: sl(),
      localDatasource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<TaskManagerLocalDatasource>(
    () => TaskManagerLocalDatasourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<TaskManagerDatasource>(
    () => TaskManagerDatasourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(internetConnectionChecker: sl()));

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<GoRouter>(
    () => GoRouter(
      routes: [
        GoRoute(
          path: LOGIN_ROUTE,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: HOME_ROUTE,
          builder: (context, state) => const HomePage(),
        ),
      ],
      initialLocation: LOGIN_ROUTE,
      redirect: (context, state) async {
        final localUsecase = GetIt.instance<GetLoggedInUserUsecase>();

        final user = await localUsecase(params: NoParams());
        debugPrint(user.toString());
        return user.fold((left) => LOGIN_ROUTE, (right) => HOME_ROUTE);

        return null;
      },
    ),
  );
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio()..interceptors.add(LoggerInterceptor()));
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
}

// Define an interceptor that logs the requests and responses
class LoggerInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;

    final requestPath =
        '${options.baseUrl}${options.path}${options.queryParameters}'
        '${options.headers}';

    // Log the error request and error message
    logDebug('onError: ${options.method} request => $requestPath',
        level: Level.error);
    logDebug('onError: ${err.error}, Message: ${err.response}',
        level: Level.debug);

    // Call the super class to continue handling the error
    return super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final uri = Uri(
      scheme: options.uri.scheme,
      host: options.uri.host,
      port: options.uri.port,
      path: options.uri.path,
      queryParameters: options.queryParameters,
    );

    final fullUrl = uri.toString();
    final requestPath = fullUrl;

    // Log request details
    logDebug(
        '\n\n\n\n.........................................................................');
    logDebug('onRequest: ${options.method} request => "${requestPath}',
        level: Level.info);
    logDebug('onRequest: Request Headers => ${options.headers}',
        level: Level.info);
    logDebug('onRequest: Request Data => ${_prettyJsonEncode(options.data)}',
        level: Level.info); // Log formatted request data

    // Call the super class to continue handling the request
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Log the response status code and data
    logDebug(
        'onResponse: StatusCode: ${response.statusCode}, Data: ${_prettyJsonEncode(response.data)}',
        level: Level.debug); // Log formatted response data
    logDebug(
        '.........................................................................\n\n\n\n');

    // Call the super class to continue handling the response
    return super.onResponse(response, handler);
  }

  // Helper method to convert data to pretty JSON format
  String _prettyJsonEncode(dynamic data) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      final jsonString = encoder.convert(data);
      return jsonString;
    } catch (e) {
      return data.toString();
    }
  }
}

// Define an enum for the different log levels
enum Level { debug, info, warning, error, alien }

// Define a logDebug function that logs messages at the specified level
// log different colors
void logDebug(String message, {Level level = Level.info}) {
  // Define ANSI escape codes for different colors
  const String resetColor = '\x1B[0m';
  const String redColor = '\x1B[31m'; // Red
  const String greenColor = '\x1B[32m'; // Green
  const String yellowColor = '\x1B[33m'; // Yellow
  const String cyanColor = '\x1B[36m'; // Cyan

  // Get the current time in hours, minutes, and seconds
  final now = DateTime.now();
  final timeString =
      '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

  // Only log messages if the app is running in debug mode
  if (kDebugMode) {
    try {
      String logMessage;
      switch (level) {
        case Level.debug:
          logMessage = '$cyanColor[DEBUG][$timeString] $message$resetColor';
          break;
        case Level.info:
          logMessage = '$greenColor[INFO][$timeString] $message$resetColor';
          break;
        case Level.warning:
          logMessage =
              '$yellowColor[WARNING][$timeString] $message $resetColor';
          break;
        case Level.error:
          logMessage = '$redColor[ERROR][$timeString] $message $resetColor';
          break;
        case Level.alien:
          logMessage = '$redColor[ALIEN][$timeString] $message $resetColor';
          break;
      }
      //print(logMessage);
      // Use the DebugPrintCallback to ensure long strings are not truncated
      debugPrint(logMessage);
    } catch (e) {
      print(e.toString());
    }
  }
}

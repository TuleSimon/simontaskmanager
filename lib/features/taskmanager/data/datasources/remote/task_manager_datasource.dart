import 'package:flutter/cupertino.dart';
import 'package:simontaskmanager/features/core/error/exceptions.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/todo_dto.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/todolist_dto.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/token_dto.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/user_dto.dart';
import 'package:dio/dio.dart';

abstract class TaskManagerDatasource {
  ///
  /// calls the 'https://dummyjson.com/todos' to get all todos
  ///
  /// throws a [ServerException] for all error codes
  Future<TodoListDTO> getAllTodos({required int limit, required int offset});

  ///
  /// Calls the 'https://dummyjson.com/todos' to add a new todo
  ///
  /// throws a [ServerException] for all error codes
  Future<TodoDTO> addTodos(
      {required String todo, required int userid, required bool isCompleted});

  ///
  /// Calls the 'https://dummyjson.com/auth/login' endpoint to login a user
  ///
  /// throws a [ServerException] for all error codes
  ///
  Future<UserDTO> login(
      {required String username,
      required String password,
      required int expiresInMin});

  ///
  /// Calls the 'https://dummyjson.com/auth/refresh' endpoint to refresh user token
  ///
  /// throws a [ServerException] for all error codes
  ///
  Future<TokenDTO> refreshAuthToken(
      {required String refreshToken, required int expiresInMin});
}

class TaskManagerDatasourceImpl implements TaskManagerDatasource {
  final Dio dio;

  TaskManagerDatasourceImpl({required this.dio});

  static const String addTodosUrl = 'https://dummyjson.com/todos/add';
  static const String getAllTodosUrl = 'https://dummyjson.com/todos';
  static const String loginUrl = 'https://dummyjson.com/auth/login';
  static const String refreshAuthTokenUrl =
      'https://dummyjson.com/auth/refresh';

  @override
  Future<TodoDTO> addTodos(
      {required String todo,
      required int userid,
      required bool isCompleted}) async {
    try {
      final response = await dio.post(addTodosUrl,
          data: {'todo': todo, 'userId': userid, 'completed': isCompleted});
      if ((response.statusCode ?? 500) >= 200 &&
          (response.statusCode ?? 500) < 400) {
        return TodoDTO.fromJson(response.data);
      }
      throw DioException(requestOptions: response.requestOptions);
    } catch (exception) {
      throw handleException(exception);
    }
  }

  @override
  Future<TodoListDTO> getAllTodos(
      {required int limit, required int offset}) async {
    try {
      final response = await dio.get(getAllTodosUrl, queryParameters: {
        'limit': limit.toString(),
        'skip': offset.toString()
      });
      if ((response.statusCode ?? 500) >= 200 &&
          (response.statusCode ?? 500) < 400) {
        return TodoListDTO.fromJson(response.data);
      }
      throw DioException(requestOptions: response.requestOptions);
    } catch (exception) {
      throw handleException(exception);
    }
  }

  @override
  Future<UserDTO> login(
      {required String username,
      required String password,
      required int expiresInMin}) async {
    try {
      final response = await dio.post(loginUrl, data: {
        'username': username,
        'password': password,
        'expiresInMin': expiresInMin
      });
      if ((response.statusCode ?? 500) >= 200 &&
          (response.statusCode ?? 500) < 400) {
        return UserDTO.fromJson(response.data);
      } else {
        throw ServerException(message: response.data["message"]!.toString());
      }
    } catch (exception) {
      throw handleException(exception);
    }
  }

  @override
  Future<TokenDTO> refreshAuthToken(
      {required String refreshToken, required int expiresInMin}) async {
    try {
      final response = await dio.post(refreshAuthTokenUrl,
          data: {'refreshToken': refreshToken, 'expiresInMin': expiresInMin});
      if ((response.statusCode ?? 500) >= 200 &&
          (response.statusCode ?? 500) < 400) {
        return TokenDTO.fromJson(response.data);
      }
      throw DioException(requestOptions: response.requestOptions);
    } catch (exception) {
      throw handleException(exception);
    }
  }

  _exceptionGuard(Function() logic) {
    try {
      return logic();
    } catch (exception) {
      throw handleException(exception);
    }
  }

  Exception handleException(exception) {
    debugPrint("This is an example");
    try {
      if (exception is DioException) {
        final error = exception.response?.data["message"]?.toString();
        return ServerException(message: error ?? "An unknown error occurred");
      } else {
        return ServerException(message: "Something went wrong");
      }
    } catch (e) {
      return NetworkException();
    }
  }
}

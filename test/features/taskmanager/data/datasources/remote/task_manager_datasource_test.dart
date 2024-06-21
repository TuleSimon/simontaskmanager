import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simontaskmanager/features/core/error/exceptions.dart';
import 'package:simontaskmanager/features/taskmanager/data/datasources/remote/task_manager_datasource.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/todo_dto.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/todolist_dto.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/token_dto.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/user_dto.dart';

import '../../../../../jsons/JsonReader.dart';
import 'task_manager_datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late TaskManagerDatasourceImpl datasource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    datasource = TaskManagerDatasourceImpl(dio: mockDio);
  });

  group('TaskManagerDatasourceImpl', () {
    test('addTodos', () async {
      final responsePayload = json.decode(readJson(TodoPaths()));
      final response = Response(
        requestOptions: RequestOptions(path: ''),
        data: responsePayload,
        statusCode: 200,
      );

      when(mockDio.post(TaskManagerDatasourceImpl.addTodosUrl,
              data: anyNamed('data')))
          .thenAnswer((_) async => response);

      final result = await datasource.addTodos(
          todo: 'Do something nice for someone I care about',
          userid: 1,
          isCompleted: false);

      expect(result, isA<TodoDTO>());
      expect(result.todo, 'Do something nice for someone I care about');
    });

    test('addTodo throws an exception on failure', () async {
      // Arrange
      final errorResponse = Response(
        data: {'message': 'Invalid token'},
        statusCode: 400,
        requestOptions:
            RequestOptions(path: TaskManagerDatasourceImpl.addTodosUrl),
      );

      when(mockDio.post(TaskManagerDatasourceImpl.addTodosUrl,
              data: anyNamed('data')))
          .thenAnswer((_) async => errorResponse);

      expect(
          () async => await datasource.addTodos(
              todo: 'Do something nice for someone I care about',
              userid: 1,
              isCompleted: false),
          throwsA(isA<ServerException>()));
    });

    test('getAllTodos', () async {
      final responsePayload = json.decode(readJson(TodosPaths()));
      final response = Response(
        requestOptions: RequestOptions(path: ''),
        data: responsePayload,
        statusCode: 200,
      );

      when(mockDio.get(TaskManagerDatasourceImpl.getAllTodosUrl,
              queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => response);

      final result = await datasource.getAllTodos(limit: 10, offset: 0);

      expect(result, isA<TodoListDTO>());
      expect(result.todos.length, 1);
    });

    test('getTodos throws an exception on failure', () async {
      // Arrange
      final errorResponse = Response(
        data: {'message': 'Invalid token'},
        statusCode: 400,
        requestOptions:
            RequestOptions(path: TaskManagerDatasourceImpl.getAllTodosUrl),
      );

      when(mockDio.get(TaskManagerDatasourceImpl.getAllTodosUrl,
              queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => errorResponse);

      expect(() async => await datasource.getAllTodos(limit: 4, offset: 3),
          throwsA(isA<ServerException>()));
    });

    test('login', () async {
      final responsePayload = json.decode(readJson(UserPath()));
      final response = Response(
        requestOptions: RequestOptions(path: ''),
        data: responsePayload,
        statusCode: 200,
      );

      when(mockDio.post(TaskManagerDatasourceImpl.loginUrl,
              data: anyNamed('data')))
          .thenAnswer((_) async => response);

      final result = await datasource.login(
          username: 'emilys', password: 'test_password', expiresInMin: 60);

      expect(result, isA<UserDTO>());
      expect(result.username, 'emilys');
    });

    test('login throws an exception on failure', () async {
      // Arrange
      final errorResponse = Response(
        data: {'message': 'Invalid token'},
        statusCode: 400,
        requestOptions:
            RequestOptions(path: TaskManagerDatasourceImpl.loginUrl),
      );

      when(mockDio.post(TaskManagerDatasourceImpl.loginUrl,
              data: anyNamed('data')))
          .thenAnswer((_) async => errorResponse);

      expect(
          () async => await datasource.login(
              username: 'emilys', password: 'test_password', expiresInMin: 60),
          throwsA(isA<ServerException>()));
    });

    test('refreshAuthToken', () async {
      final responsePayload = json.decode(readJson(TokenPath()));
      final response = Response(
        requestOptions: RequestOptions(path: ''),
        data: responsePayload,
        statusCode: 200,
      );

      when(mockDio.post(TaskManagerDatasourceImpl.refreshAuthTokenUrl,
              data: anyNamed('data')))
          .thenAnswer((_) async => response);

      final result = await datasource.refreshAuthToken(
          refreshToken: 'old_refresh_token', expiresInMin: 60);

      expect(result, isA<TokenDTO>());
      expect(result.token,
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidXNlcm5hbWUiOiJtaWNoYWVsdyIsImVtYWlsIjoibWljaGFlbC53aWxsaWFtc0B4LmR1bW15anNvbi5jb20iLCJmaXJzdE5hbWUiOiJNaWNoYWVsIiwibGFzdE5hbWUiOiJXaWxsaWFtcyIsImdlbmRlciI6Im1hbGUiLCJpbWFnZSI6Imh0dHBzOi8vZHVtbXlqc29uLmNvbS9pY29uL21pY2hhZWx3LzEyOCIsImlhdCI6MTcxNzYxMzQ0OSwiZXhwIjoxNzE3NjE3MDQ5fQ.iI75FqR7VRSQ0uxZUryH_7ee-TghM_hrxSFuzwJO63I');
    });

    test('refreshAuthToken returns TokenDTO on success', () async {
      // Arrange
      const refreshToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidXNlcm5hbWUiOiJtaWNoYWVsdyIsImVtYWlsIjoibWljaGFlbC53aWxsaWFtc0B4LmR1bW15anNvbi5jb20iLCJmaXJzdE5hbWUiOiJNaWNoYWVsIiwibGFzdE5hbWUiOiJXaWxsaWFtcyIsImdlbmRlciI6Im1hbGUiLCJpbWFnZSI6Imh0dHBzOi8vZHVtbXlqc29uLmNvbS9pY29uL21pY2hhZWx3LzEyOCIsImlhdCI6MTcxNzYxMzQ0OSwiZXhwIjoxNzE3NjE3MDQ5fQ.iI75FqR7VRSQ0uxZUryH_7ee-TghM_hrxSFuzwJO63I';
      const expiresInMin = 30;
      final responseJson = json.decode(readJson(TokenPath()));
      final response = Response(
        data: responseJson,
        statusCode: 200,
        requestOptions:
            RequestOptions(path: TaskManagerDatasourceImpl.refreshAuthTokenUrl),
      );

      when(mockDio.post(TaskManagerDatasourceImpl.refreshAuthTokenUrl, data: {
        'refreshToken': refreshToken,
        'expiresInMin': expiresInMin
      })).thenAnswer((_) async => response);

      // Act
      final tokenDTO = await datasource.refreshAuthToken(
          refreshToken: refreshToken, expiresInMin: expiresInMin);

      // Assert
      expect(tokenDTO, isA<TokenDTO>());
      expect(tokenDTO.token, responseJson['token']);
      expect(tokenDTO.refreshToken, responseJson['refreshToken']);
    });

    test('refreshAuthToken throws an exception on failure', () async {
      // Arrange
      final refreshToken = 'testRefreshToken';
      final expiresInMin = 30;
      final errorResponse = Response(
        data: {'message': 'Invalid token'},
        statusCode: 400,
        requestOptions:
            RequestOptions(path: TaskManagerDatasourceImpl.refreshAuthTokenUrl),
      );

      when(mockDio.post(TaskManagerDatasourceImpl.refreshAuthTokenUrl, data: {
        'refreshToken': refreshToken,
        'expiresInMin': expiresInMin
      })).thenAnswer((_) async => errorResponse);

      expect(
          () async => await datasource.refreshAuthToken(
              refreshToken: refreshToken, expiresInMin: expiresInMin),
          throwsA(isA<ServerException>()));
    });
  });
}

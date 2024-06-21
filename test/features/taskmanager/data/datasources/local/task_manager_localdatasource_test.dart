import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simontaskmanager/features/taskmanager/data/datasources/local/task_manager_localdatasource.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/todolist_dto.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/user_dto.dart';

import '../../../../../jsons/JsonReader.dart';
import 'task_manager_localdatasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late TaskManagerLocalDatasourceImpl taskManagerLocalDatasource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    taskManagerLocalDatasource = TaskManagerLocalDatasourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  final tTodoList = TodoListDTO.fromJson(json.decode(readJson(TodosPaths())));

  const tToDoListDTOEmpty =
      TodoListDTO(innerTodos: [], total: 0, skip: 0, limit: 30);

  const tUserDto = UserDTO(
      id: 1,
      username: "emilys",
      email: "emily.johnson@x.dummyjson.com",
      firstName: "Emily",
      lastName: "Johnson",
      gender: "female",
      image: "https://dummyjson.com/icon/emilys/128",
      token:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidXNlcm5hbWUiOiJtaWNoYWVsdyIsImVtYWlsIjoibWljaGFlbC53aWxsaWFtc0B4LmR1bW15anNvbi5jb20iLCJmaXJzdE5hbWUiOiJNaWNoYWVsIiwibGFzdE5hbWUiOiJXaWxsaWFtcyIsImdlbmRlciI6Im1hbGUiLCJpbWFnZSI6Imh0dHBzOi8vZHVtbXlqc29uLmNvbS9pY29uL21pY2hhZWx3LzEyOCIsImlhdCI6MTcxNzYxMzQ0OSwiZXhwIjoxNzE3NjE3MDQ5fQ.iI75FqR7VRSQ0uxZUryH_7ee-TghM_hrxSFuzwJO63I",
      refreshToken:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidXNlcm5hbWUiOiJtaWNoYWVsdyIsImVtYWlsIjoibWljaGFlbC53aWxsaWFtc0B4LmR1bW15anNvbi5jb20iLCJmaXJzdE5hbWUiOiJNaWNoYWVsIiwibGFzdE5hbWUiOiJXaWxsaWFtcyIsImdlbmRlciI6Im1hbGUiLCJpbWFnZSI6Imh0dHBzOi8vZHVtbXlqc29uLmNvbS9pY29uL21pY2hhZWx3LzEyOCIsImlhdCI6MTcxNzYxMzQ0OSwiZXhwIjoxNzIwMjA1NDQ5fQ.G9zS9jdoWLjHwEr9sQM6nPaQPi0PJSCMt9oO8xTAdAY");

  group('getCacheTodos', () {
    test('should return cache todos when there is one in the storage',
        () async {
      when(mockSharedPreferences
              .getString(TaskManagerLocalDatasourceImpl.CACHE_TODOS_KEY))
          .thenReturn(readJson(TodosPaths()));

      final result = await taskManagerLocalDatasource.getCacheAllTodos();

      verify(mockSharedPreferences
          .getString(TaskManagerLocalDatasourceImpl.CACHE_TODOS_KEY));

      expect(result, tTodoList);
    });

    test('should return empty todos when there is none in the storage',
        () async {
      when(mockSharedPreferences
              .getString(TaskManagerLocalDatasourceImpl.CACHE_TODOS_KEY))
          .thenReturn(null);

      final result = await taskManagerLocalDatasource.getCacheAllTodos();

      verify(mockSharedPreferences
          .getString(TaskManagerLocalDatasourceImpl.CACHE_TODOS_KEY));

      expect(result, tToDoListDTOEmpty);
    });
  });

  group('getUserData', () {
    test('should return cache user data when there is one in the storage',
        () async {
      when(mockSharedPreferences
              .getString(TaskManagerLocalDatasourceImpl.LOGGED_IN_USER_KEY))
          .thenReturn(readJson(UserPath()));

      final result = await taskManagerLocalDatasource.getLoggedInUser();

      verify(mockSharedPreferences
          .getString(TaskManagerLocalDatasourceImpl.LOGGED_IN_USER_KEY));

      expect(result, tUserDto);
    });

    test('should return null when there is none in the storage', () async {
      when(mockSharedPreferences
              .getString(TaskManagerLocalDatasourceImpl.LOGGED_IN_USER_KEY))
          .thenReturn(null);

      final result = await taskManagerLocalDatasource.getLoggedInUser();

      verify(mockSharedPreferences
          .getString(TaskManagerLocalDatasourceImpl.LOGGED_IN_USER_KEY));

      expect(result, null);
    });
  });

  group('cacheTodos', () {
    test('should call shared preference to cache todos', () async {
      when(taskManagerLocalDatasource.cacheTodos(todos: tTodoList))
          .thenAnswer((_) => Future.value(true));

      final result =
          await taskManagerLocalDatasource.cacheTodos(todos: tTodoList);

      verify(mockSharedPreferences.setString(
          TaskManagerLocalDatasourceImpl.CACHE_TODOS_KEY, any));

      expect(result, true);
    });
  });

  group('cacheUserData', () {
    test('should call shared preference to cache user data', () async {
      when(taskManagerLocalDatasource.saveUserData(user: tUserDto))
          .thenAnswer((_) => Future.value(true));

      final result =
          await taskManagerLocalDatasource.saveUserData(user: tUserDto);

      verify(mockSharedPreferences.setString(
          TaskManagerLocalDatasourceImpl.LOGGED_IN_USER_KEY, any));

      expect(result, true);
    });
  });
}

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:simontaskmanager/features/core/error/exceptions.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/todolist_dto.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/user_dto.dart';

abstract class TaskManagerLocalDatasource {
  ///
  /// calls the local storage to return the last [TodoListDTO]
  /// that was cached the last time the user connected online
  ///
  /// throws a [LocalCacheException] for all errors
  Future<TodoListDTO> getCacheAllTodos();

  ///
  /// clears all [TodoListDTO]
  ///
  /// throws a [LocalCacheException] for all errors
  Future<bool> clearCache();

  ///
  /// cache the remote [TodoListDTO] to db
  ///
  /// throws a [LocalCacheException] for all errors
  Future<bool> cacheTodos({required TodoListDTO todos});

  ///
  /// cache the logged in user [UserDTO] to db
  ///
  /// throws a [LocalCacheException] for all errors
  Future<bool> saveUserData({required UserDTO user});

  ///
  /// gets the logged in user [UserDTO] from db
  ///
  /// throws a [LocalCacheException] for all errors
  Future<UserDTO?> getLoggedInUser();
}

class TaskManagerLocalDatasourceImpl implements TaskManagerLocalDatasource {
  final SharedPreferences sharedPreferences;

  TaskManagerLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<bool> cacheTodos({required TodoListDTO todos}) {
    sharedPreferences.setString(CACHE_TODOS_KEY, json.encode(todos.toJson()));
    return Future.value(true);
  }

  @override
  Future<TodoListDTO> getCacheAllTodos() {
    final jsonString = sharedPreferences.getString(CACHE_TODOS_KEY);
    final result = Future.value(jsonString == null
        ?  const TodoListDTO(innerTodos: [], total: 0, skip: 0, limit: 30)
        : TodoListDTO.fromJson(json.decode(jsonString)));
    return result;
  }

  @override
  Future<bool> clearCache() {
    sharedPreferences.clear();
    return Future.value(true);
  }

  @override
  Future<UserDTO?> getLoggedInUser() {
    final jsonString = sharedPreferences.getString(LOGGED_IN_USER_KEY);
    final result = Future.value(
        jsonString == null ? null : UserDTO.fromJson(json.decode(jsonString)));
    return result;
  }

  @override
  Future<bool> saveUserData({required UserDTO user}) {
    sharedPreferences.setString(LOGGED_IN_USER_KEY, json.encode(user.toJson()));
    return Future.value(true);
  }

  static const CACHE_TODOS_KEY = "CACHE_TODOS";
  static const LOGGED_IN_USER_KEY = "USER";
}

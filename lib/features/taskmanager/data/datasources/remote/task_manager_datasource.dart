import 'package:simontaskmanager/features/core/error/exceptions.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/todo_dto.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/todolist_dto.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/token_dto.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/user_dto.dart';

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

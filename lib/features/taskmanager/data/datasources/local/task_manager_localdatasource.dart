import 'package:simontaskmanager/features/core/error/exceptions.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/todolist_dto.dart';

abstract class TaskManagerLocalDatasource {
  ///
  /// calls the local storage to return the last [TodoListDTO]
  /// that was cached the last time the user connected online
  ///
  /// throws a [LocalCacheException] for all errors
  Future<TodoListDTO> getCacheAllTodos();

  ///
  /// cache the remote [TodoListDTO] to db
  ///
  /// throws a [LocalCacheException] for all errors
  Future<bool> cacheTodos({required TodoListDTO todos});
}

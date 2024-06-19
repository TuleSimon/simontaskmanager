import 'package:dartz/dartz.dart';
import 'package:simontaskmanager/features/core/error/exceptions.dart';
import 'package:simontaskmanager/features/core/error/failures.dart';
import 'package:simontaskmanager/features/core/platform/network_info.dart';
import 'package:simontaskmanager/features/taskmanager/data/datasources/local/task_manager_localdatasource.dart';
import 'package:simontaskmanager/features/taskmanager/data/datasources/remote/task_manager_datasource.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/todo_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/todolist_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/repositories/todoRepository.dart';

class TodoRepositoryImpl extends TodoRepository {
  final TaskManagerLocalDatasource localDatasource;
  final TaskManagerDatasource datasource;
  final NetworkInfo networkInfo;

  TodoRepositoryImpl(
      {required this.localDatasource,
      required this.datasource,
      required this.networkInfo});

  @override
  Future<Either<Failure, TodoListEntity>> getAllTodos(
      {required int limit, required int offset}) async {
    if (await networkInfo.isConnected) {
      try {
        final cacheTodos = await localDatasource.getCacheAllTodos();
        if (cacheTodos.todos.isEmpty) {
          final response =
              await datasource.getAllTodos(limit: limit, offset: offset);
          await localDatasource.cacheTodos(todos: response);
          return Right(response);
        } else {
          return Right(cacheTodos);
        }
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      final cacheTodos = await localDatasource.getCacheAllTodos();
      if (cacheTodos.todos.isEmpty) {
        return Left(NetworkFailure());
      }
      return Right(cacheTodos);
    }
  }

  @override
  Future<Either<Failure, TodoEntity>> addTodos(
      {required String todo,
      required int userid,
      required bool isCompleted}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await datasource.addTodos(todo: todo, userid: userid, isCompleted: isCompleted) ;
          return Right(response);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
     return Left(NetworkFailure());
    }
  }
}

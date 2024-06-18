import 'package:dartz/dartz.dart';
import 'package:simontaskmanager/features/core/error/failures.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/todo_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/todolist_entity.dart';

abstract class TodoRepository{
  ///
  /// This functions is used to get all todos,
  /// it returns a future with an `Either` which left is a failure,
  /// if requests fails, left returns a [Failures]
  /// if requests success, right returns a [TodoListEntity]
  ///
  Future<Either<Failures, TodoListEntity>> getAllTodos({required int limit, required int offset});

  ///
  /// This functions is used to add a new todos,
  /// it returns a future with an `Either` which left is a failure and right data from successful requests,
  /// if requests fails, left returns a [Failures]
  /// if requests success, right returns a [TodoEntity]
  ///
  Future<Either<Failures, TodoEntity>> addTodos({required String todo,required bool isCompleted});
}
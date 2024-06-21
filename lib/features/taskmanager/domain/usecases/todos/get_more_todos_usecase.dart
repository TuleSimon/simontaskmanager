import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:simontaskmanager/features/core/error/failures.dart';
import 'package:simontaskmanager/features/core/usecases/usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/todolist_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/repositories/todoRepository.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/todos/get_all_todos_usecase.dart';

class GetMoreTodosUsecase
    implements Usecase<TodoListEntity, GetAllTodosParams> {
  final TodoRepository todosRepository;

  GetMoreTodosUsecase({required this.todosRepository});

  @override
  Future<Either<Failure, TodoListEntity>> call(
      {required GetAllTodosParams params}) async {
    return await todosRepository.getMoreTodos(
        limit: params.limit, offset: params.offset);
  }
}

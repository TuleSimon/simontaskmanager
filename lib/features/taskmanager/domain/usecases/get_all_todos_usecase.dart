import 'package:dartz/dartz.dart';
import 'package:simontaskmanager/features/core/error/failures.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/todolist_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/repositories/todoRepository.dart';

class GetAllTodosUseCase {
  final TodoRepository todosRepository;
  GetAllTodosUseCase({required this.todosRepository});

  Future<Either<Failures, TodoListEntity>> execute({required int limit, required int offset}) async {
    return await todosRepository.getAllTodos(limit: limit, offset: offset);
  }
}

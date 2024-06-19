import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:simontaskmanager/features/core/error/failures.dart';
import 'package:simontaskmanager/features/core/usecases/usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/todolist_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/repositories/todoRepository.dart';

class GetAllTodosParams extends Equatable {
  final int limit;
  final int offset;

  GetAllTodosParams({
    required this.limit,
    required this.offset,
  });

  @override
  List<Object?> get props => [limit, offset];
}


class GetAllTodosUseCase implements Usecase<TodoListEntity,GetAllTodosParams>{
  final TodoRepository todosRepository;
  GetAllTodosUseCase({required this.todosRepository});


  @override
  Future<Either<Failure, TodoListEntity>> call({required GetAllTodosParams params}) async {
    return await todosRepository.getAllTodos(limit: params.limit, offset: params.offset);
  }
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:simontaskmanager/features/core/error/failures.dart';
import 'package:simontaskmanager/features/core/usecases/usecase.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/todolist_dto.dart';
import 'package:simontaskmanager/features/taskmanager/domain/repositories/todoRepository.dart';

class SaveTodosParams extends Equatable {
  final TodoListDTO todos;

  const SaveTodosParams({
    required this.todos,
  });

  @override
  List<Object?> get props => [todos];
}

class SaveTodosUsecase implements Usecase<bool, SaveTodosParams> {
  final TodoRepository todosRepository;

  SaveTodosUsecase({required this.todosRepository});

  @override
  Future<Either<Failure, bool>> call({required SaveTodosParams params}) async {
    return await todosRepository.saveTodos(todos: params.todos);
  }
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:simontaskmanager/features/core/error/failures.dart';
import 'package:simontaskmanager/features/core/usecases/usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/todo_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/repositories/todoRepository.dart';

class AddNewTodoParams extends Equatable {
  final String todo;
  final int userid;
  final bool isCompleted;

  const AddNewTodoParams({
    required this.todo,
    required this.userid,
    required this.isCompleted
  });

  @override
  List<Object?> get props => [todo, userid];
}


class AddNewTodoUsecase implements Usecase<TodoEntity,AddNewTodoParams>{
  final TodoRepository todosRepository;
  AddNewTodoUsecase({required this.todosRepository});


  @override
  Future<Either<Failure, TodoEntity>> call({required AddNewTodoParams params}) async {
    return await todosRepository.addTodos(todo: params.todo, userid: params.userid, isCompleted: params.isCompleted);
  }
}

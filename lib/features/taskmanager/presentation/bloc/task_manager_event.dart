part of 'task_manager_bloc.dart';

sealed class TaskManagerEvent extends Equatable {
  const TaskManagerEvent();
}

class TaskManagerGetTodos extends TaskManagerEvent {
  @override
  List<Object?> get props => [];
}

class TaskManagerInitial extends TaskManagerEvent {
  @override
  List<Object?> get props => [];
}

class TaskManagerAddTodo extends TaskManagerEvent {
  final String todo;

  const TaskManagerAddTodo({required this.todo});

  @override
  List<Object?> get props => [todo];
}

class TaskManagerRefreshTodo extends TaskManagerEvent {
  @override
  List<Object?> get props => [];
}

class TaskManagerDeleteTodo extends TaskManagerEvent {
  final int todoId;

  const TaskManagerDeleteTodo({required this.todoId});
  @override
  List<Object?> get props => [todoId];
}

class TaskManagerGetTodo extends TaskManagerEvent {
  final int todoId;

  const TaskManagerGetTodo({required this.todoId});
  @override
  List<Object?> get props => [todoId];
}

class TaskManagerClearStates extends TaskManagerEvent {
  const TaskManagerClearStates();
  @override
  List<Object?> get props => [];
}


class TaskManagerEditTodo extends TaskManagerEvent {
  final String todo;
  final bool isCompleted;
  final int todoId;

  const TaskManagerEditTodo(
      {required this.todo, required this.isCompleted, required this.todoId});

  @override
  List<Object?> get props => [todo,isCompleted,todoId];
}

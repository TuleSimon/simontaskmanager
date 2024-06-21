part of 'task_manager_bloc.dart';

abstract class TaskManagerState extends Equatable {
  const TaskManagerState();

  @override
  List<Object> get props => [];
}

class TaskManagerStateInitial extends TaskManagerState {}

class TaskManagerStateLoading extends TaskManagerState {}

class TaskManagerStateAdding extends TaskManagerState {}

class TaskManagerStateLoaded extends TaskManagerState {
  final List<TodoEntity> todos;
  final int limit;
  final int skip;
  final bool addingTodo;
  final bool addedTodo;
  final String error;
  final int total;
  final UserEntity user;

  const TaskManagerStateLoaded({
    required this.todos,
    required this.limit,
    required this.skip,
    required this.addingTodo,
     required this.error,
    required this.addedTodo,
    required this.total,
    required this.user,
  });

  @override
  List<Object> get props => [todos, limit, skip, total, user,addingTodo,addedTodo,error];

  TaskManagerStateLoaded copyWith({
    List<TodoEntity>? todos,
    int? limit,
    String? error,
    int? skip,
    bool? addingTodo,
    bool? addedTodo,
    int? total,
    UserEntity? user,
  }) {
    return TaskManagerStateLoaded(
      todos: todos ?? this.todos,
      limit: limit ?? this.limit,
      skip: skip ?? this.skip,
      error: error ?? this.error,
      addedTodo: addedTodo ?? this.addedTodo,
      addingTodo: addingTodo ?? this.addingTodo,
      total: total ?? this.total,
      user: user ?? this.user,
    );
  }
}

class TaskManagerStateError extends TaskManagerState {
  final String message;

  const TaskManagerStateError(this.message);

  @override
  List<Object> get props => [message];
}

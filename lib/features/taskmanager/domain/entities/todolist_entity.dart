import 'package:equatable/equatable.dart';
import 'todo_entity.dart';

class TodoListEntity extends Equatable {
  final List<TodoEntity> todos;
  final int total;
  final int skip;
  final int limit;

  const TodoListEntity({
    required this.todos,
    required this.total,
    required this.skip,
    required this.limit,
  });

  @override
  List<Object> get props => [todos, total, skip, limit];

  TodoListEntity copyWith({
    List<TodoEntity>? todos,
    int? total,
    int? skip,
    int? limit,
  }) {
    return TodoListEntity(
      todos: todos ?? this.todos,
      total: total ?? this.total,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
    );
  }

  @override
  String toString() {
    return 'TodoListEntity{todos: $todos, total: $total, skip: $skip, limit: $limit}';
  }
}

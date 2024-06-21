

import 'package:equatable/equatable.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/todo_dto.dart';

class TodoEntity extends Equatable {
  final int id;
  final String todo;
  final bool completed;
  final int userId;

  const TodoEntity({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  @override
  List<Object> get props => [id, todo, completed, userId];

  TodoEntity copyWith({
    int? id,
    String? todo,
    bool? completed,
    int? userId,
  }) {
    return TodoEntity(
      id: id ?? this.id,
      todo: todo ?? this.todo,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() {
    return 'TodoEntity{id: $id, todo: $todo, completed: $completed, userId: $userId}';
  }

  TodoDTO toDTO() {
    return TodoDTO(
      id: id,
      todo: todo,
      completed: completed,
      userId: userId,
    );
  }
}

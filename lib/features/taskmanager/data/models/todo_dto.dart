import 'package:simontaskmanager/features/taskmanager/domain/entities/todo_entity.dart';

class TodoDTO extends TodoEntity {
  const TodoDTO({
    required super.id,
    required super.todo,
    required super.completed,
    required super.userId,
  });

  factory TodoDTO.fromJson(Map<String, dynamic> json) {
    return TodoDTO(
      id: json['id'],
      todo: json['todo'],
      completed: json['completed'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todo': todo,
      'completed': completed,
      'userId': userId,
    };
  }
}

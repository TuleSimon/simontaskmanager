import 'package:simontaskmanager/features/taskmanager/domain/entities/todo_entity.dart';

class TodoDTO {
  final int id;
  final String todo;
  final bool completed;
  final int userId;

  TodoDTO({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
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

  TodoEntity toEntity() {
    return TodoEntity(
      id: id,
      todo: todo,
      completed: completed,
      userId: userId,
    );
  }
}

import 'package:simontaskmanager/features/taskmanager/domain/entities/todolist_entity.dart';

import 'todo_dto.dart';

class TodoListDTO {
  final List<TodoDTO> todos;
  final int total;
  final int skip;
  final int limit;

  TodoListDTO({
    required this.todos,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory TodoListDTO.fromJson(Map<String, dynamic> json) {
    return TodoListDTO(
      todos: (json['todos'] as List).map((item) => TodoDTO.fromJson(item)).toList(),
      total: json['total'],
      skip: json['skip'],
      limit: json['limit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todos': todos.map((todo) => todo.toJson()).toList(),
      'total': total,
      'skip': skip,
      'limit': limit,
    };
  }

  TodoListEntity toEntity() {
    return TodoListEntity(
      todos: todos.map((todo) => todo.toEntity()).toList(),
      total: total,
      skip: skip,
      limit: limit,
    );
  }
}

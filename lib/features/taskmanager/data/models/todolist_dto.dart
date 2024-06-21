import 'package:simontaskmanager/features/taskmanager/domain/entities/todolist_entity.dart';

import 'todo_dto.dart';

class TodoListDTO extends TodoListEntity {
  @override
  final List<TodoDTO> innerTodos;

  const TodoListDTO({
    required this.innerTodos,
    required super.total,
    required super.skip,
    required super.limit,
  }) : super(todos: innerTodos);

  factory TodoListDTO.fromJson(Map<String, dynamic> json) {
    return TodoListDTO(
      innerTodos: (json['todos'] as List)
          .map((item) => TodoDTO.fromJson(item))
          .toList(),
      total: json['total'],
      skip: json['skip'],
      limit: json['limit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todos': innerTodos.map((e) => (e).toJson()).toList(),
      'total': total,
      'skip': skip,
      'limit': limit
    };
  }
}

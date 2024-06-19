import 'package:simontaskmanager/features/taskmanager/domain/entities/todolist_entity.dart';

import 'todo_dto.dart';

class TodoListDTO extends TodoListEntity {

  const TodoListDTO({
    required super.todos,
    required super.total,
    required super.skip,
    required super.limit,
  }) ;

  factory TodoListDTO.fromJson(Map<String, dynamic> json) {
    return TodoListDTO(
      todos: (json['todos'] as List)
          .map((item) => TodoDTO.fromJson(item))
          .toList(),
      total: json['total'],
      skip: json['skip'],
      limit: json['limit'],
    );
  }

}

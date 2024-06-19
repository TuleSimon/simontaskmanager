import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/todo_dto.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/todo_entity.dart';
import '../../../../jsons/JsonReader.dart';

void main() {
  const tTodo =
    TodoDTO(
        id: 1,
        todo: "Do something nice for someone I care about",
        completed: true,
        userId: 26);

  test('should be a subclass of TodoEntity', () {
    expect(tTodo, isA<TodoEntity>());
  });

  group('fromJson', () {
    test('should return a valid todo dto when given json', () {
      final Map<String, dynamic> jsonMap = json.decode(readJson(TodoPaths()));
      final TodoDTO todoDTO = TodoDTO.fromJson(jsonMap);
      expect(todoDTO, tTodo);
    });

    test('should return a valid todoEntity when given json', () {
      final Map<String, dynamic> jsonMap = json.decode(readJson(TodoPaths()));
      final TodoDTO todoDTO = TodoDTO.fromJson(jsonMap);
      expect(todoDTO, todoDTO);
      final todoEntity = todoDTO;
      expect(todoEntity, tTodo);
    });
  });

  group('toJson', () {
    test('should return a valid json when converting a dto', () {
      final Map<String, dynamic> jsonMap = json.decode(readJson(TodoPaths()));
      final convertedJson = tTodo.toJson();
      expect(convertedJson, jsonMap);
    });
  });
}

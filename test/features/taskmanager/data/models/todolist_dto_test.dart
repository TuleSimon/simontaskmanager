import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/todo_dto.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/todolist_dto.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/todolist_entity.dart';
import '../../../../jsons/JsonReader.dart';

void main() {
  const tToDoListDTO = TodoListDTO(innerTodos: [
    TodoDTO(
        id: 1,
        todo: "Do something nice for someone I care about",
        completed: true,
        userId: 26)
  ], total: 10, skip: 0, limit: 30);

  test('should be a subclass of TodolistEntity', () {
    expect(tToDoListDTO, isA<TodoListEntity>());
  });

  group('fromJson', () {
    test('should return a valid todos dto when given json', () {
      final Map<String, dynamic> jsonMap = json.decode(readJson(TodosPaths()));
      final TodoListDTO todoListDTO = TodoListDTO.fromJson(jsonMap);
      expect(todoListDTO, tToDoListDTO);
    });

    test('should return a valid todosEntity when given json', () {
      final Map<String, dynamic> jsonMap = json.decode(readJson(TodosPaths()));
      final TodoListDTO todoListDTO = TodoListDTO.fromJson(jsonMap);
      expect(todoListDTO, tToDoListDTO);
      final todoListEntity = todoListDTO;
      expect(todoListEntity, tToDoListDTO);
    });
  });

  group('toJson', () {
    test('should return a valid json when converting a dto', () {
      final Map<String, dynamic> jsonMap = json.decode(readJson(TodosPaths()));
      final convertedJson = tToDoListDTO.toJson();
      expect(convertedJson, jsonMap);
    });
  });
}

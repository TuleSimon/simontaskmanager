import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/todolist_dto.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/todos/get_all_todos_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/todos/get_more_todos_usecase.dart';

import '../../../../../jsons/JsonReader.dart';
import 'get_all_todos_test.mocks.dart';

void main() {
  late GetMoreTodosUsecase usecase;
  late MockTodoRepository mockTodoRepository;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    usecase = GetMoreTodosUsecase(todosRepository: mockTodoRepository);
  });

  final tTodoJson = json.decode(readJson(TodosPaths()));
  final tTodoList = TodoListDTO.fromJson(tTodoJson);

  final skip = tTodoList.skip;
  final limit = tTodoList.limit;

  test('should return correct todoList from the repository', () async {
    final newSKip = skip + tTodoList.limit;
    // Arrange
    when(mockTodoRepository.getMoreTodos(limit: limit, offset: newSKip))
        .thenAnswer((_) async =>
            Right(tTodoList.copyWith(skip: skip + tTodoList.limit)));

    // Act
    final result =
        await usecase(params: GetAllTodosParams(limit: limit, offset: newSKip));
    final apinewSkip = result.fold((l) => null, (data) => data.skip);

    // Assert
    expect(apinewSkip, newSKip);
    verify(mockTodoRepository.getMoreTodos(
        limit: limit, offset: skip + tTodoList.limit));
    verifyNoMoreInteractions(mockTodoRepository);
  });
}

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/todo_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/todos/add_new_todo_usecase.dart';

import 'get_all_todos_test.mocks.dart';


void main() {
  late AddNewTodoUsecase usecase;
  late MockTodoRepository mockTodoRepository;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    usecase = AddNewTodoUsecase(todosRepository: mockTodoRepository);
  });

  const tNewTodo =
  TodoEntity(id: 1, todo: "This is an example", completed: false, userId: 2);


  test('should return correct todoEntity from the repository', () async {
    // Arrange
    when(mockTodoRepository.addTodos(
        todo: tNewTodo.todo,
        isCompleted: tNewTodo.completed,
        userid: tNewTodo.userId))
        .thenAnswer((_) async => const Right(tNewTodo));

    // Act
    final result = await usecase(
        params: AddNewTodoParams(todo: tNewTodo.todo,
            isCompleted: tNewTodo.completed,
            userid: tNewTodo.userId));

    // Assert
    expect(result, const Right(tNewTodo));
    verify(mockTodoRepository.addTodos(userid: tNewTodo.userId,
        isCompleted: tNewTodo.completed,
        todo: tNewTodo.todo));
    verifyNoMoreInteractions(mockTodoRepository);
  });
}

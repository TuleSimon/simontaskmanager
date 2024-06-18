import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/todo_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/todolist_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/repositories/todoRepository.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/get_all_todos_usecase.dart';

// Annotation which generates the cat.mocks.dart library and the MockCat class.
@GenerateNiceMocks([MockSpec<TodoRepository>()])
import 'get_all_todos_test.mocks.dart';

void main() {
  late GetAllTodosUseCase usecase;
  late MockTodoRepository mockTodoRepository;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    usecase = GetAllTodosUseCase(todosRepository: mockTodoRepository);
  });

  final tTodoList = [
    const TodoEntity(id: 1, todo: "This is an example", completed: false, userId: 2),
    const TodoEntity(id: 2, todo: "This is an example2", completed: true, userId: 2),
    const TodoEntity(id: 3, todo: "This is an example3", completed: false, userId: 2),
    const TodoEntity(id: 4, todo: "This is an example4", completed: true, userId: 2),
  ];

  const skip = 0;
  const limit = 10;

  final tTodoListEntity = TodoListEntity(
    todos: tTodoList,
    total: tTodoList.length,
    skip: skip,
    limit: limit,
  );

  test('should return correct todoList from the repository', () async {
    // Arrange
    when(mockTodoRepository.getAllTodos(limit: limit, offset: skip))
        .thenAnswer((_) async => Right(tTodoListEntity));

    // Act
    final result = await usecase.execute(limit: limit, offset: skip);

    // Assert
    expect(result, Right(tTodoListEntity));
    verify(mockTodoRepository.getAllTodos(limit: limit, offset: skip));
    verifyNoMoreInteractions(mockTodoRepository);
  });
}

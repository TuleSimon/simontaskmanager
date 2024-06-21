import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:simontaskmanager/features/core/error/failures.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/todolist_dto.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/user_dto.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/todo_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/auth/get_logged_in_user_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/todos/add_new_todo_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/todos/get_all_todos_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/todos/get_more_todos_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/todos/save_todos_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/presentation/bloc/task_manager_bloc.dart';
import 'package:simontaskmanager/features/taskmanager/utils/validators/todo_validator.dart';

import '../../../../jsons/JsonReader.dart';
import 'auth_bloc_test.mocks.dart';
import 'task_manager_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetAllTodosUseCase>(),
  MockSpec<GetLoggedInUserUsecase>(),
  MockSpec<AddNewTodoUsecase>(),
  MockSpec<GetMoreTodosUsecase>(),
  MockSpec<SaveTodosUsecase>(),
  MockSpec<TodoValidator>(),
])
void main() {
  late TaskManagerBloc taskManagerBloc;
  late MockGetAllTodosUseCase mockGetAllTodosUseCase;
  late MockAddNewTodoUsecase mockAddNewTodoUsecase;
  late MockGetLoggedInUserUsecase mockGetLoggedInUserUsecase;
  late MockGetMoreTodosUsecase mockGetMoreTodosUsecase;
  late MockSaveTodosUsecase mockSaveTodosUsecase;
  late MockTodoValidator mockTodoValidator;

  setUp(() {
    mockGetAllTodosUseCase = MockGetAllTodosUseCase();
    mockAddNewTodoUsecase = MockAddNewTodoUsecase();
    mockGetLoggedInUserUsecase = MockGetLoggedInUserUsecase();
    mockGetMoreTodosUsecase = MockGetMoreTodosUsecase();
    mockSaveTodosUsecase = MockSaveTodosUsecase();
    mockTodoValidator = MockTodoValidator();
    taskManagerBloc = TaskManagerBloc(
      mockGetAllTodosUseCase,
      mockAddNewTodoUsecase,
      mockGetLoggedInUserUsecase,
      mockSaveTodosUsecase,
      mockGetMoreTodosUsecase,
      mockTodoValidator,
    );
  });

  final user = UserDTO.fromJson(json.decode(readJson(UserPath())));
  final todos = TodoListDTO.fromJson(json.decode(readJson(TodosPaths())));

  test('Initial State should be TaskManagerStateInitial', () {
    expect(taskManagerBloc.state, TaskManagerStateInitial());
  });

  group('Load Todos', () {
    test(
        'emits [TaskManagerStateLoading, TaskManagerStateLoaded] when LoadTodos is added and successful',
            () async {
          when(mockGetAllTodosUseCase(params: anyNamed('params')))
              .thenAnswer((_) async => Right(todos));
          when(mockGetLoggedInUserUsecase(params: anyNamed('params')))
              .thenAnswer((_) async => Right(user));

          taskManagerBloc.add(TaskManagerInitial());

          await expectLater(
            taskManagerBloc.stream,
            emitsInOrder([
              TaskManagerStateLoading(),
              TaskManagerStateLoaded(
                todos: todos.todos,
                limit: todos.limit,
                skip: todos.skip,
                total: todos.total,
                user: user,
                addedTodo: false,
                error: "",
                addingTodo: false,
              ),
            ]),
          );
        });

    test(
        'emits [TaskManagerStateLoading, TaskManagerStateError] when LoadTodos fails',
            () async {
          when(mockGetAllTodosUseCase(params: anyNamed('params')))
              .thenAnswer((_) async => Left(NetworkFailure()));

          taskManagerBloc.add(TaskManagerInitial());

          await expectLater(
            taskManagerBloc.stream,
            emitsInOrder([
              TaskManagerStateLoading(),
              const TaskManagerStateError(NETWORK_ERROR),
            ]),
          );
        });
  });

  group('Add Todo', () {
    const newTodo = TodoEntity(
        userId: 2, todo: 'Todo 2', completed: true, id: 13);

    test(
        'emits [TaskManagerStateAdding, TaskManagerStateLoaded] when AddTodo is added and successful',
            () async {
          when(mockAddNewTodoUsecase(params: anyNamed('params')))
              .thenAnswer((_) async => const Right(newTodo));
          when(mockSaveTodosUsecase(params: anyNamed('params')))
              .thenAnswer((_) async => const Right(true));
          final newId = DateTime.now().millisecond;

          taskManagerBloc.emit(TaskManagerStateLoaded(
            todos: todos.todos,
            limit: todos.limit,
            skip: todos.skip,
            total: todos.total,
            error: "",
            addedTodo: false,
            user: user.copyWith(refreshToken: "", token: ""),
            addingTodo: false,
          ));

          taskManagerBloc.add(TaskManagerAddTodo(
            todo: newTodo.todo,id:newId
          ));

          await expectLater(
            taskManagerBloc.stream,
            emitsInOrder([
              TaskManagerStateLoaded(
                  todos: todos.todos,
                  limit: todos.limit,
                  skip: todos.skip,
                  total: todos.total,
                  user: user.copyWith(refreshToken: "", token: ""),
                  addingTodo: true,
                  error: "",
                  addedTodo: false),
              TaskManagerStateLoaded(
                  todos: [ newTodo.copyWith(id:newId),...todos.todos,],
                  limit: todos.limit,
                  skip: todos.skip,
                  total: todos.total + 1,
                  user: user.copyWith(refreshToken: "", token: ""),
                  addingTodo: false,
                  error: "",
                  addedTodo: true),
            ]),
          );
        });

    test(
        'emits [TaskManagerStateLoaded with error] when AddTodo has invalid name',
            () async {
          when(mockAddNewTodoUsecase(params: anyNamed('params')))
              .thenAnswer((_) async => const Right(newTodo));
          when(mockSaveTodosUsecase(params: anyNamed('params')))
              .thenAnswer((_) async => const Right(true));
          when(mockTodoValidator.validateTodoText(any))
              .thenReturn(const InputFailure("Todo text cannot be empty"));

          taskManagerBloc.emit(TaskManagerStateLoaded(
            todos: todos.todos,
            limit: todos.limit,
            skip: todos.skip,
            total: todos.total,
            error: "",
            addedTodo: false,
            user: user.copyWith(refreshToken: "", token: ""),
            addingTodo: false,
          ));

          taskManagerBloc.add(const TaskManagerAddTodo(
            todo: "",
          ));

          await expectLater(
            taskManagerBloc.stream,
            emitsInOrder([
              TaskManagerStateLoaded(
                  todos: todos.todos,
                  limit: todos.limit,
                  skip: todos.skip,
                  total: todos.total,
                  user: user.copyWith(refreshToken: "", token: ""),
                  addingTodo: false,
                  error: "Todo text cannot be empty",
                  addedTodo: false),
            ]),
          );
        });
  });

  group('Delete Todo', () {
    const deletedTodoId = 1;

    test(
        'emits updated TaskManagerStateLoaded when DeleteTodo is added and successful',
            () async {
          when(mockSaveTodosUsecase(params: anyNamed('params')))
              .thenAnswer((_) async => const Right(true));

          final currentTodos = [...todos.todos];
          taskManagerBloc.emit(TaskManagerStateLoaded(
            todos: currentTodos,
            limit: todos.limit,
            skip: todos.skip,
            total: todos.total,
            error: "",
            addedTodo: false,
            user: user.copyWith(refreshToken: "", token: ""),
            addingTodo: false,
          ));

          taskManagerBloc.add(const TaskManagerDeleteTodo(
            todoId: deletedTodoId,
          ));

          final expectedTodos = currentTodos.where((todo) => todo.id != deletedTodoId).toList();
          await expectLater(
            taskManagerBloc.stream,
            emitsInOrder([
              TaskManagerStateLoaded(
                  todos: expectedTodos,
                  limit: todos.limit,
                  skip: todos.skip,
                  total: todos.total - 1,
                  user: user.copyWith(refreshToken: "", token: ""),
                  addingTodo: false,
                  error: "",
                  addedTodo: false),
            ]),
          );
        });
  });

  group('Edit Todo', () {
    const editedTodo = TodoEntity(
        userId: 2, todo: 'Edited Todo 2', completed: true, id: 1);

    test(
        'emits updated TaskManagerStateLoaded when EditTodo is added and successful',
            () async {
          when(mockSaveTodosUsecase(params: anyNamed('params')))
              .thenAnswer((_) async => const Right(true));

          final currentTodos = [...todos.todos];
          taskManagerBloc.emit(TaskManagerStateLoaded(
            todos: currentTodos,
            limit: todos.limit,
            skip: todos.skip,
            total: todos.total,
            error: "",
            addedTodo: false,
            user: user.copyWith(refreshToken: "", token: ""),
            addingTodo: false,
          ));

          taskManagerBloc.add(TaskManagerEditTodo(
            todoId: editedTodo.id,
            todo: editedTodo.todo,
            isCompleted: editedTodo.completed,
          ));

          final expectedTodos = currentTodos.map((todo) =>
          todo.copyWith(todo: editedTodo.todo,completed: editedTodo.completed)
          ).toList();
          await expectLater(
            taskManagerBloc.stream,
            emitsInOrder([
              TaskManagerStateLoaded(
                  todos: expectedTodos,
                  limit: todos.limit,
                  skip: todos.skip,
                  total: todos.total,
                  user: user.copyWith(refreshToken: "", token: ""),
                  addingTodo: false,
                  error: "",
                  addedTodo: false),
            ]),
          );
        });
  });

  group('Load More Todos', () {
    final moreTodos = TodoListDTO.fromJson(json.decode(readJson(TodosPaths())));

    test(
        'emits updated TaskManagerStateLoaded when LoadMoreTodos is added and successful',
            () async {
          when(mockGetMoreTodosUsecase(params: anyNamed('params')))
              .thenAnswer((_) async => Right(moreTodos.copyWith(skip: 30)));
          when(mockSaveTodosUsecase(params: anyNamed('params')))
              .thenAnswer((_) async => const Right(true));

          final currentTodos = [...todos.todos];
          taskManagerBloc.emit(TaskManagerStateLoaded(
            todos: currentTodos,
            limit: todos.limit,
            skip: todos.skip,
            total: todos.total,
            error: "",
            addedTodo: false,
            user: user.copyWith(refreshToken: "", token: ""),
            addingTodo: false,
          ));

          taskManagerBloc.add(TaskManagerGetTodos());

          final expectedTodos = [...currentTodos, ...moreTodos.todos];
          await expectLater(
            taskManagerBloc.stream,
            emitsInOrder([
              TaskManagerStateLoaded(
                  todos: expectedTodos,
                  limit: moreTodos.limit,
                  skip: todos.skip+todos.limit,
                  total: todos.total ,
                  user: user.copyWith(refreshToken: "", token: ""),
                  addingTodo: false,
                  error: "",
                  addedTodo: false),
            ]),
          );
        });
  });
}

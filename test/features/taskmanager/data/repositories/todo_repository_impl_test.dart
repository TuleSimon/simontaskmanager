import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simontaskmanager/features/core/error/exceptions.dart';
import 'package:simontaskmanager/features/core/error/failures.dart';
import 'package:simontaskmanager/features/core/network/network_info.dart';
import 'package:simontaskmanager/features/taskmanager/data/datasources/local/task_manager_localdatasource.dart';
import 'package:simontaskmanager/features/taskmanager/data/datasources/remote/task_manager_datasource.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/todo_dto.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/todolist_dto.dart';
import 'package:simontaskmanager/features/taskmanager/data/repositories/todo_repository_impl.dart';

import 'todo_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<TaskManagerDatasource>(),
  MockSpec<TaskManagerLocalDatasource>(),
  MockSpec<NetworkInfo>(),
])
void main() {
  late MockTaskManagerDatasource mockDataSource;
  late MockTaskManagerLocalDatasource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late TodoRepositoryImpl todoRepositoryImpl;

  setUp(() {
    mockDataSource = MockTaskManagerDatasource();
    mockLocalDataSource = MockTaskManagerLocalDatasource();
    mockNetworkInfo = MockNetworkInfo();
    todoRepositoryImpl = TodoRepositoryImpl(
      datasource: mockDataSource,
      localDatasource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tLimit = 10;
  const tOffset = 0;

  const tTodo = TodoDTO(
      id: 1,
      todo: "Do something nice for someone I care about",
      completed: true,
      userId: 26);

  const tToDoListDTO =
      TodoListDTO(innerTodos: [tTodo], total: 10, skip: 0, limit: 30);

  const tToDoListDTOEmpty =
      TodoListDTO(innerTodos: [], total: 10, skip: 0, limit: 30);

  group('getAllTodos', () {
    test('should check if device is online', () {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockDataSource.getAllTodos(limit: tLimit, offset: tOffset))
          .thenAnswer((_) async => tToDoListDTO);
      when(mockLocalDataSource.getCacheAllTodos())
          .thenAnswer((_) async => tToDoListDTO);
      todoRepositoryImpl.getAllTodos(limit: tLimit, offset: tOffset);
      verify(mockNetworkInfo.isConnected).called(1);
    });
  });

  group('device is online', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockDataSource.getAllTodos(limit: tLimit, offset: tOffset))
          .thenAnswer((_) async => tToDoListDTO);
      when(mockLocalDataSource.getCacheAllTodos())
          .thenAnswer((_) async => tToDoListDTO);
    });

    test('should return remote data when device is online and no cache data',
        () async {
      when(mockLocalDataSource.getCacheAllTodos())
          .thenAnswer((_) async => tToDoListDTOEmpty);
      final result =
          await todoRepositoryImpl.getAllTodos(limit: tLimit, offset: tOffset);
      verify(mockDataSource.getAllTodos(limit: tLimit, offset: tOffset))
          .called(1);
      expect(result, const Right(tToDoListDTO));
    });

    test('should return cache data when device is online and has cache data',
        () async {
      final result =
          await todoRepositoryImpl.getAllTodos(limit: tLimit, offset: tOffset);
      verifyZeroInteractions(mockDataSource);
      verify(mockLocalDataSource.getCacheAllTodos()).called(1);
      expect(result, const Right(tToDoListDTO));
    });

    test(
        'should cache the data locally when device is online and no cache data',
        () async {
      when(mockLocalDataSource.getCacheAllTodos())
          .thenAnswer((_) async => tToDoListDTOEmpty);
      final result =
          await todoRepositoryImpl.getAllTodos(limit: tLimit, offset: tOffset);
      verify(mockDataSource.getAllTodos(limit: tLimit, offset: tOffset))
          .called(1);
      verify(mockLocalDataSource.cacheTodos(todos: tToDoListDTO)).called(1);
      expect(result, const Right(tToDoListDTO));
    });

    test('should return server failure when call to remote datasource fails',
        () async {
      when(mockLocalDataSource.getCacheAllTodos())
          .thenAnswer((_) async => tToDoListDTOEmpty);
      when(mockDataSource.getAllTodos(limit: tLimit, offset: tOffset))
          .thenThrow(ServerException(message: ''));
      final result =
          await todoRepositoryImpl.getAllTodos(limit: tLimit, offset: tOffset);
      verify(mockDataSource.getAllTodos(limit: tLimit, offset: tOffset))
          .called(1);
      verifyNever(mockLocalDataSource.cacheTodos(todos: tToDoListDTO));
      expect(result, Left(ServerFailure()));
    });

    test(
        'should return correct dto when the device is online and try to add a todo',
        () async {
      when(mockDataSource.addTodos(
        todo: tTodo.todo,
        userid: tTodo.userId,
        isCompleted: tTodo.completed,
      )).thenAnswer((_) async => tTodo);
      final result = await todoRepositoryImpl.addTodos(
        todo: tTodo.todo,
        userid: tTodo.userId,
        isCompleted: tTodo.completed,
      );
      verify(mockDataSource.addTodos(
        todo: tTodo.todo,
        userid: tTodo.userId,
        isCompleted: tTodo.completed,
      )).called(1);
      expect(result, const Right(tTodo));
    });

    test(
        'should return server failure when the device is online and error occurs',
        () async {
      when(mockDataSource.addTodos(
        todo: tTodo.todo,
        userid: tTodo.userId,
        isCompleted: tTodo.completed,
      )).thenThrow(ServerException(message: ''));
      final result = await todoRepositoryImpl.addTodos(
        todo: tTodo.todo,
        userid: tTodo.userId,
        isCompleted: tTodo.completed,
      );
      verify(mockDataSource.addTodos(
        todo: tTodo.todo,
        userid: tTodo.userId,
        isCompleted: tTodo.completed,
      )).called(1);
      expect(result, Left(ServerFailure()));
    });
  });

  group('device is offline', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.getCacheAllTodos())
          .thenAnswer((_) async => tToDoListDTO);
    });

    test('should return last locally cache data when the cache data is present',
        () async {
      final result =
          await todoRepositoryImpl.getAllTodos(limit: tLimit, offset: tOffset);
      verify(mockLocalDataSource.getCacheAllTodos()).called(1);
      verifyZeroInteractions(mockDataSource);
      expect(result, const Right(tToDoListDTO));
    });

    test(
        'should return network failure when the cache data is not present and not online',
        () async {
      when(mockLocalDataSource.getCacheAllTodos())
          .thenAnswer((_) async => tToDoListDTOEmpty);
      final result =
          await todoRepositoryImpl.getAllTodos(limit: tLimit, offset: tOffset);
      verify(mockLocalDataSource.getCacheAllTodos()).called(1);
      verifyZeroInteractions(mockDataSource);
      expect(result, Left(NetworkFailure()));
    });

    test(
        'should return network failure when the device is offline and try to add a todo',
        () async {
      final result = await todoRepositoryImpl.addTodos(
        todo: tTodo.todo,
        userid: tTodo.userId,
        isCompleted: tTodo.completed,
      );
      verifyZeroInteractions(mockDataSource);
      expect(result, Left(NetworkFailure()));
    });
  });
}

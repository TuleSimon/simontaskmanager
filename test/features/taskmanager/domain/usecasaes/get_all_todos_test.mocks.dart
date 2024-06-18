// Mocks generated by Mockito 5.4.4 from annotations
// in simontaskmanager/test/features/taskmanager/domain/usecasaes/get_all_todos_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:simontaskmanager/features/core/error/failures.dart' as _i5;
import 'package:simontaskmanager/features/taskmanager/domain/entities/todo_entity.dart'
    as _i7;
import 'package:simontaskmanager/features/taskmanager/domain/entities/todolist_entity.dart'
    as _i6;
import 'package:simontaskmanager/features/taskmanager/domain/repositories/todoRepository.dart'
    as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [TodoRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockTodoRepository extends _i1.Mock implements _i3.TodoRepository {
  @override
  _i4.Future<_i2.Either<_i5.Failures, _i6.TodoListEntity>> getAllTodos({
    required int? limit,
    required int? offset,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllTodos,
          [],
          {
            #limit: limit,
            #offset: offset,
          },
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failures, _i6.TodoListEntity>>.value(
                _FakeEither_0<_i5.Failures, _i6.TodoListEntity>(
          this,
          Invocation.method(
            #getAllTodos,
            [],
            {
              #limit: limit,
              #offset: offset,
            },
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failures, _i6.TodoListEntity>>.value(
                _FakeEither_0<_i5.Failures, _i6.TodoListEntity>(
          this,
          Invocation.method(
            #getAllTodos,
            [],
            {
              #limit: limit,
              #offset: offset,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failures, _i6.TodoListEntity>>);

  @override
  _i4.Future<_i2.Either<_i5.Failures, _i7.TodoEntity>> addTodos({
    required String? todo,
    required bool? isCompleted,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addTodos,
          [],
          {
            #todo: todo,
            #isCompleted: isCompleted,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failures, _i7.TodoEntity>>.value(
            _FakeEither_0<_i5.Failures, _i7.TodoEntity>(
          this,
          Invocation.method(
            #addTodos,
            [],
            {
              #todo: todo,
              #isCompleted: isCompleted,
            },
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failures, _i7.TodoEntity>>.value(
                _FakeEither_0<_i5.Failures, _i7.TodoEntity>(
          this,
          Invocation.method(
            #addTodos,
            [],
            {
              #todo: todo,
              #isCompleted: isCompleted,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failures, _i7.TodoEntity>>);
}

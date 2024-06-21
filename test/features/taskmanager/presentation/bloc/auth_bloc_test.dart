import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simontaskmanager/features/core/error/failures.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/user_dto.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/auth/get_logged_in_user_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/auth/login_user_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/auth/logout_user_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/presentation/bloc/auth_bloc.dart';
import 'package:simontaskmanager/features/taskmanager/utils/validators/LoginValidator.dart';

import '../../../../jsons/JsonReader.dart';
import 'auth_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LoginUserUseCase>(),
  MockSpec<GetLoggedInUserUsecase>(),
  MockSpec<LogoutUserUseCase>(),
  MockSpec<LoginValidator>(),
])
void main() {
  late AuthBloc authBloc;
  late MockLoginUserUseCase mockLoginUserUseCase;
  late MockGetLoggedInUserUsecase mockGetLoggedInUserUsecase;
  late MockLogoutUserUseCase mockLogoutUserUseCase;
  late MockLoginValidator mockLoginValidator;

  setUp(() {
    mockLoginUserUseCase = MockLoginUserUseCase();
    mockGetLoggedInUserUsecase = MockGetLoggedInUserUsecase();
    mockLogoutUserUseCase = MockLogoutUserUseCase();
    mockLoginValidator = MockLoginValidator();
    authBloc = AuthBloc(mockLoginUserUseCase, mockGetLoggedInUserUsecase,
        mockLogoutUserUseCase, mockLoginValidator);
  });

  test('Initial State should be AuthStateInitial', () {
    expect(authBloc.state, AuthStateInitial());
  });

  group('login', () {
    final tUserJson = json.decode(readJson(UserPath()));
    final tUser = UserDTO.fromJson(tUserJson);
    final tUsername = tUser.username;
    const tPassword = '123456';

    test('should call login validator to validate username', () async{
      when(mockLoginValidator.validateUsername(tUser.username))
          .thenReturn(const InputFailure('invalid username'));
      authBloc.add(AuthEventLogin(username: tUser.username, password: '123456'));
      await untilCalled(mockLoginValidator.validateUsername(tUser.username));
      verify(mockLoginValidator.validateUsername(tUser.username));
    });

    test('should call login validator to validate password', () async{
      when(mockLoginValidator.validateUsername(tUser.username))
          .thenReturn(null);
      when(mockLoginValidator.validatePassword(tPassword))
          .thenReturn(null);
      authBloc.add(AuthEventLogin(username: tUser.username, password: '123456'));
      await untilCalled(mockLoginValidator.validateUsername(tUser.username));
      verify(mockLoginValidator.validateUsername(tUser.username));
    });



    test('should emit [AuthStateLoading, AuthStateLoggedIn] when login is successful', () async {
      when(mockLoginValidator.validateUsername(any))
          .thenReturn(null);
      when(mockLoginValidator.validatePassword(any))
          .thenReturn(null);
      when(mockLoginUserUseCase(params: anyNamed('params')))
          .thenAnswer((_) async => Right(tUser));

      final expected = [
        AuthStateLoading(),
        AuthStateLoggedIn(user: tUser)
      ];

      expectLater(authBloc.stream, emitsInOrder(expected));

      authBloc.add(AuthEventLogin(username: tUsername, password: tPassword));
    });


    test('should emit [AuthStateLoading, AuthStateError] when login fails', () async {
      when(mockLoginValidator.validateUsername(any))
          .thenReturn(null);
      when(mockLoginValidator.validatePassword(any))
          .thenReturn(null);
      when(mockLoginUserUseCase(params: anyNamed('params')))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        AuthStateLoading(),
        const AuthStateError('Server Error')
      ];

      expectLater(authBloc.stream, emitsInOrder(expected));

      authBloc.add(AuthEventLogin(username: tUsername, password: tPassword));
    });

    test('should emit [AuthStateLoading, AuthStateError] when validation fails', () async {
      when(mockLoginValidator.validateUsername(any))
          .thenReturn(const InputFailure('invalid username'));

      final expected = [
        AuthStateLoading(),
        const AuthStateError('invalid username')
      ];

      expectLater(authBloc.stream, emitsInOrder(expected));

      authBloc.add(AuthEventLogin(username: tUsername, password: tPassword));
    });

  });

  group('logout', () {
    test('should call logout use case', () async {
      when(mockLogoutUserUseCase(params: anyNamed('params')))
          .thenAnswer((_) async => const Right(true));

      authBloc.add(AuthEventLogout());

      await untilCalled(mockLogoutUserUseCase(params: anyNamed('params')));

      verify(mockLogoutUserUseCase(params: anyNamed('params')));
    });

    test('should emit [AuthStateLoggedOut] when logout is successful', () async {
      when(mockLogoutUserUseCase(params: anyNamed('params')))
          .thenAnswer((_) async => const Right(true));

      final expected = [
        AuthStateLoggedOut()
      ];

      expectLater(authBloc.stream, emitsInOrder(expected));

      authBloc.add(AuthEventLogout());
    });
  });

  group('getLoggedInUser', () {
    final tUserJson = json.decode(readJson(UserPath()));
    final tUser = UserDTO.fromJson(tUserJson);

    test('should emit [AuthStateLoggedIn] when user is logged in', () async {
      when(mockGetLoggedInUserUsecase(params: anyNamed('params')))
          .thenAnswer((_) async => Right(tUser));

      final expected = [
        AuthStateLoggedIn(user: tUser)
      ];

      expectLater(authBloc.stream, emitsInOrder(expected));

      authBloc.add(AuthEventInitial());
    });

    test('should emit [AuthStateLoggedOut] when no user is logged in', () async {
      when(mockGetLoggedInUserUsecase(params: anyNamed('params')))
          .thenAnswer((_) async => Left(LocalCacheFailure()));

      final expected = [
        AuthStateLoggedOut()
      ];

      expectLater(authBloc.stream, emitsInOrder(expected));

      authBloc.add(AuthEventInitial());
    });
  });

}

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:simontaskmanager/features/core/error/exceptions.dart';
import 'package:simontaskmanager/features/core/error/failures.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/token_dto.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/user_dto.dart';
import 'package:simontaskmanager/features/taskmanager/data/repositories/auth_repository_impl.dart';

import 'todo_repository_impl_test.mocks.dart';

void main() {
  late MockTaskManagerDatasource mockDataSource;
  late MockTaskManagerLocalDatasource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late AuthRepositoryImpl authRepositoryImpl;

  setUp(() {
    mockDataSource = MockTaskManagerDatasource();
    mockNetworkInfo = MockNetworkInfo();
    mockLocalDataSource = MockTaskManagerLocalDatasource();
    authRepositoryImpl = AuthRepositoryImpl(
      localDatasource: mockLocalDataSource,
      datasource: mockDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tTokenDto = TokenDTO(
      token:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidXNlcm5hbWUiOiJtaWNoYWVsdyIsImVtYWlsIjoibWljaGFlbC53aWxsaWFtc0B4LmR1bW15anNvbi5jb20iLCJmaXJzdE5hbWUiOiJNaWNoYWVsIiwibGFzdE5hbWUiOiJXaWxsaWFtcyIsImdlbmRlciI6Im1hbGUiLCJpbWFnZSI6Imh0dHBzOi8vZHVtbXlqc29uLmNvbS9pY29uL21pY2hhZWx3LzEyOCIsImlhdCI6MTcxNzYxMzQ0OSwiZXhwIjoxNzE3NjE3MDQ5fQ.iI75FqR7VRSQ0uxZUryH_7ee-TghM_hrxSFuzwJO63I",
      refreshToken:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidXNlcm5hbWUiOiJtaWNoYWVsdyIsImVtYWlsIjoibWljaGFlbC53aWxsaWFtc0B4LmR1bW15anNvbi5jb20iLCJmaXJzdE5hbWUiOiJNaWNoYWVsIiwibGFzdE5hbWUiOiJXaWxsaWFtcyIsImdlbmRlciI6Im1hbGUiLCJpbWFnZSI6Imh0dHBzOi8vZHVtbXlqc29uLmNvbS9pY29uL21pY2hhZWx3LzEyOCIsImlhdCI6MTcxNzYxMzQ0OSwiZXhwIjoxNzIwMjA1NDQ5fQ.G9zS9jdoWLjHwEr9sQM6nPaQPi0PJSCMt9oO8xTAdAY");

  const tUserDto = UserDTO(
      id: 1,
      username: "emilys",
      email: "emily.johnson@x.dummyjson.com",
      firstName: "Emily",
      lastName: "Johnson",
      gender: "female",
      image: "https://dummyjson.com/icon/emilys/128",
      token:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidXNlcm5hbWUiOiJtaWNoYWVsdyIsImVtYWlsIjoibWljaGFlbC53aWxsaWFtc0B4LmR1bW15anNvbi5jb20iLCJmaXJzdE5hbWUiOiJNaWNoYWVsIiwibGFzdE5hbWUiOiJXaWxsaWFtcyIsImdlbmRlciI6Im1hbGUiLCJpbWFnZSI6Imh0dHBzOi8vZHVtbXlqc29uLmNvbS9pY29uL21pY2hhZWx3LzEyOCIsImlhdCI6MTcxNzYxMzQ0OSwiZXhwIjoxNzE3NjE3MDQ5fQ.iI75FqR7VRSQ0uxZUryH_7ee-TghM_hrxSFuzwJO63I",
      refreshToken:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidXNlcm5hbWUiOiJtaWNoYWVsdyIsImVtYWlsIjoibWljaGFlbC53aWxsaWFtc0B4LmR1bW15anNvbi5jb20iLCJmaXJzdE5hbWUiOiJNaWNoYWVsIiwibGFzdE5hbWUiOiJXaWxsaWFtcyIsImdlbmRlciI6Im1hbGUiLCJpbWFnZSI6Imh0dHBzOi8vZHVtbXlqc29uLmNvbS9pY29uL21pY2hhZWx3LzEyOCIsImlhdCI6MTcxNzYxMzQ0OSwiZXhwIjoxNzIwMjA1NDQ5fQ.G9zS9jdoWLjHwEr9sQM6nPaQPi0PJSCMt9oO8xTAdAY");

  test('should  logoout', () {
    when(mockLocalDataSource.clearCache())
        .thenAnswer((_) async => true);
    authRepositoryImpl.logOut();
    verify(mockLocalDataSource.clearCache()).called(1);
  });

  test('should  get current user if data is avaialble', () async{
    when(mockLocalDataSource.getLoggedInUser())
        .thenAnswer((_) async => tUserDto);
    final user = await authRepositoryImpl.getLoggedInUser();
    verify(mockLocalDataSource.getLoggedInUser()).called(1);
    expect(user, const Right(tUserDto));
  });

  test('should  throw error when  user if data is not avaialble', () async{
    when(mockLocalDataSource.getLoggedInUser())
        .thenAnswer((_) async => null);
    final user = await authRepositoryImpl.getLoggedInUser();
    verify(mockLocalDataSource.getLoggedInUser()).called(1);
    expect(user,  Left(LocalCacheFailure()));
  });


  group('loginUser', () {
    test('should check if device is online', () {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockDataSource.login(
              username: tUserDto.username, password: "123", expiresInMin: 3))
          .thenAnswer((_) async => tUserDto);
      authRepositoryImpl.login(
          username: tUserDto.username, password: "123", expiresInMin: 3);
      verify(mockNetworkInfo.isConnected).called(1);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockDataSource.login(
                username: tUserDto.username, password: "123", expiresInMin: 3))
            .thenAnswer((_) async => tUserDto);
        when(mockLocalDataSource.saveUserData(user: tUserDto))
            .thenAnswer((_) async => true);
      });

      test('should return correct user data if device online', () async {
        final result = await authRepositoryImpl.login(
            username: tUserDto.username, password: "123", expiresInMin: 3);
        verify(mockDataSource.login(
                username: tUserDto.username, password: "123", expiresInMin: 3))
            .called(1);
        expect(result, const Right(tUserDto));
      });

      test(
          'should then cache user data if correct user data is returned when device online',
          () async {
        final result = await authRepositoryImpl.login(
            username: tUserDto.username, password: "123", expiresInMin: 3);
        verify(mockDataSource.login(
                username: tUserDto.username, password: "123", expiresInMin: 3))
            .called(1);
        verify(mockLocalDataSource.saveUserData(user: tUserDto));
        expect(result, const Right(tUserDto));
      });

      test('should return server failure if device online and error occur',
          () async {
        when(mockDataSource.login(
                username: tUserDto.username, password: "123", expiresInMin: 3))
            .thenThrow(ServerException(message: ''));
        final result = await authRepositoryImpl.login(
            username: tUserDto.username, password: "123", expiresInMin: 3);
        expect(result, Left(ServerFailure()));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return network failure if device offline', () async {
        final result = await authRepositoryImpl.login(
            username: tUserDto.username, password: "123", expiresInMin: 3);
        verifyZeroInteractions(mockDataSource);
        expect(result, Left(NetworkFailure()));
      });
    });
  });

  group('refreshToken', () {
    test('should check if device is online', () {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockDataSource.refreshAuthToken(
              refreshToken: tUserDto.refreshToken, expiresInMin: 3))
          .thenAnswer((_) async => tTokenDto);
      authRepositoryImpl.refreshAuthToken(
          refreshToken: tUserDto.refreshToken, expiresInMin: 3);
      verify(mockNetworkInfo.isConnected).called(1);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockDataSource.refreshAuthToken(
                refreshToken: tUserDto.refreshToken, expiresInMin: 3))
            .thenAnswer((_) async => tTokenDto);
      });

      test('should return correct token data if device online', () async {
        final result = await authRepositoryImpl.refreshAuthToken(
            refreshToken: tUserDto.refreshToken, expiresInMin: 3);
        verify(mockDataSource.refreshAuthToken(
                refreshToken: tUserDto.refreshToken, expiresInMin: 3))
            .called(1);
        expect(result, const Right(tTokenDto));
      });
      test('should return server failure if device online and error occur',
          () async {
        when(mockDataSource.refreshAuthToken(
                refreshToken: tUserDto.refreshToken, expiresInMin: 3))
            .thenThrow(ServerException(message: ''));
        final result = await authRepositoryImpl.refreshAuthToken(
            refreshToken: tUserDto.refreshToken, expiresInMin: 3);
        expect(result, Left(ServerFailure()));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return network failure if device offline', () async {
        final result = await authRepositoryImpl.refreshAuthToken(
            refreshToken: tUserDto.refreshToken, expiresInMin: 3);
        verifyZeroInteractions(mockDataSource);
        expect(result, Left(NetworkFailure()));
      });
    });
  });
}

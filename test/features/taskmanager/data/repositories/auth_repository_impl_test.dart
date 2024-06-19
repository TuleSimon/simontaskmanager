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
  late MockNetworkInfo mockNetworkInfo;
  late AuthRepositoryImpl authRepositoryImpl;

  setUp(() {
    mockDataSource = MockTaskManagerDatasource();
    mockNetworkInfo = MockNetworkInfo();
    authRepositoryImpl = AuthRepositoryImpl(
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
      });

      test('should return correct user data if device online', () async {
        final result = await authRepositoryImpl.login(
            username: tUserDto.username, password: "123", expiresInMin: 3);
        verify(mockDataSource.login(
                username: tUserDto.username, password: "123", expiresInMin: 3))
            .called(1);
        expect(result, const Right(tUserDto));
      });
      test('should return server failure if device online and error occur',
          () async {
        when(mockDataSource.login(
                username: tUserDto.username, password: "123", expiresInMin: 3))
            .thenThrow(ServerException());
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
            .thenThrow(ServerException());
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

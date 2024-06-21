import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/token_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/user_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/repositories/authRepository.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/auth/refresh_token_usecase.dart';

import 'login_user_usecase_test.mocks.dart';

void main() {
  late AuthRepository authRepository;
  late RefreshTokenUsecase refreshTokenUseCase;
  setUp(() {
    authRepository = MockAuthRepository();
    refreshTokenUseCase = RefreshTokenUsecase(authRepository: authRepository);
  });

  const tPassword = "123456";
  const tExpiresIn = 60;
  const tUser = UserEntity(
      id: 1,
      username: 'Simon',
      email: 'tulesimon98#gmail.com',
      firstName: 'Tule',
      lastName: 'Simon',
      gender: 'Male',
      image: 'https://dummy.com',
      token: 'somerandomtoken',
      refreshToken: 'somerandomrefreshtoken');

  const tNewToken = TokenEntity(token: "newToken", refreshToken: "NewRefresh");

  test(
      'Refreshing a token should return correct new token and new refresh token',
      () async {
    when(authRepository.refreshAuthToken(
            refreshToken: tUser.refreshToken, expiresInMin: tExpiresIn))
        .thenAnswer((_) async => const Right(tNewToken));
    final result = await refreshTokenUseCase(
        params: RefreshTokenParams(
            refreshToken: tUser.refreshToken, expiresInMin: tExpiresIn));
    expect(result, const Right(tNewToken));
    verify(authRepository.refreshAuthToken(
        refreshToken: tUser.refreshToken, expiresInMin: tExpiresIn));
    verifyNoMoreInteractions(authRepository);
  });
}

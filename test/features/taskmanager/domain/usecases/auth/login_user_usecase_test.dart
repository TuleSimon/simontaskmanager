import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/user_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/repositories/authRepository.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/auth/login_user_usecase.dart';

import 'login_user_usecase_test.mocks.dart';

//Annotation to generate mock
@GenerateNiceMocks([MockSpec<AuthRepository>()])
void main() {
  late MockAuthRepository mockAuthRepository;
  late LoginUserUseCase loginUserUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUserUseCase = LoginUserUseCase(authRepository: mockAuthRepository);
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

  test(
      'Logging in a user with correct password should return correct user entity',
      () async {
    when(mockAuthRepository.login(
            username: tUser.username,
            password: tPassword,
            expiresInMin: tExpiresIn))
        .thenAnswer((_) async => const Right(tUser));
    final loggedInResult = await loginUserUseCase(
        params: LoginUserParams(
            userName: tUser.username,
            password: tPassword,
            expiresInMin: tExpiresIn));
    expect(loggedInResult, const Right(tUser));
    verify(mockAuthRepository.login(
        username: tUser.username,
        password: tPassword,
        expiresInMin: tExpiresIn));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}

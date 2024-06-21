import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:simontaskmanager/features/core/error/failures.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/user_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/auth/get_logged_in_user_usecase.dart';

import 'login_user_usecase_test.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late GetLoggedInUserUsecase getLoggedInUserUsecase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    getLoggedInUserUsecase =
        GetLoggedInUserUsecase(authRepository: mockAuthRepository);
  });

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

  test('should return correct user details', () async {
    when(mockAuthRepository.getLoggedInUser())
        .thenAnswer((_) async => const Right(tUser));
    final loggedInResult = await getLoggedInUserUsecase(params: NoParams());
    expect(loggedInResult, const Right(tUser));
    verify(mockAuthRepository.getLoggedInUser());
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return failure when no data', () async {
    when(mockAuthRepository.getLoggedInUser())
        .thenAnswer((_) async => Left(LocalCacheFailure()));
    final loggedInResult = await getLoggedInUserUsecase(params: NoParams());
    expect(loggedInResult, Left(LocalCacheFailure()));
    verify(mockAuthRepository.getLoggedInUser());
    verifyNoMoreInteractions(mockAuthRepository);
  });
}

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:simontaskmanager/features/core/error/exceptions.dart';
import 'package:simontaskmanager/features/core/error/failures.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/auth/get_logged_in_user_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/auth/logout_user_usecase.dart';

import 'login_user_usecase_test.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late LogoutUserUseCase logoutUserUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    logoutUserUseCase = LogoutUserUseCase(authRepository: mockAuthRepository);
  });

  test('should logout user', () async {
    when(mockAuthRepository.logOut())
        .thenAnswer((_) async => const Right(true));
    final result = await logoutUserUseCase(params: NoParams());
    verify(mockAuthRepository.logOut()).called(1);
    expect(result, const Right(true));
  });

  test('should catch exception', () async {
    when(mockAuthRepository.logOut())
        .thenAnswer((_) async => Left(LocalCacheFailure()));
    final result = await logoutUserUseCase(params: NoParams());
    verify(mockAuthRepository.logOut()).called(1);
    expect(result, Left(LocalCacheFailure()));
  });
}

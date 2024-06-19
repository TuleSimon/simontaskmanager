import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:simontaskmanager/features/core/error/failures.dart';
import 'package:simontaskmanager/features/core/usecases/usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/user_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/repositories/authRepository.dart';

class LoginUserParams extends Equatable {
  final String userName;
  final String password;
  final int expiresInMin;

  const LoginUserParams(
      {required this.userName,
      required this.password,
      required this.expiresInMin});

  @override
  List<Object?> get props => [userName, password, expiresInMin];
}

class LoginUserUseCase implements Usecase<UserEntity, LoginUserParams> {
  final AuthRepository authRepository;

  LoginUserUseCase({required this.authRepository});

  @override
  Future<Either<Failures, UserEntity>> call(
      {required LoginUserParams params}) async {
    return await authRepository.login(
        username: params.userName,
        password: params.password,
        expiresInMin: params.expiresInMin);
  }
}

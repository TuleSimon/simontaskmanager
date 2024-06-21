import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:simontaskmanager/features/core/error/failures.dart';
import 'package:simontaskmanager/features/core/usecases/usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/token_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/repositories/authRepository.dart';

class RefreshTokenParams extends Equatable {
  final String refreshToken;
  final int expiresInMin;

  const RefreshTokenParams(
      {required this.refreshToken, required this.expiresInMin});

  @override
  List<Object?> get props => [refreshToken, expiresInMin];
}

class RefreshTokenUsecase implements Usecase<TokenEntity, RefreshTokenParams> {
  final AuthRepository authRepository;

  RefreshTokenUsecase({required this.authRepository});

  @override
  Future<Either<Failure, TokenEntity>> call(
      {required RefreshTokenParams params}) async {
    return await authRepository.refreshAuthToken(
        refreshToken: params.refreshToken, expiresInMin: params.expiresInMin);
  }
}

import 'package:dartz/dartz.dart';
import 'package:simontaskmanager/features/core/error/exceptions.dart';
import 'package:simontaskmanager/features/core/error/failures.dart';
import 'package:simontaskmanager/features/core/platform/network_info.dart';
import 'package:simontaskmanager/features/taskmanager/data/datasources/remote/task_manager_datasource.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/token_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/user_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/repositories/authRepository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final TaskManagerDatasource datasource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({required this.datasource, required this.networkInfo});

  @override
  Future<Either<Failure, UserEntity>> login(
      {required String username,
      required String password,
      required int expiresInMin}) async {
    if (await networkInfo.isConnected) {
      try {
        final res = await datasource.login(
            username: username, password: password, expiresInMin: expiresInMin);
        return Right(res);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, TokenEntity>> refreshAuthToken(
      {required String refreshToken, required int expiresInMin}) async {
    if (await networkInfo.isConnected) {
      try {
        final res = await datasource.refreshAuthToken(
            refreshToken: refreshToken, expiresInMin: expiresInMin);
        return Right(res);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}

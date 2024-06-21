import 'package:dartz/dartz.dart';
import 'package:simontaskmanager/features/core/error/exceptions.dart';
import 'package:simontaskmanager/features/core/error/failures.dart';
import 'package:simontaskmanager/features/core/network/network_info.dart';
import 'package:simontaskmanager/features/taskmanager/data/datasources/local/task_manager_localdatasource.dart';
import 'package:simontaskmanager/features/taskmanager/data/datasources/remote/task_manager_datasource.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/token_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/user_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/repositories/authRepository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final TaskManagerDatasource datasource;
  final TaskManagerLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl(
      {required this.datasource,
      required this.networkInfo,
      required this.localDatasource});

  @override
  Future<Either<Failure, UserEntity>> login(
      {required String username,
      required String password,
      required int expiresInMin}) async {
    if (await networkInfo.isConnected) {
      try {
        final res = await datasource.login(
            username: username, password: password, expiresInMin: expiresInMin);
        await localDatasource.saveUserData(user: res);
        return Right(res);
      } on ServerException catch (error){
        return Left(ServerFailure(message:error.message));
      } on NetworkException {
        return Left(NetworkFailure());
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
      } on NetworkException {
        return Left(NetworkFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getLoggedInUser() async {
    final user = await localDatasource.getLoggedInUser();
    if (user != null) {
      return Right(user);
    } else {
      return Left(LocalCacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> logOut() async {
    try {
      await localDatasource.clearCache();
      return const Right(true);
    } catch (e) {
      return Left(LocalCacheFailure());
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:simontaskmanager/features/core/error/failures.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/token_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/user_entity.dart';

abstract class AuthRepository {
  ///
  /// This functions is used to login a user,
  /// it returns a future with an `Either` which left is a failure,
  /// if requests fails, left returns a [Failures]
  /// if requests success, right returns a [UserEntity]
  ///
  Future<Either<Failures, UserEntity>> login({required String username, required String password, required int expiresInMin});

  ///
  /// This functions is used to refresh an existing session after it expires,
  /// it returns a future with an `Either` which left is a failure,
  /// if requests fails, left returns a [Failures]
  /// if requests success, right returns a [TokenEntity]
  ///
  Future<Either<Failures, TokenEntity>> refreshAuthToken({required String refreshToken,  required int expiresInMin});
}

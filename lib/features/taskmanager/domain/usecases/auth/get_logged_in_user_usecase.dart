import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:simontaskmanager/features/core/error/failures.dart';
import 'package:simontaskmanager/features/core/usecases/usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/user_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/repositories/authRepository.dart';

class NoParams{

}

class GetLoggedInUserUsecase implements Usecase<UserEntity, NoParams> {
  final AuthRepository authRepository;

  GetLoggedInUserUsecase({required this.authRepository});

  @override
  Future<Either<Failure, UserEntity>> call(
      {required NoParams params}) async {
    return await authRepository .getLoggedInUser();
  }
}

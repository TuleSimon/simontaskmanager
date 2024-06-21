import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:simontaskmanager/features/core/error/failures.dart';
import 'package:simontaskmanager/features/core/usecases/usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/user_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/repositories/authRepository.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/auth/get_logged_in_user_usecase.dart';

class LogoutUserUseCase implements Usecase<bool, NoParams> {
  final AuthRepository authRepository;

  LogoutUserUseCase({required this.authRepository});

  @override
  Future<Either<Failure, bool>> call({required NoParams params}) async {
    return await authRepository.logOut();
  }
}

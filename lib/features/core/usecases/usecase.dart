import 'package:dartz/dartz.dart';
import 'package:simontaskmanager/features/core/error/failures.dart';

abstract class Usecase<Type, Params>{
  Future<Either<Failures, Type>> call({required Params params});
}
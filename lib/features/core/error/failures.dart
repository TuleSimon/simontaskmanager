import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List<dynamic> properties;

  const Failure([this.properties = const <dynamic>[]]) : super();

  @override
  List<Object> get props => [...properties];
}

class ServerFailure extends Failure {}
class NetworkFailure extends Failure {}
class LocalCacheFailure extends Failure {}
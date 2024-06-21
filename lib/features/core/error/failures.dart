import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {

  final List<dynamic> properties;

  const Failure([this.properties = const <dynamic>[]]) : super();

  @override
  List<Object> get props => [...properties];
}

class ServerFailure extends Failure {
  final String? message;
  const ServerFailure({this.message});
}

class InputFailure extends Failure {
  final String? message;

  const InputFailure(this.message);
}

class NetworkFailure extends Failure {}

class LocalCacheFailure extends Failure {}


import 'package:equatable/equatable.dart';

abstract class Failures extends Equatable {
  final List<dynamic> properties;

  const Failures([this.properties = const <dynamic>[]]) : super();

  @override
  List<Object> get props => [...properties];
}

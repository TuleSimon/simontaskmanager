part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthEventLogin extends AuthEvent {
  final String username;
  final String password;

  const AuthEventLogin({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}


class AuthEventLogout extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class AuthEventInitial extends AuthEvent {
  @override
  List<Object?> get props => [];
}
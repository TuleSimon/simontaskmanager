part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

final class AuthStateInitial extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthStateLoading extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthStateLoggedOut extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthStateError extends AuthState {
  final String error;

  const AuthStateError(this.error);

  @override
  List<Object> get props => [error];
}

final class AuthStateLoggedIn extends AuthState {
  final UserEntity user;

  const AuthStateLoggedIn({required this.user});

  @override
  List<Object> get props => [user];
}

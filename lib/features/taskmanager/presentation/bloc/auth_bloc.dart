import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:simontaskmanager/features/core/error/failures.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/user_entity.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/auth/get_logged_in_user_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/auth/login_user_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/domain/usecases/auth/logout_user_usecase.dart';
import 'package:simontaskmanager/features/taskmanager/utils/validators/LoginValidator.dart';

part 'auth_state.dart';

part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUserUseCase loginUserUseCase;
  final LoginValidator loginValidator;
  final GetLoggedInUserUsecase getLoggedInUserUsecase;
  final LogoutUserUseCase logoutUserUseCase;

  AuthBloc(this.loginUserUseCase, this.getLoggedInUserUsecase,
      this.logoutUserUseCase, this.loginValidator)
      : super(AuthStateInitial()) {
    on<AuthEventInitial>(getLoggedInUser);
    on<AuthEventLogin>(_onLogin);
    on<AuthEventLogout>(_onLogout);
  }

  Future<void> _onLogin(AuthEventLogin event, Emitter<AuthState> emit) async {
    emit(AuthStateLoading());
    try {
      final validatorResult = loginValidator.validateUsername(event.username);
      if (validatorResult != null) {
        emit(AuthStateError(validatorResult.message!));
        return;
      }
      final validatorPasswordResult =
          loginValidator.validatePassword(event.password);
      if (validatorPasswordResult != null) {
        emit(AuthStateError(validatorPasswordResult.message!));
        return;
      }
      emit(AuthStateLoading());
      final result = await loginUserUseCase(
          params: LoginUserParams(
              userName: event.username,
              password: event.password,
              expiresInMin: 60));
      result.fold(
          (error) => error is NetworkFailure
              ? emit(const AuthStateError('Check your internet connection'))
              : emit(AuthStateError(
                  (error as ServerFailure).message ?? 'Server Error')),
          (res) => emit(AuthStateLoggedIn(user: res)));
    } catch (e) {
      emit(AuthStateError(e.toString()));
    }
  }

  Future<void> _onLogout(AuthEventLogout event, Emitter<AuthState> emit) async {
    // Handle logout logic if any
    await logoutUserUseCase(params: NoParams());
    emit(AuthStateLoggedOut());
  }

  Future<void> getLoggedInUser(
      AuthEventInitial event, Emitter<AuthState> emit) async {
    try {
      final user = await getLoggedInUserUsecase(params: NoParams());
      user.fold((error) => emit(AuthStateLoggedOut()),
          (user) => emit(AuthStateLoggedIn(user: user)));
    } catch (e) {
      emit(AuthStateError(e.toString()));
    }
  }
}

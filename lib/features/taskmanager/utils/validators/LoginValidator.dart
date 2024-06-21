import 'package:simontaskmanager/features/core/error/failures.dart';

class LoginValidator {
  InputFailure? validateUsername(String username) {
    if (username.isEmpty) {
      return const InputFailure('Username cannot be empty');
    }
    if (username.length < 3) {
      return const InputFailure('Username must be at least 3 characters long');
    }
    return null;
  }

  InputFailure? validatePassword(String password) {
    if (password.isEmpty) {
      return const InputFailure('Password cannot be empty');
    }
    if (password.length < 6) {
      return const InputFailure('Password must be at least 6 characters long');
    }
    return null;
  }
}

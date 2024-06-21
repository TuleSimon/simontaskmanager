
import 'package:simontaskmanager/features/core/error/failures.dart';

class TodoValidator {
  InputFailure? validateTodoText(String todo) {
    if (todo.isEmpty) {
      return const InputFailure('Todo text cannot be empty');
    }
    return null;
  }

  InputFailure? validateCompleted(bool? completed) {
    if (completed == null) {
      return const InputFailure('Completed status must be specified');
    }
    return null;
  }

  InputFailure? validateUserId(int? userId) {
    if (userId == null || userId <= 0) {
      return const InputFailure('UserId must be a positive integer');
    }
    return null;
  }
}

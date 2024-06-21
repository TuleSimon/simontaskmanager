import 'package:flutter_test/flutter_test.dart';
import 'package:simontaskmanager/features/core/error/failures.dart';
import 'package:simontaskmanager/features/taskmanager/utils/validators/LoginValidator.dart';

void main() {
  final validator = LoginValidator();

  group('Username Validation', () {
    test('should return error when username is empty', () {

      const username = '';
      // act
      final result = validator.validateUsername(username);
      // assert
      expect(result, isA<InputFailure>());
      expect(result?.message, 'Username cannot be empty');
    });

    test('should return error when username is less than 3 characters', () {
      // arrange
      const username = 'ab';
      // act
      final result = validator.validateUsername(username);
      // assert
      expect(result, isA<InputFailure>());
      expect(result?.message, 'Username must be at least 3 characters long');
    });

    test('should return null when username is valid', () {
      // arrange
      const username = 'validUsername';
      // act
      final result = validator.validateUsername(username);
      // assert
      expect(result, isNull);
    });
  });

  group('Password Validation', () {
    test('should return error when password is empty', () {
      // arrange
      const password = '';
      // act
      final result = validator.validatePassword(password);
      // assert
      expect(result, isA<InputFailure>());
      expect(result?.message, 'Password cannot be empty');
    });

    test('should return error when password is less than 6 characters', () {
      // arrange
      const password = '12345';
      // act
      final result = validator.validatePassword(password);
      // assert
      expect(result, isA<InputFailure>());
      expect(result?.message, 'Password must be at least 6 characters long');
    });

    test('should return null when password is valid', () {
      // arrange
      const password = 'validPassword';
      // act
      final result = validator.validatePassword(password);
      // assert
      expect(result, isNull);
    });
  });
}

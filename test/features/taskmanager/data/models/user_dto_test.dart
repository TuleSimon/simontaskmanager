import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/user_dto.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/user_entity.dart';

import '../../../../jsons/JsonReader.dart';

void main() {
  const tUserDto = UserDTO(
      id: 1,
      username: "emilys",
      email: "emily.johnson@x.dummyjson.com",
      firstName: "Emily",
      lastName: "Johnson",
      gender: "female",
      image: "https://dummyjson.com/icon/emilys/128",
      token:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidXNlcm5hbWUiOiJtaWNoYWVsdyIsImVtYWlsIjoibWljaGFlbC53aWxsaWFtc0B4LmR1bW15anNvbi5jb20iLCJmaXJzdE5hbWUiOiJNaWNoYWVsIiwibGFzdE5hbWUiOiJXaWxsaWFtcyIsImdlbmRlciI6Im1hbGUiLCJpbWFnZSI6Imh0dHBzOi8vZHVtbXlqc29uLmNvbS9pY29uL21pY2hhZWx3LzEyOCIsImlhdCI6MTcxNzYxMzQ0OSwiZXhwIjoxNzE3NjE3MDQ5fQ.iI75FqR7VRSQ0uxZUryH_7ee-TghM_hrxSFuzwJO63I",
      refreshToken:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidXNlcm5hbWUiOiJtaWNoYWVsdyIsImVtYWlsIjoibWljaGFlbC53aWxsaWFtc0B4LmR1bW15anNvbi5jb20iLCJmaXJzdE5hbWUiOiJNaWNoYWVsIiwibGFzdE5hbWUiOiJXaWxsaWFtcyIsImdlbmRlciI6Im1hbGUiLCJpbWFnZSI6Imh0dHBzOi8vZHVtbXlqc29uLmNvbS9pY29uL21pY2hhZWx3LzEyOCIsImlhdCI6MTcxNzYxMzQ0OSwiZXhwIjoxNzIwMjA1NDQ5fQ.G9zS9jdoWLjHwEr9sQM6nPaQPi0PJSCMt9oO8xTAdAY");

  test('should be a subclass of UserEntity', () {
    expect(tUserDto, isA<UserEntity>());
  });

  group('fromJson', () {
    test('should return a valid user dto when given json', () {
      final Map<String, dynamic> jsonMap = json.decode(readJson(UserPath()));
      final UserDTO userDto = UserDTO.fromJson(jsonMap);
      expect(userDto, tUserDto);
    });

    test('should return a valid user entity when given json', () {
      final Map<String, dynamic> jsonMap = json.decode(readJson(UserPath()));
      final UserDTO userDto = UserDTO.fromJson(jsonMap);
      expect(userDto, tUserDto);
      final userEntity = userDto;
      expect(userEntity, tUserDto);
    });
  });

  group('toJson', () {
    test('should return a valid json when converting a dto', () {
      final Map<String, dynamic> jsonMap = json.decode(readJson(UserPath()));
      final convertedJson = tUserDto.toJson();
      expect(convertedJson, jsonMap);
    });
  });
}

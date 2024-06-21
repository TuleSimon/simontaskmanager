import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:simontaskmanager/features/taskmanager/data/models/token_dto.dart';
import 'package:simontaskmanager/features/taskmanager/domain/entities/token_entity.dart';

import '../../../../jsons/JsonReader.dart';

void main() {
  const tTokenDto = TokenDTO(
      token:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidXNlcm5hbWUiOiJtaWNoYWVsdyIsImVtYWlsIjoibWljaGFlbC53aWxsaWFtc0B4LmR1bW15anNvbi5jb20iLCJmaXJzdE5hbWUiOiJNaWNoYWVsIiwibGFzdE5hbWUiOiJXaWxsaWFtcyIsImdlbmRlciI6Im1hbGUiLCJpbWFnZSI6Imh0dHBzOi8vZHVtbXlqc29uLmNvbS9pY29uL21pY2hhZWx3LzEyOCIsImlhdCI6MTcxNzYxMzQ0OSwiZXhwIjoxNzE3NjE3MDQ5fQ.iI75FqR7VRSQ0uxZUryH_7ee-TghM_hrxSFuzwJO63I",
      refreshToken:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidXNlcm5hbWUiOiJtaWNoYWVsdyIsImVtYWlsIjoibWljaGFlbC53aWxsaWFtc0B4LmR1bW15anNvbi5jb20iLCJmaXJzdE5hbWUiOiJNaWNoYWVsIiwibGFzdE5hbWUiOiJXaWxsaWFtcyIsImdlbmRlciI6Im1hbGUiLCJpbWFnZSI6Imh0dHBzOi8vZHVtbXlqc29uLmNvbS9pY29uL21pY2hhZWx3LzEyOCIsImlhdCI6MTcxNzYxMzQ0OSwiZXhwIjoxNzIwMjA1NDQ5fQ.G9zS9jdoWLjHwEr9sQM6nPaQPi0PJSCMt9oO8xTAdAY");

  test('should be a subclass of TokenEntity', () {
    expect(tTokenDto, isA<TokenEntity>());
  });

  group('fromJson', () {
    test('should return a valid token dto when given json', () {
      final Map<String, dynamic> jsonMap = json.decode(readJson(TokenPath()));
      final TokenDTO todoDto = TokenDTO.fromJson(jsonMap);
      expect(todoDto, tTokenDto);
    });

    test('should return a valid token entity when given json', () {
      final Map<String, dynamic> jsonMap = json.decode(readJson(TokenPath()));
      final TokenDTO tokenDTO = TokenDTO.fromJson(jsonMap);
      expect(tokenDTO, tTokenDto);
      final userEntity = tokenDTO;
      expect(userEntity, tTokenDto);
    });
  });

  group('toJson', () {
    test('should return a valid json when converting a dto', () {
      final Map<String, dynamic> jsonMap = json.decode(readJson(TokenPath()));
      final convertedJson = tTokenDto.toJson();
      expect(convertedJson, jsonMap);
    });
  });
}

import 'package:simontaskmanager/features/taskmanager/domain/entities/token_entity.dart';

class TokenDTO extends TokenEntity {
  const TokenDTO({
    required super.token,
    required super.refreshToken,
  });

  factory TokenDTO.fromJson(Map<String, dynamic> json) {
    return TokenDTO(
      token: json['token'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
    };
  }
}

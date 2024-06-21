import 'package:equatable/equatable.dart';

class TokenEntity extends Equatable {
  final String token;
  final String refreshToken;

  const TokenEntity({
    required this.token,
    required this.refreshToken,
  });

  @override
  List<Object> get props => [token, refreshToken];

  TokenEntity copyWith({
    String? token,
    String? refreshToken,
  }) {
    return TokenEntity(
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  @override
  String toString() {
    return 'TokenEntity{token: $token, refreshToken: $refreshToken}';
  }
}

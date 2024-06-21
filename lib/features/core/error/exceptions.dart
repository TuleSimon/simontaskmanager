class ServerException implements Exception {
  final String message;
  ServerException({required this.message});
}
class InputException implements Exception {
  final String message;
  InputException({required this.message});
}
class NetworkException implements Exception {}
class LocalCacheException implements Exception {}

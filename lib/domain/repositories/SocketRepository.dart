import 'package:srsappmultiplatform/core/result.dart';

abstract class SocketRepository {
  Future<Result<void>> connect(String userId);
  void disconnect();
  Stream<String> get messagesStream;
  Future<Result<void>> sendMessage(Map<String, dynamic> message);
}

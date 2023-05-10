import 'package:srsappmultiplatform/core/result.dart';
import 'package:srsappmultiplatform/data/datasources/remote/SocketDataSource.dart';
import 'package:srsappmultiplatform/domain/repositories/SocketRepository.dart';

class SocketRepositoryImpl implements SocketRepository {
  final SocketDataSource _socketDataSource;

  SocketRepositoryImpl({required SocketDataSource socketDataSource})
      : _socketDataSource = socketDataSource;

  @override
  Future<Result<void>> connect(String userId) {
    return _socketDataSource.connect(userId);
  }

  @override
  void disconnect() {
    _socketDataSource.disconnect();
  }

  @override
  Stream<String> get messagesStream => _socketDataSource.messagesStream;

  @override
  Future<Result<void>> sendMessage(Map<String, dynamic> message) {
    return _socketDataSource.sendMessage(message);
  }
}

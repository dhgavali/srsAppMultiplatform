import 'package:srsappmultiplatform/core/result.dart';
import 'package:srsappmultiplatform/domain/repositories/SocketRepository.dart';
import 'package:srsappmultiplatform/domain/usecases/usecase.dart';

class SendMessageUseCase extends UseCase<void, SendMessageParams> {
  final SocketRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<Result<void>> call(SendMessageParams params) {
    return repository.sendMessage(params.message);
  }
}

class SendMessageParams {
  final Map<String, dynamic> message;

  SendMessageParams({required this.message});
}

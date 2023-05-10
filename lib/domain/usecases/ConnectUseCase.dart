import 'package:srsappmultiplatform/core/result.dart';
import 'package:srsappmultiplatform/domain/repositories/SocketRepository.dart';
import 'package:srsappmultiplatform/domain/usecases/usecase.dart';

class ConnectUseCase extends UseCase<void, String> {
  final SocketRepository repository;

  ConnectUseCase(this.repository);

  @override
  Future<Result<void>> call(String userId) {
    return repository.connect(userId);
  }
}

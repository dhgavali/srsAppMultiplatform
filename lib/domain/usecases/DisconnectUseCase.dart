import 'package:srsappmultiplatform/core/result.dart';
import 'package:srsappmultiplatform/domain/repositories/SocketRepository.dart';
import 'package:srsappmultiplatform/domain/usecases/usecase.dart';

class DisconnectUseCase extends UseCase<void, NoParams> {
  final SocketRepository repository;

  DisconnectUseCase(this.repository);

  @override
  Future<Result<void>> call(NoParams params) {
    repository.disconnect();
    return Future.value(Result.success(null));
  }
}

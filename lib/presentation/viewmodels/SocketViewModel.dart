import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:srsappmultiplatform/core/result.dart';
import 'package:srsappmultiplatform/domain/entities/TrainerRequest.dart';
import 'package:srsappmultiplatform/domain/repositories/SocketRepository.dart';
import 'package:srsappmultiplatform/domain/usecases/ConnectUseCase.dart';
import 'package:srsappmultiplatform/domain/usecases/DisconnectUseCase.dart';
import 'package:srsappmultiplatform/domain/usecases/SendMessageUseCase.dart';

import '../../data/datasources/remote/SocketDataSource.dart';
import '../../domain/usecases/usecase.dart';

class SocketViewModel with ChangeNotifier {
  final ConnectUseCase _connectUseCase;
  final DisconnectUseCase _disconnectUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  StreamSubscription<String>? _socketMessageSubscription;

  StreamController<List<TrainerRequest>> _trainerRequestsStreamController = StreamController.broadcast();

  Stream<List<TrainerRequest>> get trainerRequestsStream => _trainerRequestsStreamController.stream;

  SocketViewModel({
    required SocketRepository socketRepository,
  })  : _connectUseCase = ConnectUseCase(socketRepository),
        _disconnectUseCase = DisconnectUseCase(socketRepository),
        _sendMessageUseCase = SendMessageUseCase(socketRepository);

Future<Result<void>> connect(String userId) async {
  final result = await _connectUseCase(userId);

  if (result.isFailure) {
    if (!_trainerRequestsStreamController.isClosed) { // Add this check
      _trainerRequestsStreamController.addError(result.failure);
    }
  } else {
    print('Connected successfully');
  }

  return result;
}

  Future<Result<void>> disconnect() async {
    return await _disconnectUseCase(NoParams());
  }

  Future<Result<void>> sendMessage(TrainerRequest trainerRequest) async {
    return await _sendMessageUseCase(
        SendMessageParams(message: trainerRequest.toJson()));
  }

void listenToSocketMessages() {
  _socketMessageSubscription?.cancel();
  _socketMessageSubscription =
    GetIt.instance<SocketDataSource>().messagesStream.listen((message) {
      try {
        final decodedMessage = jsonDecode(message);
        print('Decoded message: $decodedMessage');
        if (decodedMessage['type'] == 'trainer_request') {
          if (!_trainerRequestsStreamController.isClosed) { // Add this check
            final trainerRequest = TrainerRequest.fromJson(decodedMessage['data']);
            _trainerRequestsStreamController.add([trainerRequest]);
          }
        }
      } catch (e) {
        print('Error processing socket message: $e');
      }
    });
}



  @override
  void dispose() {
    _socketMessageSubscription?.cancel();
    _trainerRequestsStreamController.close();
    super.dispose();
  }
}

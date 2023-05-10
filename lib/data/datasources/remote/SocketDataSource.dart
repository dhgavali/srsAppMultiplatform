import 'dart:async';
import 'dart:convert';
import 'package:srsappmultiplatform/core/result.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketDataSource {
  final String _socketUrl = "http://192.168.0.150:3001  ";
  final StreamController<String> _socketStreamController =
      StreamController.broadcast();
  late IO.Socket _socket; // Add a field to store the socket instance

  Future<Result<void>> connect(String userId) async {
    try {
      print("SocketDataSource reached");
      _socket = IO.io(_socketUrl, IO.OptionBuilder().setTransports(['websocket']).build());

      _socket.onConnect((_) {
        print('Connected to WebSocket server');
        _socket.emit('registerUser', {'userId': userId});
      });

      _socket.on('message', (data) {
        print('Message received: $data');
        _socketStreamController.add(data);
      });

      _socket.onError((error) {
        print('Error in WebSocket connection: $error');
        _socketStreamController.addError(error);
        _socket.disconnect();
      });

      _socket.onDisconnect((_) {
        print('Disconnected from WebSocket server');
        _socketStreamController.close();
      });

      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  void disconnect() {
    print('Disconnecting WebSocket');
    _socket.disconnect(); // Update this line to use the _socket instance
  }

  Stream<String> get messagesStream => _socketStreamController.stream;

  Future<Result<void>> sendMessage(Map<String, dynamic> message) async {
    try {
      print('Sending message: $message');
      _socket.emit('message', message); // Update this line to use the _socket instance
      return Result.success(null);
    } catch (e) {
      print('Error in sendMessage method: $e');
      return Result.failure(e.toString());
    }
  }
}

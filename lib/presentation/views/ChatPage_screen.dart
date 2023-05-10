import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srsappmultiplatform/presentation/viewmodels/UserViewModel.dart';
class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Center(
        child: Text('Chat Page'),
      ),
    );
  }
}
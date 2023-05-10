import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:srsappmultiplatform/presentation/viewmodels/UserViewModel.dart';
import 'package:srsappmultiplatform/presentation/viewmodels/SocketViewModel.dart';
import 'package:srsappmultiplatform/domain/entities/TrainerRequest.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final SocketViewModel socketViewModel = GetIt.instance<SocketViewModel>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      final viewModel = Provider.of<SocketViewModel>(context, listen: false);
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);

      if (userViewModel.user != null) {
        final userId =
            userViewModel.user!.id; // Replace with the actual user ID
        await viewModel.connect(userId);
        viewModel.listenToSocketMessages();
      } else {
        // Handle the case when userViewModel.user is null
        // For example, you can show a message or navigate the user to the login screen
      }
    });
  }

  @override
  void dispose() {
    socketViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainer Requests'),
      ),
      body: StreamBuilder<List<TrainerRequest>>(
        stream: socketViewModel.trainerRequestsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final trainerRequests = snapshot.data ?? [];

          return ListView.builder(
            itemCount: trainerRequests.length,
            itemBuilder: (context, index) {
              final request = trainerRequests[index];
              return Card(
                child: ListTile(
                  title: Text('Request from ${request.trainerId}'),
                  subtitle: Text('Status: ${request.status}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () async {
                          // Call accept request logic
                          final updatedRequest = TrainerRequest(
                            trainerId: request.trainerId,
                            traineeId: request.traineeId,
                            status: 'accepted',
                            trainerPackageId: request.trainerPackageId,
                            id: request.id,
                          );
                          final result =
                              await socketViewModel.sendMessage(updatedRequest);
                          if (result.isFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error accepting request')),
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () async {
                          // Call deny request logic
                          final updatedRequest = TrainerRequest(
                            trainerId: request.trainerId,
                            traineeId: request.traineeId,
                            status: 'denied',
                            trainerPackageId: request.trainerPackageId,
                            id: request.id,
                          );
                          final result =
                              await socketViewModel.sendMessage(updatedRequest);
                          if (result.isFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error denying request')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
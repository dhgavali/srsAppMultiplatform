import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:srsappmultiplatform/core/di/service_locator.dart';
import 'package:srsappmultiplatform/domain/entities/User.dart';
import 'package:srsappmultiplatform/presentation/viewmodels/AdminViewModel.dart';

class AdminDashboardScreen extends StatefulWidget {
  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AdminViewModel _adminViewModel = GetIt.I<AdminViewModel>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Trainee'),
            Tab(text: 'Trainer'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _userListTab('trainee'),
          _userListTab('trainer'),
        ],
      ),
    );
  }

  Widget _userListTab(String role) {
    return FutureBuilder<List<User>>(
      future: _adminViewModel.fetchUsersByRole(role),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final users = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () => _refreshUsersList(role),
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Dismissible(
                  key: ValueKey(user.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    final result = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Delete User'),
                          content: Text('Are you sure you want to delete ${user.username}?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                    return result == true;
                  },
                  onDismissed: (direction) async {
                    await _adminViewModel.deleteUser(user.id!);
                    setState(() {
                      users.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('${user.username} deleted'),
                    ));
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text(user.username),
                    subtitle: Text(user.email),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  Future<void> _refreshUsersList(String role) async {
    await _adminViewModel.fetchUsersByRole(role);
    setState(() {});
  }
}



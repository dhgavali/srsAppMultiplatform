import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:srsappmultiplatform/core/di/service_locator.dart';
import 'package:srsappmultiplatform/domain/entities/User.dart';
import 'package:srsappmultiplatform/presentation/viewmodels/AdminViewModel.dart';
import 'package:srsappmultiplatform/presentation/views/ProfilePageAdminSide_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AdminViewModel _adminViewModel = GetIt.I<AdminViewModel>();
  TextEditingController _searchController = TextEditingController();
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  List<User> _filterUsers() {
    String searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isEmpty) {
      return _users;
    } else {
      return _users
          .where((user) =>
      user.username.toLowerCase().contains(searchQuery) ||
          user.email.toLowerCase().contains(searchQuery))
          .toList();
    }
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search for users',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _userListTab('trainee'),
                _userListTab('trainer'),
              ],
            ),
          ),
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
          _users = snapshot.data!;
          return StatefulBuilder(
            builder: (context, setState) {
              final filteredUsers = _filterUsers();
              return RefreshIndicator(
                onRefresh: () => _refreshUsersList(role),
                child: ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return Dismissible(
                      key: ValueKey(user.id),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        final result = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete User'),
                              content: Text(
                                  'Are you sure you want to delete ${user.username}?'
                              ),
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
                          _users.remove(user);
                          filteredUsers.remove(user);
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
                        onTap: () {
                          // Navigate to another screen and pass the User model
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePageAdminSide(user: user),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
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

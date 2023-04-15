import 'package:flutter/material.dart';
import 'package:srsappmultiplatform/presentation/viewmodels/UserViewModel.dart';
import 'package:provider/provider.dart';
import 'package:srsappmultiplatform/presentation/views/admin_dashboard_screen.dart'; // Import the AdminDashboardScreen
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                final viewModel = Provider.of<UserViewModel>(context, listen: false);
                final success = await viewModel.login(
                  _usernameController.text,
                  _passwordController.text,
                );
                if (success) {
                  if (viewModel.isAdmin()) {
                    print("admin");
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AdminDashboardScreen()),
                    );
                  } else {
                    print("not admin");
                    Navigator.of(context).pushNamedAndRemoveUntil('/traineeDashboard',(route) =>false);
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: Text(viewModel.errorMessage ?? 'An error occurred'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Sign up',
                      style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

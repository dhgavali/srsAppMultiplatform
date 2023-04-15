import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:srsappmultiplatform/data/datasources/auth_local_storage.dart';
import 'package:srsappmultiplatform/presentation/views/trainee_dashboard_screen.dart';
import 'package:srsappmultiplatform/data/datasources/remote/remote_data_source.dart';
import 'package:srsappmultiplatform/core/di/service_locator.dart';
import 'package:srsappmultiplatform/presentation/viewmodels/UserViewModel.dart';
import 'package:srsappmultiplatform/presentation/views/login_screen.dart';
import 'package:srsappmultiplatform/presentation/views/register_screen.dart';
import 'package:srsappmultiplatform/data/repositories/user_repositoryImpl.dart'; // Make sure this import is correct


void main() {
  setupServiceLocator();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserViewModel>(
          create: (_) => UserViewModel(
            userRepository: UserRepositoryImpl(
              remoteDataSource: RemoteDataSource( authLocalStorage: AuthLocalStorage()),
              authLocalStorage: AuthLocalStorage(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/traineeDashboard': (context) => TraineeDashboardScreen()
        },
      ),

    );

  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Home Page"),
      ),
      body: Center(
        child: Text("Welcome to My Home Page"),
      ),
    );
  }

  }





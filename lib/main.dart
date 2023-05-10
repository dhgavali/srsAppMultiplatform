import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:srsappmultiplatform/data/datasources/auth_local_storage.dart';
import 'package:srsappmultiplatform/domain/repositories/SocketRepository.dart';
import 'package:srsappmultiplatform/presentation/viewmodels/SocketViewModel.dart';
import 'package:srsappmultiplatform/presentation/views/trainee_dashboard_screen.dart';
import 'package:srsappmultiplatform/data/datasources/remote/remote_data_source.dart';
import 'package:srsappmultiplatform/core/di/service_locator.dart';
import 'package:srsappmultiplatform/domain/repositories/WorkoutPlanRepository.dart';
import 'package:srsappmultiplatform/domain/entities/User.dart';
import 'package:srsappmultiplatform/presentation/viewmodels/UserViewModel.dart';
import 'package:srsappmultiplatform/presentation/views/login_screen.dart';
import 'package:srsappmultiplatform/presentation/views/register_screen.dart';
import 'package:srsappmultiplatform/presentation/views/ExerciseProgram_screen.dart';
import 'package:srsappmultiplatform/presentation/views/ChatPage_screen.dart';
import 'package:srsappmultiplatform/presentation/views/ProfilePage_screen.dart';
import 'package:srsappmultiplatform/data/repositories/user_repositoryImpl.dart'; // Make sure this import is correct

void main() {
  setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserViewModel>(
          create: (_) =>
              UserViewModel(
                userRepository: GetIt.I.get<UserRepositoryImpl>(),
                workoutPlanRepository: GetIt.I.get<WorkoutPlanRepository>(),
              ),
              
        ),
        ChangeNotifierProvider<SocketViewModel>(  // new changes
        create: (_) => SocketViewModel(
           socketRepository: GetIt.I.get<SocketRepository>(),
        ),
        )
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
          '/traineeDashboard': (context) => MyHomePage(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final int index;

  MyHomePage({Key? key, this.index = 0}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel userViewModel = Provider.of<UserViewModel>(context);
    userViewModel.getValidUser();

    return ValueListenableBuilder<User?>(
      valueListenable: userViewModel.userNotifier,
      builder: (context, user, child) {
        if (user == null) {
          return Scaffold(
          
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          body: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              TraineeDashboardScreen(),
              ExerciseProgram(userId: user.id),
              ChatPage(),
              ProfilePage(user: user),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center),
                label: 'Program',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _currentIndex,
            unselectedItemColor: Colors.black,
            selectedItemColor: Colors.blue,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              });
            },
          ),
        );
      },
    );
  }
}


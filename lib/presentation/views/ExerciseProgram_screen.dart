import 'package:flutter/material.dart';
import 'package:srsappmultiplatform/presentation/viewmodels/UserViewModel.dart';
import 'package:srsappmultiplatform/domain/entities/WorkoutPlanData.dart';
import 'package:srsappmultiplatform/presentation/views/WorkoutScreen.dart';

import 'package:provider/provider.dart';


  class ExerciseProgram extends StatefulWidget {
  final String userId;

  ExerciseProgram({required this.userId});

  @override
  _ExerciseProgramState createState() => _ExerciseProgramState();
  }

  class _ExerciseProgramState extends State<ExerciseProgram>
  with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedWeek = 1;
  List<WorkoutPlan> _workoutplan = [];

  @override
  void initState() {
  super.initState();
  _tabController = TabController(length: 12, vsync: this);
  _tabController.addListener(_handleTabSelection);

  // Fetch workout plans for the user
  WidgetsBinding.instance!.addPostFrameCallback((_) {
  UserViewModel userViewModel =
  Provider.of<UserViewModel>(context, listen: false);
  userViewModel.fetchWorkoutPlansByUserId(widget.userId).then((_) {
  setState(() {
  _workoutplan = userViewModel.workoutPlans;
  });
  });
  });
  }

  @override
  void dispose() {
  _tabController.dispose();
  super.dispose();
  }

  void _handleTabSelection() {
  setState(() {
  selectedWeek = _tabController.index + 1;
  });
  }

  Widget buildDayCard(int day) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutScreen(week: selectedWeek, day: day),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: CustomColors.pastelBlue,
        child: SizedBox(
          height: 170,
          width: double.maxFinite,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
                SizedBox(height: 15),
                Text(
                  'Day $day',
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                SizedBox(height: 8),
                Text(
                  "Workout Type",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Program'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white,
          tabs: List.generate(
              12,
                  (index) =>
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Week ${index + 1}'),
                  )),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(12, (index) {
          return ListView.builder(
            itemCount: 7,
            itemBuilder: (context, dayIndex) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
                child: buildDayCard(dayIndex + 1),
              );
            },
          );
        }),
      ),
    );
  }

}






class CustomColors {
  CustomColors._(); // this basically makes it so you can't instantiate it
  static const pastelBlue = Color(0xffB4D4F4);
}

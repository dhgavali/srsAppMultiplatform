import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srsappmultiplatform/presentation/viewmodels/UserViewModel.dart';
import 'package:srsappmultiplatform/presentation/widgets/CustomCheckbox.dart';
import 'package:srsappmultiplatform/presentation/views/ExerciseDescriptionScreen.dart';

import '../../theme/app_style.dart';

class WorkoutScreen extends StatefulWidget {
  final int week;
  final int day;

  WorkoutScreen({required this.week, required this.day});

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  List<List<Color>> color = [
    [
      Color.fromRGBO(233, 189, 138, 100),
      Color.fromRGBO(250, 217, 178, 100),
    ],
    [
      Color.fromRGBO(204, 186, 242, 100),
      Color.fromRGBO(223, 209, 252, 100),
    ],
  ];
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    final workoutPlans = userViewModel.workoutPlans
        .where((plan) => plan.week == widget.week && plan.day == widget.day)
        .toList();

    // Flatten the list of exercises from all workout plans
    final exercises = workoutPlans
        .map((workoutPlan) => workoutPlan.exercises)
        .expand((exercises) => exercises)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Week ${widget.week} - Day ${widget.day} Workout'),
        actions: [
          const Text("Save"),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Week-${widget.week} - day-${widget.day}',
                    style: AppStyle.txtMontserratBold2306,
                  ),
                  const Icon(Icons.notifications)
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: buildDayCard(
                          exercise.name.toString(),
                          '${exercise.sets}x${exercise.reps}',
                          index % 2 == 0 ? color[0] : color[1], index % 2 == 0 ? "assets/images/Rectangle 107.png" : "assets/images/Rectangle 108.png"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDayCard(
      String exerciseName, String setAndReps, List<Color> color,String imagePath) {
    return InkWell(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: color)),
          child: SizedBox(
            height: 130,
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$exerciseName',
                        style: AppStyle.txtRobotoRegular20,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        setAndReps,
                        style: AppStyle.txtMontserratSemiBold16,
                      ),
                    ],
                  ),
                ),
                Image.asset(imagePath,fit: BoxFit.cover,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

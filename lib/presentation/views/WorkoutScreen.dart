  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'package:srsappmultiplatform/presentation/viewmodels/UserViewModel.dart';
  import 'package:srsappmultiplatform/presentation/widgets/CustomCheckbox.dart';
  import 'package:srsappmultiplatform/presentation/views/ExerciseDescriptionScreen.dart';

  class WorkoutScreen extends StatefulWidget {
    final int week;
    final int day;

    WorkoutScreen({required this.week, required this.day});

    @override
    _WorkoutScreenState createState() => _WorkoutScreenState();
  }
  class _WorkoutScreenState extends State<WorkoutScreen> {
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
          actions: [Text("Save"),
          ],
        ),
        body: ListView.builder(
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            final exercise = exercises[index];
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseDescriptionScreen(exercise: exercise),
                  ),
                );
              },
              leading: CustomCheckbox(
                value: exercise.completed,
                onChanged: (bool newValue) {
                  setState(() {
                    exercise.completed = newValue;
                  });
                },
              ),
              title: Text(exercise.name),
              subtitle: Text('${exercise.sets} sets x ${exercise.reps} reps'),
            );
          },
        ),
      );
    }
  }

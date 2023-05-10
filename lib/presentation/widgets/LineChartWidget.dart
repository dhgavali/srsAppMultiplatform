  import 'package:flutter/material.dart';
  import 'package:srsappmultiplatform/domain/entities/TrainingVolume.dart';
  import 'package:srsappmultiplatform/domain/entities/WorkoutPlanData.dart';
  import 'package:provider/provider.dart';
  import 'package:srsappmultiplatform/presentation/viewmodels/UserViewModel.dart';
  import 'package:fl_chart/fl_chart.dart';

  class LineChartWidget extends StatefulWidget {
    String userId;

    String selectedTimeRange = 'days';
    LineChartWidget({required this.userId});

    @override
    State<LineChartWidget> createState() => _LineChartWidgetState();
  }

  class _LineChartWidgetState extends State<LineChartWidget> {
    List<WorkoutPlan> completedWorkoutListDay = [];
    List<WorkoutPlan> completedWorkoutListWeek = [];
    List<WorkoutPlan> completedWorkoutListMonth = [];
    List<WorkoutPlan> completedWorkoutList = [];

    @override
    Widget build(BuildContext context) {
      double index = 1;
      return AspectRatio(aspectRatio: 2,
        child: LineChart(LineChartData(lineBarsData: [LineChartBarData(
            spots: _selectedTimeRangeVolume("days").map((e) =>
                FlSpot(index++, e.volume.toDouble())).toList(),
            isCurved: false,
            dotData: FlDotData(show: true)
        )
        ])),
      );
    }

    @override
    void initState() {
      UserViewModel userViewModel =
      Provider.of<UserViewModel>(context, listen: false);
      userViewModel.fetchCompletedWorkoutPlans(widget.userId);
      completedWorkoutList =
      userViewModel.completedWorkoutPlans as List<WorkoutPlan>;
      print(" completedworkout  ${userViewModel.completedWorkoutPlans.toString()}");
    }

    List<TrainingVolume> _selectedTimeRangeVolume(String timeRange) {
      switch (timeRange) {
        case 'days':
          return completedWorkoutList.getDataForDays(1);
        case 'week':
          return [TrainingVolume("Week 1", completedWorkoutList.getVolumeForWeek(1)),
            TrainingVolume("Week 2", completedWorkoutList.getVolumeForWeek(2)),
            TrainingVolume("Week 3", completedWorkoutList.getVolumeForWeek(3)),
            TrainingVolume("Week 4", completedWorkoutList.getVolumeForWeek(4))];
        case 'months':
          return [TrainingVolume("Month 1", completedWorkoutList.getVolumeForMonth(1))];
      }
      return [];
    }

  }

  extension WorkoutPlanListExtension on List<WorkoutPlan> {
    List<TrainingVolume> getDataForDays(int weekNumber) {
      Map<String, int> volumeByDay = {};

      for (int i = 1; i <= 7; i++) {
        String dayLabel = 'Week $weekNumber Day $i';
        volumeByDay[dayLabel] = 0;
      }

      for (WorkoutPlan workoutPlan in this) {
        if (workoutPlan.week == weekNumber) {
          String dayLabel = 'Week $weekNumber Day ${workoutPlan.day}';
          for (var exercise in workoutPlan.exercises) {
            volumeByDay.update(dayLabel, (value) => value + exercise.sets * exercise.reps * exercise.weight);

          }
        }
      }

      return volumeByDay.entries
          .map((entry) => TrainingVolume(entry.key, entry.value))
          .toList();
    }

    int getVolumeForWeek(int weekNumber) {
      int totalVolume = 0;

      for (WorkoutPlan workoutPlan in this) {
        if (workoutPlan.week == weekNumber) {
          for (var exercise in workoutPlan.exercises) {
            totalVolume += exercise.sets * exercise.reps * exercise.weight;
          }
        }
      }

      return totalVolume;
    }

    int getVolumeForMonth(int monthNumber) {
      int totalVolume = 0;

      for (WorkoutPlan workoutPlan in this) {
        int workoutMonth = ((workoutPlan.week - 1) / 4).ceil();
        if (workoutMonth == monthNumber) {
          for (var exercise in workoutPlan.exercises) {
            totalVolume += exercise.sets * exercise.reps * exercise.weight;
          }
        }
      }

      return totalVolume;
    }
  }

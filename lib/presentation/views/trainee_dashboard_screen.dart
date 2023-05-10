import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srsappmultiplatform/main.dart';
import 'package:srsappmultiplatform/presentation/viewmodels/UserViewModel.dart';
import 'package:srsappmultiplatform/domain/entities/WorkoutPlanData.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:srsappmultiplatform/presentation/widgets/custom_image_view.dart';
import 'package:srsappmultiplatform/theme/app_style.dart';
import 'package:srsappmultiplatform/theme/app_style.dart';
import 'package:srsappmultiplatform/utils/size_utils.dart';
import 'package:srsappmultiplatform/utils/color_constant.dart';
import 'package:srsappmultiplatform/domain/entities/TrainingVolume.dart';
import 'package:srsappmultiplatform/domain/entities/User.dart';
import 'package:srsappmultiplatform/presentation/widgets/CustomMaxExerciseCard.dart';
import 'package:srsappmultiplatform/presentation/widgets/custom_app_bar.dart';
import 'package:srsappmultiplatform/presentation/widgets/LineChartWidget.dart';

import 'RequestScreen.dart';

class TraineeDashboardScreen extends StatefulWidget {

  @override
  _TraineeDashboardScreenState createState() => _TraineeDashboardScreenState();
}

class _TraineeDashboardScreenState extends State<TraineeDashboardScreen> {
  String selectedTimeRange = 'Week';
  User? user;
  List<String> muscles = ["chest", "shoulder"];

  @override
  void initState() {
    super.initState();
    // seriesList = _createSampleData();
    UserViewModel userViewModel =
        Provider.of<UserViewModel>(context, listen: false);
   userViewModel.fetchWorkoutPlansByUserId(userViewModel.user?.id ?? "");
    print("user Id ${userViewModel.user?.id ?? ""}");
    print("trainee dashboard ${userViewModel.user?.id ?? ""}");
    userViewModel.fetchWorkoutPlansByUserId(userViewModel.user?.id ?? "");
    print("trainee dashboard ${userViewModel.workoutPlans?.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        paddingHorizontal: 10,
        height: getVerticalSize(
          76,
        ),
        leadingWidth: 76,
        leading: Container(
            width: 56,
            height: 56,
            margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),


            ),
            child: CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage('assets/images/ellipse-1-bg.png'),
            )),
        title: Padding(
          padding: getPadding(
            left: 8,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: getPadding(
                    right: 60,
                  ),
                  child: Text(
                    "Welcome back",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtMontserratMedium12,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: getPadding(
                    top: 2,
                  ),
                  child: Text(
                    "${user?.username ?? ""} !🤘🏻",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtMontserratMedium16,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
        InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RequestScreen(),
        ),
      );
    },
    child: CustomImageView(
      svgPath: "assets/images/img_clock.svg",
      height: getSize(24),
      width: getSize(24),
      margin: getMargin(
        left: 20,
        top: 16,
        right: 20,
        bottom: 16,
      ),
    ),
  ),
        ],
      ),
      body: Consumer<UserViewModel>(
        builder: (context, userViewModel, _) {
          final user = userViewModel.user;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Volume Of Training",
                  style: AppStyle.txtRobotoRegular20,
                  ),
                  DropdownButton<String>(
                    value: selectedTimeRange,
                    items: [
                      DropdownMenuItem(
                        child: Text("Week"),
                        value: 'Week',
                      ),
                      DropdownMenuItem(
                        child: Text("Day"),
                        value: 'Day',
                      ),
                      DropdownMenuItem(
                        child: Text("Month"),
                        value: 'Month',
                      ),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTimeRange = newValue!;
                        //  seriesList = _createSampleData();
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: 250,
                    child: Container(
                      child: LineChartWidget(userId: user?.id ?? ""),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Today's Activity",
                            style: AppStyle.txtMontserratSemiBold16,
                          ),
                          Text(
                            "see all",
                            style: AppStyle.txtMontserratMedium12,
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(

                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: min(
                            3,
                            userViewModel.workoutPlans.isEmpty
                                ? 1
                                : userViewModel.workoutPlans
                                    .expand((plan) => plan.exercises)
                                    .length,
                          ),
                          itemBuilder: (context, index) {
                            if (userViewModel.workoutPlans.isEmpty) {
                              return Text('No workout plans found');
                            } else {
                              final exercises = userViewModel.workoutPlans
                                  .expand((plan) => plan.exercises)
                                  .toList();
                              final exercise = exercises[index];
                              return workoutRow(exercise.name, muscles,
                                  exercise.sets.toString());
                            }
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                                height: 5); // Adjust the height as needed
                          },
                        ),
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Max Status",
                            style: AppStyle.txtMontserratSemiBold16,
                          ),
                          Text(
                            "see all",
                            style: AppStyle.txtMontserratMedium12,
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(

                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            if (userViewModel.workoutPlans.isEmpty) {
                              return Text('No workout plans found');
                            } else {
                              final exercises = userViewModel.workoutPlans
                                  .expand((plan) => plan.exercises)
                                  .toList();
                              final exercise = exercises[index];
                              return workoutRow(exercise.name, muscles,
                                  exercise.sets.toString());
                            }
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                                height: 5); // Adjust the height as needed
                          },
                        ),
                      ),

                    ],
                  ),




                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Create sample data for the chart
  /*List<charts.Series<TrainingVolume, String>> _createSampleData() {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final completedWorkoutPlans = userViewModel.completedWorkoutPlans!!;

    final data = _generateDataForTimeRange(
        selectedTimeRange, completedWorkoutPlans);


    return [
      charts.Series<TrainingVolume, String>(
        id: 'TrainingVolume',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TrainingVolume trainingVolume, _) => trainingVolume.week,
        measureFn: (TrainingVolume trainingVolume, _) => trainingVolume.volume,
        data: data,
      )
    ];
  }*/

/*  List<TrainingVolume> _generateDataForTimeRange(String timeRange, List<WorkoutPlan> completedWorkoutPlans) {
    int calculateVolume(DateTime startTime, DateTime endTime) {
      int volume = 0;
      for (var workoutPlan in completedWorkoutPlans) {
        DateTime workoutDate = DateTime(workoutPlan.week * 7 + workoutPlan.day);
        if (workoutDate.isAfter(startTime) && workoutDate.isBefore(endTime)) {
          for (var exercise in workoutPlan.exercises) {
            volume += exercise.sets * exercise.reps * exercise.weight;
          }
        }
      }
      return volume;
    }*/

  List<TrainingVolume> _generateDataForTimeRange(String timeRange) {
    // Replace the following code with your actual data for different time ranges
    switch (timeRange) {
      case 'Day':
        return [
          TrainingVolume('Day 1', 20),
          TrainingVolume('Day 2', 10),
          TrainingVolume('Day 3', 30),
          TrainingVolume('Day 4', 25),
          TrainingVolume('Day 5', 25),
          TrainingVolume('Day 6', 25),
          TrainingVolume('Day 7', 25),
        ];
      case 'Month':
        return [
          TrainingVolume('Month 1', 400),
          TrainingVolume('Month 2', 320),
          TrainingVolume('Month 3', 600),
          TrainingVolume('Month 4', 450),
        ];
      case 'Week':
      default:
        return [
          TrainingVolume('Week 1', 100),
          TrainingVolume('Week 2', 80),
          TrainingVolume('Week 3', 200),
          TrainingVolume('Week 4', 150),
        ];
    }

    return [];
  }

  Widget workoutRow(
      String workoutTitle, List<String> tragetedMuscles, String sets) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: ColorConstant.gray200,
        borderRadius: BorderRadiusDirectional.horizontal(
            start: Radius.circular(5), end: Radius.circular(5)),
      ),
      width: double.maxFinite,
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                decoration: BoxDecoration(
                  color: randomColor(),
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30), bottom: Radius.circular(30)),
                ),
                child: SizedBox(
                  width: 7,
                  height: double.maxFinite,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    workoutTitle,
                    style: AppStyle.txtMontserratMedium16,
                  ),
                  Text(
                    '${tragetedMuscles.toString()} ',
                    style: AppStyle.txtMontserratMedium12,
                  ),
                ],
              ),
            ],
          ),
          Text(
            sets,
            style: AppStyle.txtMontserratSemiBold16,
          ),
        ],
      ),
    );
  }

  Color randomColor(){
    final random = Random();
    final List<Color> colorList = [
      ColorConstant.deepOrange400,
    ColorConstant.tealA700,
    ColorConstant.indigoA700
    ];
            return colorList[random.nextInt(3)];

  }

  Widget maxStatusRow(String exerciseTitle, String maxWeight) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: ColorConstant.gray200,
        borderRadius: BorderRadiusDirectional.horizontal(
            start: Radius.circular(5), end: Radius.circular(5)),
      ),
      width: double.maxFinite,
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            exerciseTitle,
            style: AppStyle.txtMontserratMedium16,
          ),
          Text(
            maxWeight,
            style: AppStyle.txtMontserratSemiBold16,
          ),
        ],
      ),
    );
  }

}

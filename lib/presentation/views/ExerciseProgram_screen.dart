import 'package:flutter/material.dart';
import 'package:srsappmultiplatform/presentation/viewmodels/UserViewModel.dart';
import 'package:srsappmultiplatform/domain/entities/WorkoutPlanData.dart';
import 'package:srsappmultiplatform/presentation/views/WorkoutScreen.dart';

import 'package:provider/provider.dart';
import 'package:srsappmultiplatform/theme/app_style.dart';

import '../widgets/customColoredTabs.dart';

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

  Widget buildDayCard(int day,   List<Color> color) {
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        child: Container(
          decoration:  BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: color
                  )),
          child: SizedBox(
            height: 130,
            width: double.maxFinite,
            child: Padding(
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
                    'Day $day',
                   style: AppStyle.txtRobotoRegular20,
                  ),
                  const SizedBox(height: 6),
                   Text(

                    "Workout Type",
                  style: AppStyle.txtMontserratSemiBold16,

                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      backgroundColor: Color.fromRGBO(239, 239, 239, 100),
      appBar: AppBar(
        title: Text('Exercise Program'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Discover",
                    style: AppStyle.txtMontserratBold2306,
                  ),
                  const Icon(Icons.notifications)
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Execises",
                style: AppStyle.txtMontserratMedium16,
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                // Add this Expanded widget
                child: DefaultTabController(
                  length: 12,
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade300,
                        ),
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.black45,
                        tabs: List.generate(
                          12,
                          (index) => ColoredTab(
                            text: 'Week ${index + 1}',
                            selectedColor: Colors.grey.shade300,
                            unselectedColor: Colors.grey.shade300,
                            isSelected: _tabController.index == index,
                          ),
                        ),
                      ),
                      Expanded(
                        // Remove this Expanded widget
                        child: TabBarView(
                          controller: _tabController,
                          children: List.generate(12, (index) {
                            return ListView.builder(
                              itemCount: 7,
                              itemBuilder: (context, dayIndex) {
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      15.0, 8.0, 15.0, 8.0),
                                  child: buildDayCard(
                                      dayIndex + 1,
                                      dayIndex % 2 == 0
                                          ?color[0]
                                          : color[1]),
                                );
                              },
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomColors {
  CustomColors._(); // this basically makes it so you can't instantiate it
  static const pastelBlue = Color(0xffB4D4F4);
}
